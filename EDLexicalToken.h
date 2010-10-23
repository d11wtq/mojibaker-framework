//
//  EDLexicalToken.h
//  Editor
//
//  Created by Chris Corbyn on 21/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "EDTokenDefines.h"

@interface EDLexicalToken : NSObject {
	NSUInteger type;
	NSRange range;
}

@property (readonly) NSUInteger type;
@property (readonly) NSRange range;

-(id)initWithType:(NSUInteger)theType range:(NSRange)theRange;
+(id)tokenWithType:(NSUInteger)theType range:(NSRange)theRange;

@end
