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

-(void)testCanProcessOnlyChangedRegionsBasedOnPreviousResult {
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"public" tokenType:EDKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"static" tokenType:EDKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"function" tokenType:EDDefinerKeywordToken]];
	
	EDLexicalToken *t1 = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 6)];
	EDLexicalToken *t2 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(6, 1)];
	EDLexicalToken *t3 = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(7, 6)];
	EDLexicalToken *t4 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(13, 1)];
	EDLexicalToken *t5 = [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(14, 8)];
	
	EDLexerResult *previousResult = [EDLexerResult resultWithTokens:[NSArray arrayWithObjects:t1, t2, t3, t4, t5, nil]];
	
	NSRange editedRange = NSMakeRange(11, 0);
	NSString *sourceAfter = @"public stat function"; // Was: public static function
	
	EDLexicalToken *tokenAtRange = [previousResult tokenAtRange:NSMakeRange(editedRange.location, 0)];
	EDLexerResult *newResult = [lexer lexString:sourceAfter
										  range:NSMakeRange(tokenAtRange.range.location, sourceAfter.length - tokenAtRange.range.location)
								 changeInLength:-2
								 previousResult:previousResult];
	EDLexicalToken *afterT1 = [newResult tokenAtRange:NSMakeRange(0, 6)];
	EDLexicalToken *afterT2 = [newResult tokenAtRange:NSMakeRange(6, 1)];
	
	EDLexicalToken *afterT3 = [newResult tokenAtRange:NSMakeRange(7, 4)];
	EDLexicalToken *afterT4 = [newResult tokenAtRange:NSMakeRange(11, 1)];
	EDLexicalToken *afterT5 = [newResult tokenAtRange:NSMakeRange(12, 8)];
	
	for (EDLexicalToken *t in newResult.tokens) {
		NSLog(@"newResult with token at (%d, %d)", t.range.location, t.range.length);
	}
	
	NSLog(@"previousResult token at (0,6) = %@", [previousResult tokenAtRange:NSMakeRange(0, 6)]);
	
	GHAssertEquals(t1, afterT1, @"Tokens should be the same object since the token has not changed");
	GHAssertEquals(t2, afterT2, @"Tokens should be the same object since the token has not changed");
	
	GHAssertEquals(EDUnmatchedCharacterToken, afterT3.type, @"Token type should be unmatched type");
	GHAssertEquals((NSUInteger) 7, afterT3.range.location, @"Token should be at location 7");
	GHAssertEquals((NSUInteger) 4, afterT3.range.length, @"Token length should be 4");
	
	GHAssertEquals(t4, afterT4, @"Tokens should be the same object since the token has not changed");
	GHAssertEquals(t5, afterT5, @"Tokens should be the same object since the token has not changed");
	GHAssertEquals(EDDefinerKeywordToken, afterT5.type, @"Token type should not have changed");
	GHAssertEquals((NSUInteger) 12, afterT5.range.location, @"Token should have moved to location 12");
	GHAssertEquals((NSUInteger) 8, afterT5.range.length, @"Token length should not have changed");
}

@end
