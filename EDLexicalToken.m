//
//  EDLexicalToken.m
//  Editor
//
//  Created by Chris Corbyn on 21/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexicalToken.h"
#import "EDLexerResult.h"
#import "EDLexerStatesSnapshot.h"

@implementation EDLexicalToken

@synthesize type;
@synthesize range;
@synthesize statesSnapshot;

+(id)tokenWithType:(EDLexicalTokenType)theType range:(NSRange)theRange {
	return [[[self alloc] initWithType:theType range:theRange] autorelease];
}

-(id)initWithType:(EDLexicalTokenType)theType range:(NSRange)theRange {
	if (self = [self init]) {
		type = theType;
		range = theRange;
	}
	
	return self;
}

-(void)moveBy:(NSInteger)delta {
	range.location += delta;
}

-(BOOL)isEqualToToken:(EDLexicalToken *)token {
	return token
		&& (range.location == token.range.location
			&& range.length == token.range.length
			&& type == token.type
			&& [statesSnapshot isEqualToSnapshot:token.statesSnapshot]);
}

@end
