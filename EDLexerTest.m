//
//  EDLexerTest.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDLexerTest : GHTestCase
@end


@implementation EDLexerTest

-(void)testFindsSingleCharactersByDefault {
	NSString *source = @"***";
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	EDLexerResult *result = [lexer lexString:source];
	
	GHAssertEquals((NSUInteger) 3, [result.tokens count], @"3 tokens should be found");
	
	NSUInteger i;
	for (i = 0; i < 3; ++i) {
		EDLexicalToken *tok = [result.tokens objectAtIndex:i];
		GHAssertEquals(EDUnmatchedCharacterToken, tok.type, @"Type should be EDUnmatchedCharacterToken");
		GHAssertEquals((NSUInteger) i, tok.range.location, @"Range location should match char location");
		GHAssertEquals((NSUInteger) 1, tok.range.length, @"Range length should always be 1");
	}
}

-(void)testFindsTokensSpecifiedByRules {
	NSString *source = @"-function-";
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"function" tokenType:EDDefinerKeywordToken caseInsensitive:NO]];
	
	EDLexerResult *result = [lexer lexString:source];
	
	GHAssertEquals((NSUInteger) 3, [result.tokens count], @"3 tokens should be found");
	
	EDLexicalToken *t1 = [result.tokens objectAtIndex:0];
	EDLexicalToken *t2 = [result.tokens objectAtIndex:1];
	EDLexicalToken *t3 = [result.tokens objectAtIndex:2];
	
	GHAssertEquals(EDUnmatchedCharacterToken, t1.type, @"First token should be EDUnmatchedCharacterToken");
	GHAssertEquals(EDDefinerKeywordToken, t2.type, @"Second token should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 1, t2.range.location, @"Second token should be at offset 1");
	GHAssertEquals((NSUInteger) 8, t2.range.length, @"Second token should have a length of 8");
	GHAssertEquals(EDUnmatchedCharacterToken, t3.type, @"Third token should be EDUnmatchedCharacterToken");
}

-(void)testUsesTheLongestMatchIfNotDefiniteAndAmbiguous {
	NSString *source = @"function";
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	EDLexRule *r1 = [EDExactStringLexRule ruleWithString:@"func" tokenType:EDDefinerKeywordToken caseInsensitive:NO];
	r1.isDefinite = NO;
	EDLexRule *r2 = [EDExactStringLexRule ruleWithString:@"function" tokenType:EDDefinerKeywordToken caseInsensitive:NO];
	r2.isDefinite = NO;
	
	[lexer addRule:r1];
	[lexer addRule:r2];
	
	EDLexerResult *result = [lexer lexString:source];
	
	GHAssertEquals((NSUInteger) 1, [result.tokens count], @"1 token should be found");
	
	EDLexicalToken *tok = [result.tokens objectAtIndex:0];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"Token should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 0, tok.range.location, @"Token should be at offset 0");
	GHAssertEquals((NSUInteger) 8, tok.range.length, @"Token should have a length of 8");
}

-(void)testCanExecuteRulesConstrainedToAKnownState {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSString *source = @"function";
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	
	NSUInteger s1 = [lexer.states stateNamed:@"s1"];
	
	EDLexRule * r1 = [EDExactStringLexRule ruleWithString:@"function" tokenType:EDDefinerKeywordToken caseInsensitive:NO];
	r1.exclusiveState = s1;
	
	[lexer addRule:r1];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"function" tokenType:EDKeywordToken caseInsensitive:NO]];
	
	EDLexerResult *result;
	EDLexicalToken *tok;
	
	result = [lexer lexString:source];
	tok = [result tokenAtRange:NSMakeRange(0, 8)];
	
	GHAssertEquals(EDKeywordToken, tok.type, @"Second rule should be used since state is not s1");
	
	NSUInteger stack[] = {0};
	
	[lexer.states setStack:stack length:1 currentState:s1];
	
	result = [lexer lexString:source];
	tok = [result tokenAtRange:NSMakeRange(0, 8)];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"First rule should be used since state is s1");
	
	[states release];
}

-(void)testCanExecuteRulesConstrainedToInclusiveStates {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSString *source = @"function";
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	
	NSUInteger s1 = [lexer.states stateNamed:@"s1"];
	
	EDLexRule * r1 = [EDExactStringLexRule ruleWithString:@"function" tokenType:EDDefinerKeywordToken caseInsensitive:NO];
	r1.inclusiveState = s1;
	
	[lexer addRule:r1];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"function" tokenType:EDKeywordToken caseInsensitive:NO]];
	
	EDLexerResult *result;
	EDLexicalToken *tok;
	
	result = [lexer lexString:source];
	tok = [result tokenAtRange:NSMakeRange(0, 8)];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"First rule should be used since state is still the initial state");
	
	NSUInteger stack[] = {0};
	
	[lexer.states setStack:stack length:1 currentState:s1];
	
	result = [lexer lexString:source];
	tok = [result tokenAtRange:NSMakeRange(0, 8)];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"First rule should be used since state is s1");
	
	[states release];
}

@end
