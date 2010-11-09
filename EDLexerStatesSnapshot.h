//
//  EDLexerStatesSnapshot.h
//  EditorSDK
//
//  Created by Chris Corbyn on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EDLexerStatesSnapshot;

@interface EDLexerStatesSnapshot : NSObject {
	NSUInteger currentState;
	NSArray *stack;
}

@property (nonatomic, retain) NSArray *stack;
@property (nonatomic) NSUInteger currentState;

+(id)snapshotWithStack:(NSArray *)aStack currentState:(NSUInteger)aState;
-(id)initWithStack:(NSArray *)aStack currentState:(NSUInteger)aState;

-(BOOL)isEqualToSnapshot:(EDLexerStatesSnapshot *)snapshot;

@end
