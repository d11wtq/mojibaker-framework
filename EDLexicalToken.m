//
//  EDLexicalToken.m
//  Editor
//
//  Created by Chris Corbyn on 21/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexicalToken.h"


@implementation EDLexicalToken

@synthesize type;
@synthesize range;

+(id)tokenWithType:(NSUInteger)theType range:(NSRange)theRange {
	return [[[self alloc] initWithType:theType range:theRange] autorelease];
}

-(id)initWithType:(NSUInteger)theType range:(NSRange)theRange {
	if (self = [self init]) {
		type = theType;
		range = theRange;
	}
	
	return self;
}

@end
