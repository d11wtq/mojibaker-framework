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
	NSString *source = @"abc";
	EDLexer *lexer = [EDLexer lexer];
	NSArray *tokens = [lexer tokensInString:source];
	
	GHAssertEquals((NSUInteger) 3, [tokens count], @"3 tokens should be found");
	
	NSUInteger i;
	for (i = 0; i < 3; ++i) {
		EDLexicalToken *tok = [tokens objectAtIndex:i];
		GHAssertEquals((NSUInteger) EDUnmatchedCharacterToken, tok.type, @"Type should be EDUnmatchedCharacterToken");
		GHAssertEquals((NSUInteger) i, tok.range.location, @"Range location should match char location");
		GHAssertEquals((NSUInteger) 1, tok.range.length, @"Range length should always be 1");
	}
}

-(void)testFindsTokensSpecifiedByRules {
	NSString *source = @" function ";
	EDLexer *lexer = [EDLexer lexer];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"function" tokenType:EDDefinerKeywordToken caseInsensitive:NO]];
	NSArray *tokens = [lexer tokensInString:source];
	
	GHAssertEquals((NSUInteger) 3, [tokens count], @"3 tokens should be found");
	
	EDLexicalToken *t1 = [tokens objectAtIndex:0];
	EDLexicalToken *t2 = [tokens objectAtIndex:1];
	EDLexicalToken *t3 = [tokens objectAtIndex:2];
	
	GHAssertEquals((NSUInteger) EDUnmatchedCharacterToken, t1.type, @"First token should be EDUnmatchedCharacterToken");
	GHAssertEquals((NSUInteger) EDDefinerKeywordToken, t2.type, @"Second token should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 1, t2.range.location, @"Second token should be at offset 1");
	GHAssertEquals((NSUInteger) 8, t2.range.length, @"Second token should have a length of 8");
	GHAssertEquals((NSUInteger) EDUnmatchedCharacterToken, t3.type, @"Third token should be EDUnmatchedCharacterToken");
}

-(void)testUsesTheLongestMatchIfAmbiguous {
	NSString *source = @"function";
	EDLexer *lexer = [EDLexer lexer];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"func" tokenType:EDDefinerKeywordToken caseInsensitive:NO]];
	[lexer addRule:[EDExactStringLexRule ruleWithString:@"function" tokenType:EDDefinerKeywordToken caseInsensitive:NO]];
	NSArray *tokens = [lexer tokensInString:source];
	
	GHAssertEquals((NSUInteger) 1, [tokens count], @"1 token should be found");
	
	EDLexicalToken *tok = [tokens objectAtIndex:0];
	
	GHAssertEquals((NSUInteger) EDDefinerKeywordToken, tok.type, @"Token should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 0, tok.range.location, @"Token should be at offset 0");
	GHAssertEquals((NSUInteger) 8, tok.range.length, @"Token should have a length of 8");
}

@end
