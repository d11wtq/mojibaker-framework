//
//  EDLexerStates.m
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexerStates.h"


@implementation EDLexerStates

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

-(void)pushState:(NSUInteger)newStateId {
	if (stackPosition >= (EDLexerStatesStackSize - 1)) {
		[NSException raise:@"StackOverflowException"
					format:@"Cannot push state as stack exceeds maximum size %d", EDLexerStatesStackSize];
	} else {
		stack[stackPosition++] = currentState;
		currentState = newStateId;
	}
}

-(void)popState {
	if (stackPosition <= 0) {
		[NSException raise:@"StackUnderflowException"
					format:@"Cannot pop state as nothing current on stack"];
	} else {
		currentState = stack[--stackPosition];
	}
}

-(NSUInteger)currentState {
	return currentState;
}

-(void)reset {
	currentState = 0;
	stackPosition = 0;
}

-(void)dealloc {
	[stateNames release];
	[super dealloc];
}

@end
