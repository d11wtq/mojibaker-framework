//
//  EDLexicalToken.h
//  Editor
//
//  Created by Chris Corbyn on 21/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "EDTokenDefines.h"
#include "EDLexerStatesInfo.h"

@class EDLexerResult;
@class EDLexicalToken;

@interface EDLexicalToken : NSObject {
	EDLexicalTokenType type;
	NSRange range;
	EDLexerStatesInfo stackInfo;
}

@property (readonly) EDLexicalTokenType type;
@property (readonly) NSRange range;
@property (nonatomic) EDLexerStatesInfo stackInfo;

-(id)initWithType:(EDLexicalTokenType)theType range:(NSRange)theRange;
+(id)tokenWithType:(EDLexicalTokenType)theType range:(NSRange)theRange;

-(void)moveBy:(NSInteger)delta;

-(BOOL)isEqualToToken:(EDLexicalToken *)token;

@end
