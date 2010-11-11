//
//  EDCharacterLexRuleTest.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDCharacterLexRuleTest : GHTestCase
@end


@implementation EDCharacterLexRuleTest

-(void)testAlwaysMatchesFirstCharacterInRange {
	EDLexRule *rule = [EDCharacterLexRule rule];
	NSString *source = @"test";
	
	NSUInteger i;
	NSUInteger len = source.length;
	for (i = 0; i < len; ++i) {
		EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(i, len - i) states:nil];
		GHAssertEquals(EDUnmatchedToken, tok.type, @"Type should be EDUnmatchedToken");
		GHAssertEquals((NSUInteger) i, tok.range.location, @"Location should be start of range");
		GHAssertEquals((NSUInteger) 1, tok.range.length, @"Length should be 1");
		GHAssertEqualStrings([source substringWithRange:tok.range], tok.value, @"Value should match range");
	}
}

-(void)testTypeCanBeChanged {
	EDLexRule *rule = [EDCharacterLexRule rule];
	rule.tokenType = EDWhitespaceToken;
	
	NSString *source = @" ";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, 1) states:nil];
	GHAssertEquals(EDWhitespaceToken, tok.type, @"Type should be EDWhitespaceToken");
}

-(void)testReturnsNilIfSpecifiedCharNotFound {
	EDLexRule *rule = [EDCharacterLexRule ruleWithUnicodeChar:'b'];
	rule.tokenType = EDWhitespaceToken;
	
	NSString *source = @"abc";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, 1) states:nil];
	GHAssertNil(tok, @"Char not found so nil should be returned");
}

-(void)testReturnsTokenIfSpecifiedCharFound {
	EDLexRule *rule = [EDCharacterLexRule ruleWithUnicodeChar:'b'];
	
	NSString *source = @"bc";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, 1) states:nil];
	GHAssertEquals((NSUInteger)0, (NSUInteger)tok.range.location, @"Char found so location should be 0");
	GHAssertEquals((NSUInteger)1, (NSUInteger)tok.range.length, @"Char found so length should be 1");
}

@end
