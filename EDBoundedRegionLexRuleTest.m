//
//  EDBoundedRegionLexRuleTest.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDBoundedRegionLexRuleTest : GHTestCase
@end


@implementation EDBoundedRegionLexRuleTest

-(void)testReturnsNilIfRangeDoesNotStartWithStartSequence {
	EDLexRule *rule = [EDBoundedRegionLexRule ruleWithStart:@"\"" end:@"\"" escape:@"\\"];
	rule.tokenType = EDStringToken;
	
	NSString *source = @"test \"strings\"";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length) buffer:nil states:nil];
	GHAssertNil(tok, @"Nil should be return since '\"' not in range");
}

-(void)testReturnsTokenIfStartSequenceIsStartOfRange {
	EDLexRule *rule = [EDBoundedRegionLexRule ruleWithStart:@"\"" end:@"\"" escape:@"\\"];
	rule.tokenType = EDStringToken;
	
	NSString *source = @"a \"string\" b";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2) buffer:nil states:nil];
	
	GHAssertEquals(EDStringToken, tok.type, @"Type should be EDStringToken");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 8, tok.range.length, @"String should have length 8");
	GHAssertEqualStrings(@"\"string\"", tok.value, @"Value should be \"string\"");
}

-(void)testFindsOnlyUntilFirstOccurenceOfEndSequence {
	EDLexRule *rule = [EDBoundedRegionLexRule ruleWithStart:@"\"" end:@"\"" escape:@"\\"];
	rule.tokenType = EDStringToken;
	
	NSString *source = @"a \"string 1\" \"string 2\" b";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2) buffer:nil states:nil];
	
	GHAssertEquals(EDStringToken, tok.type, @"Type should be EDStringToken");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 10, tok.range.length, @"String should have length 10");
}

-(void)testCanIncludeEndSequenceIfEscaped {
	EDLexRule *rule = [EDBoundedRegionLexRule ruleWithStart:@"\"" end:@"\"" escape:@"\\"];
	rule.tokenType = EDStringToken;
	
	NSString *source = @"a \"string \\\"escaped\\\"\" b";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2) buffer:nil states:nil];
	
	GHAssertEquals(EDStringToken, tok.type, @"Type should be EDStringToken");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 20, tok.range.length, @"String should have length 20");
}

-(void)testDoesNotTreatEscapedEscapesAsFunctionalEscapes {
	EDLexRule *rule = [EDBoundedRegionLexRule ruleWithStart:@"\"" end:@"\"" escape:@"\\"];
	rule.tokenType = EDStringToken;
	
	NSString *source = @"a \"string \\\\\"escaped\\\"\" b";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2) buffer:nil states:nil];
	
	GHAssertEquals(EDStringToken, tok.type, @"Type should be EDStringToken");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 11, tok.range.length, @"String should have length 11");
}

-(void)testMissingEndSequenceMakesTokenContinueToEnd {
	EDLexRule *rule = [EDBoundedRegionLexRule ruleWithStart:@"\"" end:@"\"" escape:@"\\"];
	rule.tokenType = EDStringToken;
	
	NSString *source = @"a \"unterminated string";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2) buffer:nil states:nil];
	
	GHAssertEquals(EDStringToken, tok.type, @"Type should be EDStringToken");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) source.length - 2, tok.range.length, @"String should consume all of the available range");
}

-(void)testEscapeSequenceAtEndOfToken {
	EDLexRule *rule = [EDBoundedRegionLexRule ruleWithStart:@"\"" end:@"\"" escape:@"\\"];
	rule.tokenType = EDStringToken;
	
	NSString *source = @"a \"unterminated string\\";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2) buffer:nil states:nil];
	
	GHAssertEquals(EDStringToken, tok.type, @"Type should be EDStringToken");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) source.length - 2, tok.range.length, @"String should consume all of the available range");
}

-(void)testEscapeSequenceDisabled {
	EDLexRule *rule = [EDBoundedRegionLexRule ruleWithStart:@"\"" end:@"\"" escape:nil];
	rule.tokenType = EDStringToken;
	
	NSString *source = @"a \"unterminated string\\\" foo\" bar";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2) buffer:nil states:nil];
	
	GHAssertEquals(EDStringToken, tok.type, @"Type should be EDStringToken");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 22, tok.range.length, @"String should stop at first delimiting '\"'");
}

-(void)testEscapeSequenceSetToCustomSequence {
	EDLexRule *rule = [EDBoundedRegionLexRule ruleWithStart:@"\"" end:@"\"" escape:@"aaa"];
	rule.tokenType = EDStringToken;
	
	NSString *source = @"a \"unterminated string aaa\" fooaaaaaa\" bar";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2) buffer:nil states:nil];
	
	GHAssertEquals(EDStringToken, tok.type, @"Type should be EDStringToken");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 36, tok.range.length, @"String should treat sequences 'aaa' like '\\\'");
}

@end
