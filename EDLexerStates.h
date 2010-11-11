//
//  EDLexerStates.h
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EDLexerStatesSnapshot;

@interface EDLexerStates : NSObject {
	NSUInteger currentState;
	NSUInteger highestStateId;
	NSMutableArray *stateStack;
	NSMutableDictionary *stateNames;
	BOOL isChanged;
}

@property (nonatomic) BOOL isChanged;

#pragma mark -
#pragma mark Initialization

+(id)states;

/*!
 * Returns the ID of the state name stateName, or generates one if needed.
 */
-(NSUInteger)stateNamed:(NSString *)stateName;

#pragma mark -
#pragma mark Restoring/describing the current state

-(EDLexerStatesSnapshot *)snapshot;
-(void)applySnapshot:(EDLexerStatesSnapshot *)snapshot;

#pragma mark -
#pragma mark State management

-(void)beginState:(NSUInteger)newStateId;
-(void)pushState:(NSUInteger)newStateId;
-(void)popState;
-(void)rewindToState:(NSUInteger)stateId;
-(NSUInteger)currentState;
-(BOOL)includesState:(NSUInteger)stateId;

#pragma mark -
#pragma mark Resetting the state machine

-(void)reset;

@end
