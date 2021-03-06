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
	
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"foo" tokenType:EDKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"bar" tokenType:EDKeywordToken]];
	
	EDLexRule *rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo bar %> def";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length) states:states];
	
	GHAssertNil(tok, @"Nil should be returned since match does not fall in range");
	
	[states release];
}

-(void)testReturnsEmbeddedTokenDelimiterIfFoundAtRange {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSUInteger s1 = [states stateNamed:@"s1"];
	
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"foo" tokenType:EDKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"bar" tokenType:EDKeywordToken]];
	
	EDLexRule * rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo bar %> def";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(4, source.length - 4) states:states];
	
	GHAssertEquals(EDEmbeddedLanguageDelimiterToken, tok.type, @"Type should be EDEmbeddedLanguageDelimiterToken");
	GHAssertEquals((NSUInteger) 4, tok.range.location, @"Location should be 4");
	GHAssertEquals((NSUInteger) 2, tok.range.length, @"Length should be 2");
	
	[states release];
}

-(void)testPushesIntoEmbeddedStateAfterStartingDelimiter {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSUInteger s1 = [states stateNamed:@"s1"];
	
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"foo" tokenType:EDKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"bar" tokenType:EDKeywordToken]];
	
	EDLexRule *rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo bar %> def";
	
	[rule lexInString:source range:NSMakeRange(4, source.length - 4) states:states];
	
	GHAssertEquals(s1, states.currentState, @"State should be changed");
	
	[states release];
}

-(void)testIncludesResultFromSublexedRange {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSUInteger s1 = [states stateNamed:@"s1"];
	
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"foo" tokenType:EDDefinerKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"zip" tokenType:EDKeywordToken]];
	
	EDLexRule *rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo zip %> def";
	
	[states pushState:s1];
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(7, source.length - 7) states:states];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"Token should be type EDDefinerKeywordToken");
	
	[states release];
}

-(void)testPopsBackOutOfEmbeddedStateAfterFindingEndingDelimiter {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	
	NSUInteger s1 = [states stateNamed:@"s1"];
	
	EDLexer *lexer = [EDLexer lexerWithStates:states];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"foo" tokenType:EDKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"bar" tokenType:EDKeywordToken]];
	
	EDLexRule *rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer usingState:s1];
	
	NSString *source = @"abc <% foo bar %> def";
	
	[states pushState:s1];
	
	[rule lexInString:source range:NSMakeRange(15, source.length - 15) states:states];
	
	GHAssertEquals((NSUInteger) 0, states.currentState, @"State should be reset");
	
	[states release];
}

@end
