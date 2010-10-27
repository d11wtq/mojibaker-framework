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
	EDLexicalTokenType type;
	NSRange range;
	EDLexerResult *sublexedResult;
}

@property (readonly) EDLexicalTokenType type;
@property (readonly) NSRange range;
@property (readonly) EDLexerResult *sublexedResult;

-(id)initWithType:(EDLexicalTokenType)theType range:(NSRange)theRange;
-(id)initWithType:(EDLexicalTokenType)theType range:(NSRange)theRange sublexedResult:(EDLexerResult *)result;
+(id)tokenWithType:(EDLexicalTokenType)theType range:(NSRange)theRange;
+(id)tokenWithType:(EDLexicalTokenType)theType range:(NSRange)theRange sublexedResult:(EDLexerResult *)result;

@end
