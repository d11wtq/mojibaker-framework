//
//  EDExactMatchLexRuleTest.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDExactMatchLexRuleTest : GHTestCase
@end


@implementation EDExactMatchLexRuleTest

-(void)testReturnsNilIfKeywordIsNotAtStartOfRange {
	EDLexRule *rule = [EDExactMatchLexRule ruleWithString:@"class" caseInsensitive:NO];
	rule.tokenType = EDDefinerKeywordToken;
	
	NSString *source = @"test class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length) states:nil];
	GHAssertNil(tok, @"Nil should be return since 'class' is not in range");
}

-(void)testReturnsTokenIfKeywordIsAtStartOfRange {
	EDLexRule *rule = [EDExactMatchLexRule ruleWithString:@"class" caseInsensitive:NO];
	rule.tokenType = EDDefinerKeywordToken;
	
	NSString *source = @"test class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(5, source.length - 5) states:nil];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"Token type should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 5, tok.range.location, @"Matched token range should always be range searched");
	GHAssertEquals((NSUInteger) 5, tok.range.length, @"Matched token range should have same length as keyword");
}

-(void)testReturnsTokenIfKeywordIsAtStartOfRangeInCaseInsensitiveMode {
	EDLexRule *rule = [EDExactMatchLexRule ruleWithString:@"class" caseInsensitive:YES];
	rule.tokenType = EDDefinerKeywordToken;
	
	NSString *source = @"test Class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(5, source.length - 5) states:nil];
	
	GHAssertEquals(EDDefinerKeywordToken, tok.type, @"Token type should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 5, tok.range.location, @"Matched token range should always be range searched");
	GHAssertEquals((NSUInteger) 5, tok.range.length, @"Matched token range should have same length as keyword");
}

-(void)testReturnsNilIfKeywordAtRangeDoesNotMatchCase {
	EDLexRule *rule = [EDExactMatchLexRule ruleWithString:@"class" caseInsensitive:NO];
	rule.tokenType = EDDefinerKeywordToken;
	
	NSString *source = @"test Class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(5, source.length - 5) states:nil];
	GHAssertNil(tok, @"Nil should be return since 'Class' is not the same as 'class'");
}

@end
