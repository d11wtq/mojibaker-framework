//
//  EDPatternLexRuleTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDPatternLexRuleTest : GHTestCase
@end


@implementation EDPatternLexRuleTest

-(void)testReturnsNilIfPatternNotFoundAtRange {
	EDLexRule *rule = [EDPatternLexRule ruleWithPattern:@"^\\$[a-z]+"];
	NSString *source = @"foo $test";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length) buffer:nil states:nil];
	
	GHAssertNil(tok, @"Pattern is not found at range so should return nil");
}

-(void)testReturnsTokenIfPatternMatchesAtRange {
	EDLexRule *rule = [EDPatternLexRule ruleWithPattern:@"^\\$[a-z]+"];
	rule.tokenType = EDVariableToken;
	
	NSString *source = @"foo $test";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(4, source.length - 4) buffer:nil states:nil];
	
	GHAssertEquals(EDVariableToken, tok.type, @"Token should be a variable token type");
	GHAssertEquals((NSUInteger) 4, tok.range.location, @"Token should be at location 4");
	GHAssertEquals((NSUInteger) 5, tok.range.length, @"Token should have length 5");
	GHAssertEqualStrings(@"$test", tok.value, @"Value should be $test");
}

@end
