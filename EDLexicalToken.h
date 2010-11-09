//
//  EDLexicalToken.h
//  Editor
//
//  Created by Chris Corbyn on 21/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "EDTokenDefines.h"

@class EDLexerResult;
@class EDLexicalToken;
@class EDLexerStatesSnapshot;

@interface EDLexicalToken : NSObject {
	EDLexicalTokenType type;
	NSRange range;
	EDLexerStatesSnapshot *statesSnapshot;
}

@property (readonly) EDLexicalTokenType type;
@property (readonly) NSRange range;
@property (nonatomic, retain) EDLexerStatesSnapshot *statesSnapshot;

-(id)initWithType:(EDLexicalTokenType)theType range:(NSRange)theRange;
+(id)tokenWithType:(EDLexicalTokenType)theType range:(NSRange)theRange;

-(void)moveBy:(NSInteger)delta;

-(BOOL)isEqualToToken:(EDLexicalToken *)token;

@end
