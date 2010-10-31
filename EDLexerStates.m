//
//  EDLexerStates.m
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexerStates.h"


@implementation EDLexerStates

@synthesize isChanged;

-(id)init {
	if (self = [super init]) {
		stateNames = [[NSMutableDictionary alloc] init];
		highestStateId = 0;
		[self reset];
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

-(EDLexerStatesInfo)stackInfo {
	NSUInteger infoStack[stackPosition];
	NSUInteger i = 0;
	for (; i < stackPosition; ++i) {
		infoStack[i] = stack[i];
	}
	
	EDLexerStatesInfo info;
	info.stack = infoStack;
	info.stackSize = stackPosition;
	info.currentState = currentState;
	
	return info;
}

-(void)setStack:(NSUInteger *)newStack length:(NSUInteger)stackLength currentState:(NSUInteger)newCurrentState {
	if (stackLength > EDLexerStatesStackSize) {
		[NSException raise:@"StackOverflowException"
					format:@"New stack size exceeds maximum size %d", EDLexerStatesStackSize];
	}
	
	NSUInteger i = 0;
	for (; i < stackLength; ++i) {
		stack[i] = newStack[i];
	}
	
	stackPosition = stackLength;
	currentState = newCurrentState;
	
	isChanged = YES;
}

-(void)pushState:(NSUInteger)newStateId {
	if (stackPosition >= (EDLexerStatesStackSize - 1)) {
		[NSException raise:@"StackOverflowException"
					format:@"Cannot push state as stack exceeds maximum size %d", EDLexerStatesStackSize];
	} else {
		stack[stackPosition++] = currentState;
		currentState = newStateId;
	}
	
	isChanged = YES;
}

-(void)popState {
	if (stackPosition <= 0) {
		[NSException raise:@"StackUnderflowException"
					format:@"Cannot pop state as nothing current on stack"];
	} else {
		currentState = stack[--stackPosition];
	}
	
	isChanged = YES;
}

-(void)rewindToState:(NSUInteger)stateId {
	NSUInteger i = 0;
	for (; i < stackPosition; ++i) {
		if (currentState == stateId) {
			break;
		}
		
		[self popState];
	}
}

-(NSUInteger)currentState {
	return currentState;
}

-(BOOL)includesState:(NSUInteger)stateId {
	BOOL included = (currentState == stateId || stackPosition == 0);
	if (!included) {
		NSUInteger i = 0;
		for (; i < stackPosition; ++i) {
			if (stack[i] == stateId) {
				included = YES;
				break;
			}
		}
	}
	
	return included;
}

-(void)reset {
	currentState = 0;
	stackPosition = 0;
	isChanged = NO;
}

-(void)dealloc {
	[stateNames release];
	[super dealloc];
}

@end
