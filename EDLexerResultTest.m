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
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4) value:@"aaaa" rule:nil],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10) value:@"bbbbbbbbbb" rule:nil], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	GHAssertEqualObjects(tokens, result.tokens, @"Arrays should be the same");
}

-(void)testTokenAtSpecificRangeCanBeRequested {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4) value:@"aaaa" rule:nil],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10) value:@"bbbbbbbbbb" rule:nil], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(0, 4)];
	
	GHAssertEquals(EDKeywordToken, tok.type, @"Token type should be EDKeywordToken");
	GHAssertEquals((NSUInteger) 0, (NSUInteger) tok.range.location, @"Token location should be 0");
	GHAssertEquals((NSUInteger) 4, (NSUInteger) tok.range.length, @"Token length should be 4");
}

-(void)testTokenThatBoundsSpecifiedRangeCanBeRequested {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4) value:@"aaaa" rule:nil],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10) value:@"bbbbbbbbbb" rule:nil], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(6, 2)];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"Token type should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 4, (NSUInteger) tok.range.location, @"Token location should be 4");
	GHAssertEquals((NSUInteger) 10, (NSUInteger) tok.range.length, @"Token length should be 10");
}

-(void)testTokenThatFallsInsideBoundsSpecifiedRangeIsNotReturned1 {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4) value:@"aaaa" rule:nil],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10) value:@"bbbbbbbbbb" rule:nil], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(4, 11)];
	
	GHAssertNil(tok, @"No tokens bound the given range, so nothing should be returned");
}

-(void)testTokenThatFallsInsideBoundsSpecifiedRangeIsNotReturned2 {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4) value:@"aaaa" rule:nil],
					   [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(4, 10) value:@"bbbbbbbbbb" rule:nil], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(3, 11)];
	
	GHAssertNil(tok, @"No tokens bound the given range, so nothing should be returned");
}

-(void)testOnlyClosestTokenInGivenRangeIsReturnedIfTokensAreNested {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4) value:@"aaaa" rule:nil],
					   [EDLexicalToken tokenWithType:EDStringToken range:NSMakeRange(4, 10) value:@"bbbbbbbbbb" rule:nil],
					   [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(6, 7) value:@"ccccccc" rule:nil], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(7, 1)];
	
	GHAssertEquals(EDKeywordToken, tok.type, @"Token type should be EDKeywordToken");
	GHAssertEquals((NSUInteger) 6, (NSUInteger) tok.range.location, @"Token location should be 6");
	GHAssertEquals((NSUInteger) 7, (NSUInteger) tok.range.length, @"Token length should be 7");
}

-(void)testSearchInLongListOfTokens {
	NSArray *tokens = [NSArray arrayWithObjects:[EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 4) value:@"aaaa" rule:nil],
					   [EDLexicalToken tokenWithType:EDStringToken range:NSMakeRange(4, 10) value:@"bbbbbbbbbb" rule:nil],
					   [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(14, 5) value:@"ccccc" rule:nil],
					   [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(19, 1) value:@"+" rule:nil],
					   [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(20, 4) value:@"dddd" rule:nil], nil];
	EDLexerResult *result = [EDLexerResult resultWithTokens:tokens];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(21, 1)];
	
	GHAssertEquals(EDKeywordToken, tok.type, @"Token type should be EDKeywordToken");
	GHAssertEquals((NSUInteger) 20, (NSUInteger) tok.range.location, @"Token location should be 20");
	GHAssertEquals((NSUInteger) 4, (NSUInteger) tok.range.length, @"Token length should be 4");
}

-(void)testWeirdBugWhereFirstElementIsNotFound {
	EDLexicalToken *t1 = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(0, 6) value:@"aaaaaa" rule:nil];
	EDLexicalToken *t2 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(6, 1) value:@" " rule:nil];
	EDLexicalToken *t3 = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(7, 6) value:@"bbbbbb" rule:nil];
	EDLexicalToken *t4 = [EDLexicalToken tokenWithType:EDWhitespaceToken range:NSMakeRange(13, 1) value:@"+" rule:nil];
	EDLexicalToken *t5 = [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(14, 8) value:@"cccccccc" rule:nil];
	
	EDLexerResult *result = [EDLexerResult resultWithTokens:[NSArray arrayWithObjects:t1, t2, t3, t4, t5, nil]];
	
	EDLexicalToken *tok = [result tokenAtRange:NSMakeRange(0, 6)];
	
	GHAssertNotNil(tok, @"Token should be found");
}

