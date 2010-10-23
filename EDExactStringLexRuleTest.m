//
//  EDExactStringLexRuleTest.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDExactStringLexRuleTest : GHTestCase
@end


@implementation EDExactStringLexRuleTest

-(void)testReturnsNilIfKeywordIsNotAtStartOfRange {
	id<EDLexRule> rule = [EDExactStringLexRule ruleWithString:@"class"
													   tokenType:EDDefinerKeywordToken caseInsensitive:NO];
	NSString *source = @"test class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length)];
	GHAssertNil(tok, @"Nil should be return since 'class' is not in range");
}

-(void)testReturnsTokenIfKeywordIsAtStartOfRange {
	id<EDLexRule> rule = [EDExactStringLexRule ruleWithString:@"class"
													   tokenType:EDDefinerKeywordToken caseInsensitive:NO];
	NSString *source = @"test class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(5, source.length - 5)];
	
	GHAssertEquals((NSUInteger) EDDefinerKeywordToken, tok.type, @"Token type should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 5, tok.range.location, @"Matched token range should always be range searched");
	GHAssertEquals((NSUInteger) 5, tok.range.length, @"Matched token range should have same length as keyword");
}

-(void)testReturnsTokenIfKeywordIsAtStartOfRangeInCaseInsensitiveMode {
	id<EDLexRule> rule = [EDExactStringLexRule ruleWithString:@"class"
													   tokenType:EDDefinerKeywordToken caseInsensitive:YES];
	NSString *source = @"test Class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(5, source.length - 5)];
	
	GHAssertEquals((NSUInteger) EDDefinerKeywordToken, tok.type, @"Token type should be EDDefinerKeywordToken");
	GHAssertEquals((NSUInteger) 5, tok.range.location, @"Matched token range should always be range searched");
	GHAssertEquals((NSUInteger) 5, tok.range.length, @"Matched token range should have same length as keyword");
}

-(void)testReturnsNilIfKeywordAtRangeDoesNotMatchCase {
	id<EDLexRule> rule = [EDExactStringLexRule ruleWithString:@"class"
													   tokenType:EDDefinerKeywordToken caseInsensitive:NO];
	NSString *source = @"test Class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(5, source.length - 5)];
	GHAssertNil(tok, @"Nil should be return since 'Class' is not the same as 'class'");
}

@end
