//
//  EDLexerStatesSnapshot.m
//  EditorSDK
//
//  Created by Chris Corbyn on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexerStatesSnapshot.h"


@implementation EDLexerStatesSnapshot

@synthesize stack;
@synthesize currentState;

+(id)snapshotWithStack:(NSArray *)aStack currentState:(NSUInteger)aState {
	return [[[self alloc] initWithStack:aStack currentState:aState] autorelease];
}

-(id)initWithStack:(NSArray *)aStack currentState:(NSUInteger)aState {
	if (self = [self init]) {
		stack = [aStack retain];
		currentState = aState;
	}
	
	return self;
}

-(BOOL)isEqualToSnapshot:(EDLexerStatesSnapshot *)snapshot {
	return (currentState == [snapshot currentState]) && [stack isEqualToArray:[snapshot stack]];
}

-(void)dealloc {
	[stack release];
	[super dealloc];
}

@end
