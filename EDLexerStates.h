//
//  EDLexerStates.h
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define EDLexerStatesStackSize 100

@interface EDLexerStates : NSObject {
	NSUInteger currentState;
	NSUInteger highestStateId;
	NSUInteger stack[EDLexerStatesStackSize];
	NSUInteger stackPosition;
	NSMutableDictionary *stateNames;
}

/*!
 * Returns the ID of the state name stateName, or generates one if needed.
 */
-(NSUInteger)stateNamed:(NSString *)stateName;

-(void)pushState:(NSUInteger)newStateId;
-(void)popState;
-(NSUInteger)currentState;

-(void)reset;

@end
