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
	EDLexerResult *result = [EDLexerResult result];
	[lexer lexString:source intoResult:result];
	
	GHAssertEquals((NSUInteger) 3, [result.tokens count], @"3 tokens should be found");
	
	NSUInteger i;
	for (i = 0; i < 3; ++i) {
		EDLexicalToken *tok = [result.tokens objectAtIndex:i];
		GHAssertEquals(EDUnmatchedToken, tok.type, @"Type should be EDUnmatchedToken");
		GHAssertEquals((NSUInteger) i, tok.range.location, @"Range location should match char location");
		GHAssertEquals((NSUInteger) 1, tok.range.length, @"Range length should always be 1");
	}
}

-(void)testFindsTokensSpecifiedByRules {
	NSString *source = @"-function-";
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"function" tokenType:EDDefinerKeywordToken caseInsensitive:NO]];
	
	EDLexerResult *result = [EDLexerResult result];
	[lexer lexString:source intoResult:result];
	
	GHAssertEquals((NSUInteger) 3, [result.tokens count], @"3 tokens should be found");
	
	EDLexicalToken *t1 = [result.tokens objectAtIndex:0];
	EDLexicalToken *t2 = [result.tokens objectAtIndex:1];
	EDLexicalToken *t3 = [result.tokens objectAtIndex:2];
	
	GHAssertEquals(EDUnmatchedToken, t1.type, @"First token should be EDUnmatchedToken");
	GHAssertEquals(EDDefinerKeywordToken, t2.type, @"Second token should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 1, t2.range.location, @"Second token should be at offset 1");
	GHAssertEquals((NSUInteger) 8, t2.range.length, @"Second token should have a length of 8");
	GHAssertEquals(EDUnmatchedToken, t3.type, @"Third token should be EDUnmatchedToken");
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
	
	EDLexerResult *result = [EDLexerResult result];
	[lexer lexString:source intoResult:result];
	
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
	
	result = [EDLexerResult result];
	[lexer lexString:source intoResult:result];
	
	tok = [result tokenAtRange:NSMakeRange(0, 8)];
	
	GHAssertEquals(EDKeywordToken, tok.type, @"Second rule should be used since state is not s1");
	
	
	EDLexerStatesInfo stackInfo;
	stackInfo.stack[0] = 0;
	stackInfo.stackSize = 1;
	stackInfo.currentState = s1;
	
	[lexer.states applyStackInfo:stackInfo];
	
	result = [EDLexerResult result];
	[lexer lexString:source intoResult:result];
	
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
	
	result = [EDLexerResult result];
	[lexer lexString:source intoResult:result];
	
	tok = [result tokenAtRange:NSMakeRange(0, 8)];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"First rule should be used since state is still the initial state");
	
	EDLexerStatesInfo stackInfo;
	stackInfo.stack[0] = 0;
	stackInfo.stackSize = 1;
	stackInfo.currentState = s1;
	
	[lexer.states applyStackInfo:stackInfo];
	
	result = [EDLexerResult result];
	[lexer lexString:source intoResult:result];
	
	tok = [result tokenAtRange:NSMakeRange(0, 8)];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"First rule should be used since state is s1");
	
	[states release];
}

