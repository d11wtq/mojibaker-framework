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

+(id)states {
	return [[[self alloc] init] autorelease];
}

-(id)init {
	if (self = [super init]) {
		stateNames = [[NSMutableDictionary alloc] init];
		scopeStack = [[NSMutableArray alloc] init];
		scopes = [[NSMutableArray alloc] init];
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

-(void)stackInfo:(EDLexerStatesInfo *)stackInfo {
	int i = 0;
	for (; i < stackPosition; ++i) {
		stackInfo->stack[i] = stack[i];
	}
	
	stackInfo->stackSize = stackPosition;
	stackInfo->currentState = currentState;
}

-(void)applyStackInfo:(EDLexerStatesInfo)stackInfo {
	if (stackInfo.stackSize > EDLexerStatesStackSize) {
		[NSException raise:@"StackOverflowException"
					format:@"New stack size exceeds maximum size %d", EDLexerStatesStackSize];
	}
	
	NSUInteger i = 0;
	for (; i < stackInfo.stackSize; ++i) {
		stack[i] = stackInfo.stack[i];
	}
	
	stackPosition = stackInfo.stackSize;
	currentState = stackInfo.currentState;
}

-(void)beginScopeAtRange:(NSRange)range {
	NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(range.location, 0)];
	[scopes addObject:rangeValue];
	[scopeStack addObject:rangeValue];
	
	isChanged = YES;
}

-(void)endScopeAtRange:(NSRange)range {
	NSValue *value = [scopeStack lastObject];
	[scopeStack removeLastObject];
	
	// There has to be a better way... we've already got a reference this this NSValue!??!
	NSUInteger index = [scopes indexOfObjectIdenticalTo:value];
	
	NSRange actualRange = [value rangeValue];
	actualRange.length = NSMaxRange(range) - actualRange.location;
	
	[scopes replaceObjectAtIndex:index withObject:[NSValue valueWithRange:actualRange]];
	
	isChanged = YES;
}

-(NSArray *)scopeRanges {
	return scopes;
}

-(void)beginState:(NSUInteger)newStateId {
	currentState = newStateId;
	isChanged = YES;
}

-(void)pushState:(NSUInteger)newStateId {
	if (stackPosition >= (EDLexerStatesStackSize - 1)) {
		[NSException raise:@"StackOverflowException"
					format:@"Cannot push state as stack exceeds maximum size %d", EDLexerStatesStackSize];
	} else {
		stack[stackPosition++] = currentState;
		[self beginState:newStateId];
	}
	
	isChanged = YES;
}

-(void)popState {
	if (stackPosition <= 0) {
		[NSException raise:@"StackUnderflowException"
					format:@"Cannot pop state as nothing current on stack"];
	} else {
		[self beginState:stack[--stackPosition]];
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
	[scopeStack removeAllObjects];
	[scopes removeAllObjects];
	currentState = 0;
	stackPosition = 0;
	isChanged = NO;
}

-(void)dealloc {
	[stateNames release];
	[scopeStack release];
	[scopes release];
	[super dealloc];
}

@end
