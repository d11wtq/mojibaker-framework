//
//  EDDelimitedStringLexRuleTest.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDDelimitedStringLexRuleTest : GHTestCase
@end


@implementation EDDelimitedStringLexRuleTest

-(void)testReturnsNilIfRangeDoesNotStartWithStartSequence {
	id<EDLexRule> rule = [EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" tokenType:EDString1Token];
	NSString *source = @"test \"strings\"";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(0, source.length)];
	GHAssertNil(tok, @"Nil should be return since '\"' not in range");
}

-(void)testReturnsTokenIfStartSequenceIsStartOfRange {
	id<EDLexRule> rule = [EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" tokenType:EDString1Token];
	NSString *source = @"a \"string\" b";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2)];
	
	GHAssertEquals((NSUInteger) EDString1Token, tok.type, @"Type should be EDString1Token");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 8, tok.range.length, @"String should have length 8");
}

-(void)testFindsOnlyUntilFirstOccurenceOfEndSequence {
	id<EDLexRule> rule = [EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" tokenType:EDString1Token];
	NSString *source = @"a \"string 1\" \"string 2\" b";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2)];
	
	GHAssertEquals((NSUInteger) EDString1Token, tok.type, @"Type should be EDString1Token");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 10, tok.range.length, @"String should have length 10");
}

-(void)testCanIncludeEndSequenceIfEscaped {
	id<EDLexRule> rule = [EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" tokenType:EDString1Token];
	NSString *source = @"a \"string \\\"escaped\\\"\" b";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2)];
	
	GHAssertEquals((NSUInteger) EDString1Token, tok.type, @"Type should be EDString1Token");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 20, tok.range.length, @"String should have length 20");
}

-(void)testDoesNotTreatEscapedEscapesAsFunctionalEscapes {
	id<EDLexRule> rule = [EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" tokenType:EDString1Token];
	NSString *source = @"a \"string \\\\\"escaped\\\"\" b";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2)];
	
	GHAssertEquals((NSUInteger) EDString1Token, tok.type, @"Type should be EDString1Token");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 11, tok.range.length, @"String should have length 11");
}

-(void)testMissingEndSequenceMakesTokenContinueToEnd {
	id<EDLexRule> rule = [EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" tokenType:EDString1Token];
	NSString *source = @"a \"unterminated string";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2)];
	
	GHAssertEquals((NSUInteger) EDString1Token, tok.type, @"Type should be EDString1Token");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) source.length - 2, tok.range.length, @"String should consume all of the available range");
}

-(void)testEscapeSequenceAtEndOfToken {
	id<EDLexRule> rule = [EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" tokenType:EDString1Token];
	NSString *source = @"a \"unterminated string\\";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2)];
	
	GHAssertEquals((NSUInteger) EDString1Token, tok.type, @"Type should be EDString1Token");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) source.length - 2, tok.range.length, @"String should consume all of the available range");
}

-(void)testEscapeSequenceDisabled {
	id<EDLexRule> rule = [EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" escape:nil tokenType:EDString1Token];
	NSString *source = @"a \"unterminated string\\\" foo\" bar";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2)];
	
	GHAssertEquals((NSUInteger) EDString1Token, tok.type, @"Type should be EDString1Token");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 22, tok.range.length, @"String should stop at first delimiting '\"'");
}

-(void)testEscapeSequenceSetToCustomSequence {
	id<EDLexRule> rule = [EDDelimitedStringLexRule ruleWithStart:@"\"" end:@"\"" escape:@"aaa" tokenType:EDString1Token];
	NSString *source = @"a \"unterminated string aaa\" fooaaaaaa\" bar";
	EDLexicalToken *tok = [rule lexInString:source range:NSMakeRange(2, source.length - 2)];
	
	GHAssertEquals((NSUInteger) EDString1Token, tok.type, @"Type should be EDString1Token");
	GHAssertEquals((NSUInteger) 2, tok.range.location, @"String should be found at offset 2");
	GHAssertEquals((NSUInteger) 36, tok.range.length, @"String should treat sequences 'aaa' like '\\\'");
}

@end
