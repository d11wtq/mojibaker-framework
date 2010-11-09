//
//  EDLexerStatesSnapshotTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDLexerStatesSnapshotTest : GHTestCase
@end


@implementation EDLexerStatesSnapshotTest

-(void)testSnapshotsCanBeComparedForEquality {
	NSArray *stackA = [NSArray arrayWithObject:[NSNumber numberWithUnsignedInt:0]];
	NSArray *stackB = [NSArray arrayWithObject:[NSNumber numberWithUnsignedInt:0]];
	
	EDLexerStatesSnapshot *snapshotA = [EDLexerStatesSnapshot snapshotWithStack:stackA currentState:1];
	EDLexerStatesSnapshot *snapshotB = [EDLexerStatesSnapshot snapshotWithStack:stackB currentState:1];
	
	GHAssertTrue([snapshotA isEqualToSnapshot:snapshotB], @"Snapshots should be the same");
}

@end
