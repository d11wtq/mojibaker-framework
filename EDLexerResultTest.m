//
//  EDLexerResultTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 24/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDLexerResultTest : GHTestCase
@end


@implementation EDLexerResultTest

-(void)testResultProvidesTokens {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4)],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10)], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	GHAssertEquals(tokens, result.tokens, @"Arrays should be the same object");
}

-(void)testTokenAtSpecificRangeCanBeRequested {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4)],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10)], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(0, 4)];
	
	GHAssertEquals((NSUInteger) EDKeywordToken, tok.type, @"Token type should be EDKeywordToken");
	GHAssertEquals((NSUInteger) 0, (NSUInteger) tok.range.location, @"Token location should be 0");
	GHAssertEquals((NSUInteger) 4, (NSUInteger) tok.range.length, @"Token length should be 4");
}

-(void)testTokenThatBoundsSpecifiedRangeCanBeRequested {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4)],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10)], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(6, 2)];
	
	GHAssertEquals((NSUInteger) EDDefinerKeywordToken, tok.type, @"Token type should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 4, (NSUInteger) tok.range.location, @"Token location should be 4");
	GHAssertEquals((NSUInteger) 10, (NSUInteger) tok.range.length, @"Token length should be 10");
}

-(void)testTokenThatFallsInsideBoundsSpecifiedRangeIsNotReturned1 {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4)],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10)], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(4, 11)];
	
	GHAssertNil(tok, @"No tokens bound the given range, so nothing should be returned");
}

-(void)testTokenThatFallsInsideBoundsSpecifiedRangeIsNotReturned2 {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4)],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10)], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(3, 11)];
	
	GHAssertNil(tok, @"No tokens bound the given range, so nothing should be returned");
}

-(void)testOnlyClosestTokenInGivenRangeIsReturnedIfTokensAreNested {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4)],
					   [EDLexicalToken tokenWithType:EDString1Token range:NSMakeRange(4, 10)],
					   [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(6, 7)], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(7, 1)];
	
	GHAssertEquals((NSUInteger) EDKeywordToken, tok.type, @"Token type should be EDKeywordToken");
	GHAssertEquals((NSUInteger) 6, (NSUInteger) tok.range.location, @"Token location should be 6");
	GHAssertEquals((NSUInteger) 7, (NSUInteger) tok.range.length, @"Token length should be 7");
}

-(void)testSearchInLongListOfTokens {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4)],
					   [EDLexicalToken tokenWithType:EDString1Token range:NSMakeRange(4, 10)],
					   [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(14, 5)],
					   [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(19, 1)],
					   [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(20, 4)], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(21, 1)];
	
	GHAssertEquals((NSUInteger) EDKeywordToken, tok.type, @"Token type should be EDKeywordToken");
	GHAssertEquals((NSUInteger) 20, (NSUInteger) tok.range.location, @"Token location should be 20");
	GHAssertEquals((NSUInteger) 4, (NSUInteger) tok.range.length, @"Token length should be 4");
}

@end