-(void)testDoesNotDuplicateTokensGivenEnoughInformationAboutInsertions {
	NSString *editedString = @"function foo_bar test";
	NSRange editedRange = {12, 1};
	NSInteger changeInLength = 1;
	
	EDLexicalToken *t1 = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 8)]; // 'function'
	EDLexicalToken *wst1 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(8, 1)]; // ' '
	EDLexicalToken *t2 = [EDLexicalToken tokenWithType:EDVariableToken range:NSMakeRange(9, 6)]; // 'foobar'
	EDLexicalToken *wst2 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(15, 1)]; // ' '
	EDLexicalToken *t3 = [EDLexicalToken tokenWithType:EDVariableToken range:NSMakeRange(16, 4)]; // 'test'
	
	EDLexerResult *previousResult = [EDLexerResult resultWithTokens:[NSArray arrayWithObjects:t1, wst1, t2, wst2, t3, nil]];
	
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"function" tokenType:EDKeywordToken]];
	[lexer addRule:[EDPatternLexRule ruleWithPattern:@"^[a-z0-9_]+" tokenType:EDVariableToken]];
	
	EDLexerResult *newResult = [EDLexerResult result];
	
	[lexer lexString:editedString
		 editedRange:editedRange
	  changeInLength:changeInLength
	  previousResult:previousResult
		  intoResult:newResult];
	
	GHAssertEquals(t1, [newResult.tokens objectAtIndex:0], @"First token should be the same instance as previously");
	GHAssertEquals(wst1, [newResult.tokens objectAtIndex:1], @"Second token should be the same instance as previously");
	GHAssertNotEquals(t2, [newResult.tokens objectAtIndex:2], @"Third token should NOT be the same instance as previously");
	GHAssertEquals(wst2, [newResult.tokens objectAtIndex:3], @"Fourth token should be the same instance as previously");
	GHAssertEquals(t3, [newResult.tokens objectAtIndex:4], @"Fifth token should be the same instance as previously");
	
	EDLexicalToken *newT2 = [newResult.tokens objectAtIndex:2];
	
	GHAssertEquals(EDVariableToken, newT2.type, @"New token should be EDVariableToken");
	GHAssertTrue(NSEqualRanges(NSMakeRange(9, 7), newT2.range), @"New token range should be (9,7)");
	
	GHAssertTrue(NSEqualRanges(NSMakeRange(0, 8), t1.range), @"First token should not have moved");
	GHAssertTrue(NSEqualRanges(NSMakeRange(8, 1), wst1.range), @"Second token should not have moved");
	GHAssertTrue(NSEqualRanges(NSMakeRange(16, 1), wst2.range), @"Fourth token should have moved by 1");
	GHAssertTrue(NSEqualRanges(NSMakeRange(17, 4), t3.range), @"Fifth token should have moved by 1");
}

-(void)testDoesNotDuplicateTokensGivenEnoughInformationAboutDeletions {
	NSString *editedString = @"function foobar test";
	NSRange editedRange = {12, 0};
	NSInteger changeInLength = -1;
	
	EDLexicalToken *t1 = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 8)]; // 'function'
	EDLexicalToken *wst1 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(8, 1)]; // ' '
	EDLexicalToken *t2 = [EDLexicalToken tokenWithType:EDVariableToken range:NSMakeRange(9, 7)]; // 'foo_bar'
	EDLexicalToken *wst2 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(16, 1)]; // ' '
	EDLexicalToken *t3 = [EDLexicalToken tokenWithType:EDVariableToken range:NSMakeRange(17, 4)]; // 'test'
	
	EDLexerResult *previousResult = [EDLexerResult resultWithTokens:[NSArray arrayWithObjects:t1, wst1, t2, wst2, t3, nil]];
	
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"function" tokenType:EDKeywordToken]];
	[lexer addRule:[EDPatternLexRule ruleWithPattern:@"^[a-z0-9_]+" tokenType:EDVariableToken]];
	
	EDLexerResult *newResult = [EDLexerResult result];
	
	[lexer lexString:editedString
		 editedRange:editedRange
	  changeInLength:changeInLength
	  previousResult:previousResult
		  intoResult:newResult];
	
	GHAssertEquals(t1, [newResult.tokens objectAtIndex:0], @"First token should be the same instance as previously");
	GHAssertEquals(wst1, [newResult.tokens objectAtIndex:1], @"Second token should be the same instance as previously");
	GHAssertNotEquals(t2, [newResult.tokens objectAtIndex:2], @"Third token should NOT be the same instance as previously");
	GHAssertEquals(wst2, [newResult.tokens objectAtIndex:3], @"Fourth token should be the same instance as previously");
	GHAssertEquals(t3, [newResult.tokens objectAtIndex:4], @"Fifth token should be the same instance as previously");
	
	EDLexicalToken *newT2 = [newResult.tokens objectAtIndex:2];
	
	GHAssertEquals(EDVariableToken, newT2.type, @"New token should be EDVariableToken");
	GHAssertTrue(NSEqualRanges(NSMakeRange(9, 6), newT2.range), @"New token range should be (9,7)");
	
	GHAssertTrue(NSEqualRanges(NSMakeRange(0, 8), t1.range), @"First token should not have moved");
	GHAssertTrue(NSEqualRanges(NSMakeRange(8, 1), wst1.range), @"Second token should not have moved");
	GHAssertTrue(NSEqualRanges(NSMakeRange(15, 1), wst2.range), @"Fourth token should have moved by -1");
	GHAssertTrue(NSEqualRanges(NSMakeRange(16, 4), t3.range), @"Fifth token should have moved by -1");
}

@end
