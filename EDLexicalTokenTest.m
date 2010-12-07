//
//  EDLexicalTokenTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDLexicalTokenTest : GHTestCase
@end


@implementation EDLexicalTokenTest

-(void)testTokensCanBeComparedForEquality {
	NSArray *stackA = [NSArray arrayWithObject:[NSNumber numberWithUnsignedInt:0]];
	NSArray *stackB = [NSArray arrayWithObject:[NSNumber numberWithUnsignedInt:0]];
	
	EDLexerStatesSnapshot *snapshotA = [EDLexerStatesSnapshot snapshotWithStack:stackA currentState:1];
	EDLexerStatesSnapshot *snapshotB = [EDLexerStatesSnapshot snapshotWithStack:stackB currentState:1];
	
	EDLexicalToken *tokA = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(4, 8) value:@"function" rule:nil];
	tokA.statesSnapshot = snapshotA;
	
	EDLexicalToken *tokB = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(4, 8) value:@"function" rule:nil];
	tokB.statesSnapshot = snapshotB;
	
	GHAssertTrue([tokA isEqualToToken:tokB], @"Tokens should be the same");
}

-(void)testEffectiveRangeReturnsActualRangeWithoutScope {
	EDLexicalToken *tok = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(4, 8) value:@"function" rule:nil];
	
	GHAssertTrue(NSEqualRanges(NSMakeRange(4, 8), tok.effectiveRange), @"Effective range should be actual range");
}

-(void)testEffectiveRangeReturnsSumOfRangesWithScope {
	EDLexicalScope *scope = [EDLexicalScope scopeWithRangeValue:[NSValue valueWithRange:NSMakeRange(16, 10)]];
	EDLexicalToken *tok = [EDLexicalToken tokenWithType:EDKeywordToken range:NSMakeRange(4, 8) value:@"function" rule:nil];
	tok.attachedScope = scope;
	
	GHAssertTrue(NSEqualRanges(NSMakeRange(4, 22), tok.effectiveRange), @"Effective range should be sum of ranges");
}

@end
