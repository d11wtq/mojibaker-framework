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
@synthesize sublexedResult;

+(id)tokenWithType:(EDLexicalTokenType)theType range:(NSRange)theRange sublexedResult:(EDLexerResult *)result {
	return [[[self alloc] initWithType:theType range:theRange sublexedResult:result] autorelease];
}

+(id)tokenWithType:(EDLexicalTokenType)theType range:(NSRange)theRange {
	return [[[self alloc] initWithType:theType range:theRange] autorelease];
}

-(id)initWithType:(EDLexicalTokenType)theType range:(NSRange)theRange sublexedResult:(EDLexerResult *)result {
	if (self = [self init]) {
		type = theType;
		range = theRange;
		sublexedResult = [result retain];
	}
	
	return self;
}

-(id)initWithType:(EDLexicalTokenType)theType range:(NSRange)theRange {
	return [self initWithType:theType range:theRange sublexedResult:nil];
}

-(void)moveBy:(NSInteger)delta {
	range.location += delta;
}

-(void)dealloc {
	[sublexedResult release];
	[super dealloc];
}

@end
