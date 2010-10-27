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
	EDLexer *lexer = [EDLexer lexer];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"foo" tokenType:EDKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"bar" tokenType:EDKeywordToken]];
	
	id<EDLexRule> rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer];
	
	NSString *source = @"abc <% foo bar %> def";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length)];
	
	GHAssertNil(tok, @"Nil should be returned since match does not fall in range");
}

-(void)testReturnsEmbeddedTokenIfFoundAtRange {
	EDLexer *lexer = [EDLexer lexer];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"foo" tokenType:EDKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"bar" tokenType:EDKeywordToken]];
	
	id<EDLexRule> rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer];
	
	NSString *source = @"abc <% foo bar %> def";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(4, source.length - 4)];
	
	GHAssertEquals(EDEmbeddedLanguageToken, tok.type, @"Type should be EDEmbeddedLanguageToken");
	GHAssertEquals((NSUInteger) 4, tok.range.location, @"Location should be 4");
	GHAssertEquals((NSUInteger) 13, tok.range.length, @"Length should be 13");
}

-(void)testIncludesResultFromSublexedRange {
	EDLexer *lexer = [EDLexer lexer];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"foo" tokenType:EDDefinerKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"zip" tokenType:EDKeywordToken]];
	
	id<EDLexRule> rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer];
	
	NSString *source = @"abc <% foo zip %> def";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(4, source.length - 4)];
	
	GHAssertNotNil(tok.sublexedResult, @"A sublexed result should be included");
	
	EDLexicalToken *embeddedTok1 = [tok.sublexedResult tokenAtRange:NSMakeRange(7, 3)];
	EDLexicalToken *embeddedTok2 = [tok.sublexedResult tokenAtRange:NSMakeRange(11, 3)];
	
	GHAssertNotNil(embeddedTok1, @"Token should exist at range (7,3)");
	GHAssertNotNil(embeddedTok2, @"Token should exist at range (11,3)");
	
	GHAssertEquals(EDDefinerKeywordToken, embeddedTok1.type, @"Sublexed result should include definer keyword at (7,3)");
	GHAssertEquals(EDKeywordToken, embeddedTok2.type, @"Sublexed result should include keyword at 11,3)");
}

-(void)testComplexEmbeddedLexing {
	EDLexer *lexer = [EDLexer lexer];
	[lexer addRule:[EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" tokenType:EDString1Token]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"foo" tokenType:EDDefinerKeywordToken]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"zip" tokenType:EDKeywordToken]];
	
	id<EDLexRule> rule = [EDEmbeddedLanguageLexRule ruleWithStart:@"<%" end:@"%>" lexer:lexer];
	
	NSString *source = @"abc <% foo \"this is not the end %>\" zip %> def";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(4, source.length - 4)];
	
	GHAssertEquals(EDEmbeddedLanguageToken, tok.type, @"Type should be EDEmbeddedLanguageToken");
	GHAssertEquals((NSUInteger) 4, tok.range.location, @"Location should be 4");
	GHAssertEquals((NSUInteger) 38, tok.range.length, @"Length should be 38");
	
	GHAssertNotNil(tok.sublexedResult, @"A sublexed result should be included");
	
	EDLexicalToken *embeddedTok1 = [tok.sublexedResult tokenAtRange:NSMakeRange(7, 3)];
	EDLexicalToken *embeddedTok2 = [tok.sublexedResult tokenAtRange:NSMakeRange(11, 24)];
	EDLexicalToken *embeddedTok3 = [tok.sublexedResult tokenAtRange:NSMakeRange(36, 3)];
	
	GHAssertNotNil(embeddedTok1, @"Token should exist at range (7,3)");
	GHAssertNotNil(embeddedTok2, @"Token should exist at range (11,24)");
	GHAssertNotNil(embeddedTok3, @"Token should exist at range (36,3)");
	
	GHAssertEquals(EDDefinerKeywordToken, embeddedTok1.type, @"Sublexed result should include definer keyword at (7,3)");
	GHAssertEquals(EDString1Token, embeddedTok2.type, @"Sublexed result should include string at (11,24)");
	GHAssertEquals(EDKeywordToken, embeddedTok3.type, @"Sublexed result should include keyword at (36,3)");
}

@end
