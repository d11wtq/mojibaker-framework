//
//  EDLexicalToken.m
//  Editor
//
//  Created by Chris Corbyn on 21/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexicalToken.h"
#import "EDLexerResult.h"

@implementation EDLexicalToken

@synthesize type;
@synthesize range;
@synthesize stackInfo;

+(id)tokenWithType:(EDLexicalTokenType)theType range:(NSRange)theRange {
	return [[[self alloc] initWithType:theType range:theRange] autorelease];
}

-(id)initWithType:(EDLexicalTokenType)theType range:(NSRange)theRange {
	if (self = [self init]) {
		type = theType;
		range = theRange;
		// FIXME: What to assign to stackInfo by default?
	}
	
	return self;
}

-(void)moveBy:(NSInteger)delta {
	range.location += delta;
}

@end
