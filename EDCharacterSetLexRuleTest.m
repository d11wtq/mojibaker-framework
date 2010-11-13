//
//  EDCharacterSetLexRuleTest.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDCharacterSetLexRuleTest : GHTestCase
@end


@implementation EDCharacterSetLexRuleTest

-(void)testReturnsNilIfPermittedCharactersNotAtStartOfRange {
	EDLexRule *rule = [EDCharacterSetLexRule ruleWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	rule.tokenType = EDWhitespaceToken;
	
	NSString *source = @"test \t\t\n class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length) buffer:nil states:nil];
	GHAssertNil(tok, @"Nil should be return since whitespace chars not in range");
}

-(void)testReturnsTokenIfCharactersAtStartOfRange {
	EDLexRule *rule = [EDCharacterSetLexRule ruleWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	rule.tokenType = EDWhitespaceToken;
	
	NSString *source = @"test \t\t\r\n class foo";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(4, source.length - 4) buffer:nil states:nil];
	
	GHAssertEquals(EDWhitespaceToken, tok.type, @"Token type should be EDWhitespaceToken");
	GHAssertEquals((NSUInteger) 4, tok.range.location, @"Matched token range should always be range searched");
	GHAssertEquals((NSUInteger) 6, tok.range.length, @"Matched token range should include all characters");
	GHAssertEqualStrings(@" \t\t\r\n ", tok.value, @"Value should be all the whistespace");
}

@end
