//
//  EDLexerStates.h
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexerStatesInfo.h"

@interface EDLexerStates : NSObject {
	NSUInteger currentState;
	NSUInteger highestStateId;
	NSUInteger stack[EDLexerStatesStackSize];
	NSUInteger stackPosition;
	NSMutableDictionary *stateNames;
	BOOL isChanged;
}

@property (nonatomic) BOOL isChanged;

/*!
 * Returns the ID of the state name stateName, or generates one if needed.
 */
-(NSUInteger)stateNamed:(NSString *)stateName;

-(void)stackInfo:(EDLexerStatesInfo *)stackInfo;
-(void)applyStackInfo:(EDLexerStatesInfo)stackInfo;

-(void)pushState:(NSUInteger)newStateId;
-(void)popState;
-(void)rewindToState:(NSUInteger)stateId;
-(NSUInteger)currentState;
-(BOOL)includesState:(NSUInteger)stateId;

-(void)reset;

@end