-(void)testScopesCanBeRecorded {
	EDLexerResult *result = [EDLexerResult result];
	
	EDLexRule *opRule = [[[EDLexRule alloc] init] autorelease];
	opRule.beginsScope = YES;
	
	EDLexRule *clRule = [[[EDLexRule alloc] init] autorelease];
	clRule.endsScope = YES;
	
	EDLexicalToken *t1 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(2, 1) value:@"{" rule:opRule];
	EDLexicalToken *t2 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(6, 1) value:@"{" rule:opRule];
	EDLexicalToken *t3 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(8, 1) value:@"}" rule:clRule];
	EDLexicalToken *t4 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(10, 1) value:@"{" rule:opRule];
	EDLexicalToken *t5 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(11, 1) value:@"}" rule:clRule];
	EDLexicalToken *t6 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(13, 1) value:@"}" rule:clRule];
	
	[result addToken:t1];
	[result addToken:t2];
	[result addToken:t3];
	[result addToken:t4];
	[result addToken:t5];
	[result addToken:t6];
	
	NSArray *scopes = [result scopes];
	
	EDLexicalScope *scope1 = [scopes objectAtIndex:0];
	EDLexicalScope *scope2 = [scopes objectAtIndex:1];
	EDLexicalScope *scope3 = [scopes objectAtIndex:2];
	
	GHAssertTrue(NSEqualRanges(NSMakeRange(2, 12), scope1.range), @"First scope should be at (2,12)");
	GHAssertTrue(NSEqualRanges(NSMakeRange(6, 3), scope2.range), @"Second scope should be at (6,3)");
	GHAssertTrue(NSEqualRanges(NSMakeRange(10, 2), scope3.range), @"Third scope should be at (10,2)");
}

-(void)testCodeOutlineIsKnown {
	EDLexerResult *result = [EDLexerResult result];
	
	EDLexRule *treeItem = [[[EDLexRule alloc] init] autorelease];
	treeItem.includedInSymbolTree = YES;
	
	EDLexRule *opRule = [[[EDLexRule alloc] init] autorelease];
	opRule.beginsScope = YES;
	
	EDLexRule *clRule = [[[EDLexRule alloc] init] autorelease];
	clRule.endsScope = YES;
	
	EDLexicalToken *t1 = [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(0, 5) value:@"class" rule:nil];
	EDLexicalToken *t2 = [EDLexicalToken tokenWithType:EDClassDefinitionToken range:NSMakeRange(6, 3) value:@"Foo" rule:treeItem];
	EDLexicalToken *t3 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(9, 1) value:@"{" rule:opRule];
	EDLexicalToken *t4 = [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(11, 8) value:@"function" rule:nil];
	EDLexicalToken *t5 = [EDLexicalToken tokenWithType:EDMethodDefinitionToken range:NSMakeRange(20, 3) value:@"bar" rule:treeItem];
	EDLexicalToken *t6 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(24, 1) value:@"{" rule:opRule];
	EDLexicalToken *t7 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(25, 1) value:@"}" rule:clRule];
	EDLexicalToken *t8 = [EDLexicalToken tokenWithType:EDDefinerKeywordToken range:NSMakeRange(27, 8) value:@"function" rule:nil];
	EDLexicalToken *t9 = [EDLexicalToken tokenWithType:EDMethodDefinitionToken range:NSMakeRange(36, 3) value:@"zip" rule:treeItem];
	EDLexicalToken *t10 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(39, 1) value:@"{" rule:opRule];
	EDLexicalToken *t11 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(40, 1) value:@"}" rule:clRule];
	EDLexicalToken *t12 = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(41, 1) value:@"}" rule:clRule];
	
	[result addToken:t1];
	[result addToken:t2];
	[result addToken:t3];
	[result addToken:t4];
	[result addToken:t5];
	[result addToken:t6];
	[result addToken:t7];
	[result addToken:t8];
	[result addToken:t9];
	[result addToken:t10];
	[result addToken:t11];
	[result addToken:t12];
	
	NSArray *tree = [result tree];
	
	GHAssertEquals((NSUInteger) 2, [tree count], @"There should be one top level element");
	
	EDLexicalToken *topLevel = [tree objectAtIndex:0];
	
	GHAssertEquals(t2, topLevel, @"Top level token should be the class definition");
	
	NSArray *children = [tree objectAtIndex:1];
	
	GHAssertEquals((NSUInteger) 2, [children count], @"Class definition should have two child symbols");
	
	GHAssertEquals(t5, [children objectAtIndex:0], @"First child should be the method 'bar'");
	GHAssertEquals(t9, [children objectAtIndex:1], @"Second child should be the method 'zip'");
}

@end
