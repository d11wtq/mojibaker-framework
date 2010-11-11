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
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"function" caseInsensitive:NO];
	r1.tokenType = EDDefinerKeywordToken;
	
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	[lexer addRule:r1];
	
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
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"func" caseInsensitive:NO];
	r1.tokenType = EDDefinerKeywordToken;
	r1.isDefinite = NO;
	
	EDLexRule *r2 = [EDExactMatchLexRule ruleWithString:@"function" caseInsensitive:NO];
	r2.tokenType = EDDefinerKeywordToken;
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
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"function" caseInsensitive:NO];
	r1.tokenType = EDDefinerKeywordToken;
	r1.state = s1;
	r1.isStateInclusive = NO;
	
	EDLexRule *r2 = [EDExactMatchLexRule ruleWithString:@"function" caseInsensitive:NO];
	r2.tokenType = EDKeywordToken;
	
	[lexer addRule:r1];
	[lexer addRule:r2];
	
	EDLexerResult *result;
	EDLexicalToken *tok;
	
	result = [EDLexerResult result];
	[lexer lexString:source intoResult:result];
	
	tok = [result tokenAtRange:NSMakeRange(0, 8)];
	
	GHAssertEquals(EDKeywordToken, tok.type, @"Second rule should be used since state is not s1");
	
	NSArray *stack = [NSArray arrayWithObject:[NSNumber numberWithUnsignedInteger:0]];
	EDLexerStatesSnapshot *snapshot = [EDLexerStatesSnapshot snapshotWithStack:stack currentState:s1];
	
	[lexer.states applySnapshot:snapshot];
	
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
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"function" caseInsensitive:NO];
	r1.tokenType = EDDefinerKeywordToken;
	r1.state = s1;
	r1.isStateInclusive = YES;
	
	EDLexRule *r2 = [EDExactMatchLexRule ruleWithString:@"function" caseInsensitive:NO];
	r2.tokenType = EDKeywordToken;
	
	[lexer addRule:r1];
	[lexer addRule:r2];
	
	EDLexerResult *result;
	EDLexicalToken *tok;
	
	result = [EDLexerResult result];
	[lexer lexString:source intoResult:result];
	
	tok = [result tokenAtRange:NSMakeRange(0, 8)];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"First rule should be used since state is still the initial state");
	
	
	NSArray *stack = [NSArray arrayWithObject:[NSNumber numberWithUnsignedInteger:0]];
	EDLexerStatesSnapshot *snapshot = [EDLexerStatesSnapshot snapshotWithStack:stack currentState:s1];
	
	[lexer.states applySnapshot:snapshot];
	
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
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"function" caseInsensitive:NO];
	r1.tokenType = EDKeywordToken;
	
	EDLexRule *r2 = [EDPatternLexRule ruleWithPattern:@"^[a-z0-9_]+"];
	r2.tokenType = EDVariableToken;
	
	EDLexRule *r3 = [EDPatternLexRule ruleWithPattern:@"^\\s+"];
	r3.tokenType = EDWhitespaceToken;
	
	EDLexer *lexer = [EDLexer lexerWithStates:[EDLexerStates states]];
	
	EDLexicalToken *t1 = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 8) value:@"function" rule:r1];
	t1.statesSnapshot = [lexer.states snapshot];
	
	EDLexicalToken *wst1 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(8, 1) value:@" " rule:r3];
	wst1.statesSnapshot = [lexer.states snapshot];
	
	EDLexicalToken *t2 = [EDLexicalToken tokenWithType:EDVariableToken range:NSMakeRange(9, 6) value:@"foobar" rule:r2];
	t2.statesSnapshot = [lexer.states snapshot];
	
	EDLexicalToken *wst2 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(15, 1) value:@" " rule:r3];
	wst2.statesSnapshot = [lexer.states snapshot];
	
	EDLexicalToken *t3 = [EDLexicalToken tokenWithType:EDVariableToken range:NSMakeRange(16, 4) value:@"test" rule:r2];
	t3.statesSnapshot = [lexer.states snapshot];
	
	EDLexerResult *previousResult = [EDLexerResult resultWithTokens:[NSArray arrayWithObjects:t1, wst1, t2, wst2, t3, nil]];
	
	[lexer addRule:r1];
	[lexer addRule:r2];
	[lexer addRule:r3];
	
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
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"function" caseInsensitive:NO];
	r1.tokenType = EDKeywordToken;
	
	EDLexRule *r2 = [EDPatternLexRule ruleWithPattern:@"^[a-z0-9_]+"];
	r2.tokenType = EDVariableToken;
	
	EDLexRule *r3 = [EDPatternLexRule ruleWithPattern:@"^\\s+"];
	r3.tokenType = EDWhitespaceToken;
	
	EDLexer *lexer = [EDLexer lexerWithStates:[EDLexerStates states]];
	
	EDLexicalToken *t1 = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 8) value:@"function" rule:r1];
	t1.statesSnapshot = [lexer.states snapshot];
	
	EDLexicalToken *wst1 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(8, 1) value:@" " rule:r3];
	wst1.statesSnapshot = [lexer.states snapshot];
	
	EDLexicalToken *t2 = [EDLexicalToken tokenWithType:EDVariableToken range:NSMakeRange(9, 7) value:@"foo_bar" rule:r2];
	t2.statesSnapshot = [lexer.states snapshot];
	
	EDLexicalToken *wst2 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(16, 1) value:@" " rule:r3];
	wst2.statesSnapshot = [lexer.states snapshot];
	
	EDLexicalToken *t3 = [EDLexicalToken tokenWithType:EDVariableToken range:NSMakeRange(17, 4) value:@"test" rule:r2];
	t3.statesSnapshot = [lexer.states snapshot];
	
	EDLexerResult *previousResult = [EDLexerResult resultWithTokens:[NSArray arrayWithObjects:t1, wst1, t2, wst2, t3, nil]];
	
	[lexer addRule:r1];
	[lexer addRule:r2];
	[lexer addRule:r3];
	
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

