//
//  EDLexerStatesTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDLexerStatesTest : GHTestCase
@end


@implementation EDLexerStatesTest

-(void)testStateNamesAreGeneratedUniquely {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	NSUInteger s1 = [states stateNamed:@"foo"];
	NSUInteger s2 = [states stateNamed:@"bar"];
	
	GHAssertNotEquals(s1, s2, @"States should be unique");
	
	[states release];
}

-(void)testStateIdsAreAlwaysTheSameForTheSameName {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	NSUInteger s1 = [states stateNamed:@"foo"];
	NSUInteger s2 = [states stateNamed:@"foo"];
	
	GHAssertEquals(s1, s2, @"States should be the same");
	
	[states release];
}

-(void)testCurrentStateIsInitiallyZero {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	GHAssertEquals((NSUInteger) 0, states.currentState, @"Initial state should be zero");
	[states release];
}

-(void)testStatesCanBePushedOntoStack {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	NSUInteger s1 = [states stateNamed:@"foo"];
	NSUInteger s2 = [states stateNamed:@"bar"];
	
	[states pushState:s1];
	[states pushState:s2];
	
	GHAssertEquals(s2, states.currentState, @"Current state should be the last one pushed");
	
	[states release];
}

-(void)testStatesCanBePoppedBackOffStack {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	NSUInteger s1 = [states stateNamed:@"foo"];
	NSUInteger s2 = [states stateNamed:@"bar"];
	
	[states pushState:s1];
	[states pushState:s2];
	
	[states popState];
	
	GHAssertEquals(s1, states.currentState, @"Current state should be back to the previous one pushed");
	
	[states release];
}

-(void)testPoppingOffAllStatesReturnsToInitialState {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	NSUInteger s1 = [states stateNamed:@"foo"];
	NSUInteger s2 = [states stateNamed:@"bar"];
	
	[states pushState:s1];
	[states pushState:s2];
	
	[states popState];
	[states popState];
	
	GHAssertEquals((NSUInteger) 0, states.currentState, @"Current state should be back to initial state");
	
	[states release];
}

-(void)testStackCanBeDescribed {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	NSUInteger s1 = [states stateNamed:@"foo"];
	NSUInteger s2 = [states stateNamed:@"bar"];
	
	[states pushState:s1];
	[states pushState:s2];
	
	EDLexerStatesInfo stackInfo;
	[states stackInfo:&stackInfo];
	
	GHAssertEquals((NSUInteger) 2, stackInfo.stackSize, @"Stack size should be 2");
	GHAssertEquals((NSUInteger) 0, stackInfo.stack[0], @"First stack entry should be initial state");
	GHAssertEquals(s1, stackInfo.stack[1], @"Second stack entry should be s1");
	GHAssertEquals(s2, stackInfo.currentState, @"Current state should be s2");
	
	[states release];
}

-(void)testStackCanBeReapplied {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	NSUInteger s1 = [states stateNamed:@"foo"];
	NSUInteger s2 = [states stateNamed:@"bar"];
	
	[states pushState:s1];
	[states pushState:s2];
	
	EDLexerStatesInfo stackInfo;
	stackInfo.stack[0] = 0;
	stackInfo.stackSize = 1;
	stackInfo.currentState = s1;
	
	[states applyStackInfo:stackInfo];
	
	GHAssertEquals(s1, states.currentState, @"State machine should be reset to the s1 state");
	
	[states release];
}

-(void)testInclusiveStatesCanBeFound {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	NSUInteger s1 = [states stateNamed:@"foo"];
	NSUInteger s2 = [states stateNamed:@"bar"];
	NSUInteger s3 = [states stateNamed:@"zip"];
	
	[states pushState:s1];
	[states pushState:s2];
	
	GHAssertTrue([states includesState:0], @"The initial state should always be inclusive");
	GHAssertTrue([states includesState:s1], @"The state s1 should be included");
	GHAssertTrue([states includesState:s2], @"The state s2 should be included");
	GHAssertFalse([states includesState:s3], @"The state s3 should not be included");
	
	[states release];
}

-(void)testCanBeReset {
	EDLexerStates *states = [[EDLexerStates alloc] init];
	NSUInteger s1 = [states stateNamed:@"foo"];
	NSUInteger s2 = [states stateNamed:@"bar"];
	
	[states pushState:s1];
	[states pushState:s2];
	
	[states reset];
	
	GHAssertEquals((NSUInteger) 0, states.currentState, @"State machine should be reset to the initial state");
	
	[states release];
}

@end
