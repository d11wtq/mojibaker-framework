//
//  EDWordListLexRuleTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 25/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDWordListLexRuleTest : GHTestCase
@end


@implementation EDWordListLexRuleTest

-(void)testReturnsNilIfNoWordsInListMatch {
	NSArray *words = [NSArray arrayWithObjects:@"foo", @"bar", @"zip", @"zap", nil];
	EDLexRule * rule = [EDWordListLexRule ruleWithList:words tokenType:EDKeywordToken caseInsensitive:NO];
	NSString *source = @"nothing to see here";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length)];
	
	GHAssertNil(tok, @"nil should be returned since no match exists");
}

-(void)testReturnsTokenIfMatchExistsAtRange {
	NSArray *words = [NSArray arrayWithObjects:@"foo", @"bar", @"zip", @"zapper", nil];
	EDLexRule * rule = [EDWordListLexRule ruleWithList:words tokenType:EDKeywordToken caseInsensitive:NO];
	NSString *source = @"hello zapper, how are you?";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(6, source.length - 6)];
	
	GHAssertEquals(EDKeywordToken, tok.type, @"Token type should be EDKeywordToken");
	GHAssertEquals((NSUInteger) 6, (NSUInteger) tok.range.location, @"Token location should be 6");
	GHAssertEquals((NSUInteger) 6, (NSUInteger) tok.range.length, @"Token length should be 6");
}

-(void)testReturnsLongestTokenIfMultipleMatch {
	NSArray *words = [NSArray arrayWithObjects:@"foo", @"bar", @"zap", @"zapper", nil];
	EDLexRule * rule = [EDWordListLexRule ruleWithList:words tokenType:EDKeywordToken caseInsensitive:NO];
	NSString *source = @"hello zapper, how are you?";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(6, source.length - 6)];
	
	GHAssertEquals(EDKeywordToken, tok.type, @"Token type should be EDKeywordToken");
	GHAssertEquals((NSUInteger) 6, (NSUInteger) tok.range.location, @"Token location should be 6");
	GHAssertEquals((NSUInteger) 6, (NSUInteger) tok.range.length, @"Token length should be 6");
}

@end
