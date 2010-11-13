//
//  EDEmbeddedLanguageLexRuleTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDEmbeddedLanguageLexRuleTest : GHTestCase
@end


@implementation EDEmbeddedLanguageLexRuleTest

-(void)testReturnsNilIfNoMatchInRange {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	
	NSUInteger s1 = [states stateNamed:@"s1"];
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"foo" caseInsensitive:NO];
	r1.tokenType = EDKeywordToken;
	
	EDLexRule *r2 = [EDExactMatchLexRule ruleWithString:@"bar" caseInsensitive:NO];
	r2.tokenType = EDKeywordToken;
	
	[lexer addRule:r1];
	[lexer addRule:r2];
	
	EDLexRule *rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo bar %> def";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length) buffer:nil states:states];
	
	GHAssertNil(tok, @"Nil should be returned since match does not fall in range");
	
	[states release];
}

-(void)testReturnsEmbeddedTokenDelimiterIfFoundAtRange {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSUInteger s1 = [states stateNamed:@"s1"];
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"foo" caseInsensitive:NO];
	r1.tokenType = EDKeywordToken;
	
	EDLexRule *r2 = [EDExactMatchLexRule ruleWithString:@"bar" caseInsensitive:NO];
	r2.tokenType = EDKeywordToken;
	
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	[lexer addRule:r1];
	[lexer addRule:r2];
	
	EDLexRule * rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo bar %> def";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(4, source.length - 4) buffer:nil states:states];
	
	GHAssertEquals(EDEmbeddedLanguageDelimiterToken, tok.type, @"Type should be EDEmbeddedLanguageDelimiterToken");
	GHAssertEquals((NSUInteger) 4, tok.range.location, @"Location should be 4");
	GHAssertEquals((NSUInteger) 2, tok.range.length, @"Length should be 2");
	
	[states release];
}

-(void)testPushesIntoEmbeddedStateAfterStartingDelimiter {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSUInteger s1 = [states stateNamed:@"s1"];
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"foo" caseInsensitive:NO];
	r1.tokenType = EDKeywordToken;
	
	EDLexRule *r2 = [EDExactMatchLexRule ruleWithString:@"bar" caseInsensitive:NO];
	r2.tokenType = EDKeywordToken;
	
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	[lexer addRule:r1];
	[lexer addRule:r2];
	
	EDLexRule *rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo bar %> def";
	
	[rule lexInString:source range:NSMakeRange(4, source.length - 4) buffer:nil states:states];
	
	GHAssertEquals(s1, states.currentState, @"State should be changed");
	
	[states release];
}

-(void)testIncludesResultFromSublexedRange {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSUInteger s1 = [states stateNamed:@"s1"];
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"foo" caseInsensitive:NO];
	r1.tokenType = EDDefinerKeywordToken;
	
	EDLexRule *r2 = [EDExactMatchLexRule ruleWithString:@"zip" caseInsensitive:NO];
	r2.tokenType = EDKeywordToken;
	
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	[lexer addRule:r1];
	[lexer addRule:r2];
	
	EDLexRule *rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo zip %> def";
	
	[states pushState:s1];
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(7, source.length - 7) buffer:nil states:states];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"Token should be type EDDefinerKeywordToken");
	
	[states release];
}

-(void)testPopsBackOutOfEmbeddedStateAfterFindingEndingDelimiter {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSUInteger s1 = [states stateNamed:@"s1"];
	
	EDLexRule *r1 = [EDExactMatchLexRule ruleWithString:@"foo" caseInsensitive:NO];
	r1.tokenType = EDKeywordToken;
	
	EDLexRule *r2 = [EDExactMatchLexRule ruleWithString:@"bar" caseInsensitive:NO];
	r2.tokenType = EDKeywordToken;
	
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	[lexer addRule:r1];
	[lexer addRule:r2];
	
	EDLexRule *rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo bar %> def";
	
	[states pushState:s1];
	
	[rule lexInString:source range:NSMakeRange(15, source.length - 15) buffer:nil states:states];
	
	GHAssertEquals((NSUInteger) 0, states.currentState, @"State should be reset");
	
	[states release];
}

@end
