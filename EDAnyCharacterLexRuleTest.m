//
//  EDAnyCharacterLexRuleTest.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDAnyCharacterLexRuleTest : GHTestCase
@end


@implementation EDAnyCharacterLexRuleTest

-(void)testAlwaysMatchesFirstCharacterInRange {
	EDLexRule * rule = [EDAnyCharacterLexRule rule];
	NSString *source = @"test";
	
	NSUInteger i;
	NSUInteger len = source.length;
	for (i = 0; i < len; ++i) {
		EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(i, len - i) states:nil];
		GHAssertEquals(EDUnmatchedCharacterToken, tok.type, @"Type should be EDUnmatchedCharacterToken");
		GHAssertEquals((NSUInteger) i, tok.range.location, @"Location should be start of range");
		GHAssertEquals((NSUInteger) 1, tok.range.length, @"Length should be 1");
	}
}

-(void)testTypeCanBeChanged {
	EDLexRule * rule = [EDAnyCharacterLexRule ruleWithTokenType:EDWhitespaceToken];
	NSString *source = @" ";
	
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, 1) states:nil];
	GHAssertEquals(EDWhitespaceToken, tok.type, @"Type should be EDWhitespaceToken");
}

@end
