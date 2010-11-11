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

@end