#pragma mark -
#pragma mark Complex state tests

-(void)testComplexStateSwitching {
	EDLexer *lexer = [EDLexer lexerWithStates:[EDLexerStates states]];
	
	NSUInteger genericScope = [lexer.states stateNamed:@"genericScope"];
	NSUInteger funcDefScope = [lexer.states stateNamed:@"funcDefScope"];
	NSUInteger funcScope = [lexer.states stateNamed:@"funcScope"];
	
	EDLexRule *fn = [EDExactMatchLexRule ruleWithString:@"function" caseInsensitive:NO];
	fn.tokenType = EDDefinerKeywordToken;
	fn.pushState = funcDefScope;
	
	[lexer addRule:fn];
	
	EDLexRule *fnName = [EDPatternLexRule ruleWithPattern:@"^[a-z]+"];
	fnName.tokenType = EDFunctionDefinitionToken;
	fnName.state = funcDefScope;
	fnName.isStateInclusive = NO;
	
	[lexer addRule:fnName];
	
	EDLexRule *fnScopeOpen = [EDCharacterLexRule ruleWithUnicodeChar:'{'];
	fnScopeOpen.tokenType = EDBraceToken;
	fnScopeOpen.state = funcDefScope;
	fnScopeOpen.isStateInclusive = NO;
	fnScopeOpen.beginState = funcScope;
	
	[lexer addRule:fnScopeOpen];
	
	EDLexRule *fnScopeClose = [EDCharacterLexRule ruleWithUnicodeChar:'}'];
	fnScopeClose.tokenType = EDBraceToken;
	fnScopeClose.state = funcScope;
	fnScopeClose.isStateInclusive = NO;
	fnScopeClose.popsState = YES;
	
	[lexer addRule:fnScopeClose];
	
	EDLexRule *scopeOpen = [EDCharacterLexRule ruleWithUnicodeChar:'{'];
	scopeOpen.tokenType = EDBraceToken;
	scopeOpen.pushState = genericScope;
	
	[lexer addRule:scopeOpen];
	
	EDLexRule *scopeClose = [EDCharacterLexRule ruleWithUnicodeChar:'}'];
	scopeClose.tokenType = EDBraceToken;
	scopeClose.state = genericScope;
	scopeClose.isStateInclusive = NO;
	scopeClose.popsState = YES;
	
	[lexer addRule:scopeClose];
	
	EDLexerResult *result = [EDLexerResult result];
	
	[lexer lexString:@"function test() { x { y } } z" intoResult:result];
	
	EDLexicalToken *fnTok = [result tokenAtRange:NSMakeRange(0, 8)];
	GHAssertEquals(EDDefinerKeywordToken, fnTok.type, @"Token type should be definer keyword");
	
	EDLexicalToken *fnNameTok = [result tokenAtRange:NSMakeRange(9, 4)];
	GHAssertEquals(EDFunctionDefinitionToken, fnNameTok.type, @"Token type should be function definition");
	GHAssertEquals(funcDefScope, fnNameTok.statesSnapshot.currentState, @"State should be funcDefScope");
	
	EDLexicalToken *wspTok = [result tokenAtRange:NSMakeRange(17, 1)];
	GHAssertEquals(EDWhitespaceToken, wspTok.type, @"Token type should be whitespace");
	GHAssertEquals(funcScope, wspTok.statesSnapshot.currentState, @"State should be funcScope");
	
	EDLexicalToken *wsp2Tok = [result tokenAtRange:NSMakeRange(21, 1)];
	GHAssertEquals(EDWhitespaceToken, wsp2Tok.type, @"Token type should be whitespace");
	GHAssertEquals(genericScope, wsp2Tok.statesSnapshot.currentState, @"State should be genericScope");
	
	EDLexicalToken *wsp3Tok = [result tokenAtRange:NSMakeRange(25, 1)];
	GHAssertEquals(EDWhitespaceToken, wsp3Tok.type, @"Token type should be whitespace");
	GHAssertEquals(funcScope, wsp3Tok.statesSnapshot.currentState, @"State should be funcScope");
	
	EDLexicalToken *wsp4Tok = [result tokenAtRange:NSMakeRange(27, 1)];
	GHAssertEquals(EDWhitespaceToken, wsp4Tok.type, @"Token type should be whitespace");
	GHAssertEquals((NSUInteger) 0, wsp4Tok.statesSnapshot.currentState, @"State should be initial state");
}

@end
