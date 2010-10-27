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

@interface EDLexicalToken : NSObject {
	NSUInteger type;
	NSRange range;
	EDLexerResult *sublexedResult;
}

@property (readonly) NSUInteger type;
@property (readonly) NSRange range;
@property (readonly) EDLexerResult *sublexedResult;

-(id)initWithType:(NSUInteger)theType range:(NSRange)theRange;
-(id)initWithType:(NSUInteger)theType range:(NSRange)theRange sublexedResult:(EDLexerResult *)result;
+(id)tokenWithType:(NSUInteger)theType range:(NSRange)theRange;
+(id)tokenWithType:(NSUInteger)theType range:(NSRange)theRange sublexedResult:(EDLexerResult *)result;

@end
