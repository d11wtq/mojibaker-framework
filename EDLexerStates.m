//
//  EDLexerStates.m
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexerStates.h"
#import "EDLexerStatesSnapshot.h"

@implementation EDLexerStates

@synthesize isChanged;

+(id)states {
	return [[[self alloc] init] autorelease];
}

-(id)init {
	if (self = [super init]) {
		stateNames = [[NSMutableDictionary alloc] init];
		stateStack = [[NSMutableArray alloc] initWithCapacity:10];
		highestStateId = 0;
		isChanged = NO;
	}
	
	return self;
}

-(NSUInteger)stateNamed:(NSString *)stateName {
	NSNumber *num = [stateNames objectForKey:stateName];
	if (num == nil) {
		num = [NSNumber numberWithUnsignedInt:++highestStateId];
		[stateNames setObject:num forKey:stateName];
	}
	return [num unsignedIntValue];
}

-(EDLexerStatesSnapshot *)snapshot {
	return [EDLexerStatesSnapshot snapshotWithStack:[[stateStack copy] autorelease] currentState:currentState];
}

-(void)applySnapshot:(EDLexerStatesSnapshot *)snapshot {
	[self reset];
	
	[stateStack addObjectsFromArray:[snapshot stack]];
	currentState = [snapshot currentState];
}

-(void)beginState:(NSUInteger)newStateId {
	currentState = newStateId;
	isChanged = YES;
}

-(void)pushState:(NSUInteger)newStateId {
	[stateStack addObject:[NSNumber numberWithUnsignedInteger:currentState]];
	[self beginState:newStateId];
	
	isChanged = YES;
}

-(void)popState {
	[self beginState:[[stateStack lastObject] unsignedIntegerValue]];
	[stateStack removeLastObject];
	
	isChanged = YES;
}

-(void)rewindToState:(NSUInteger)stateId {
	while (currentState != stateId) {
		[self popState];
	}
}

-(NSUInteger)currentState {
	return currentState;
}

-(BOOL)includesState:(NSUInteger)stateId {
	BOOL included = (currentState == stateId || stateStack.count == 0);
	
	if (!included) {
		for (NSNumber *n in stateStack) {
			if ([n unsignedIntegerValue] == stateId) {
				included = YES;
				break;
			}
		}
	}
	
	return included;
}

-(void)reset {
	[stateStack removeAllObjects];
	currentState = 0;
	isChanged = NO;
}

-(void)dealloc {
	[stateNames release];
	[stateStack release];
	[super dealloc];
}

@end
