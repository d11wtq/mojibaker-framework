//
//  EDLexicalToken.m
//  Editor
//
//  Created by Chris Corbyn on 21/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexicalToken.h"
#import "EDLexerResult.h"

// FIXME: Move me to a EDLexerFunctions.h include
BOOL EDStacksEqual(EDLexerStatesInfo s1, EDLexerStatesInfo s2) {
	BOOL result = NO;
	
	if (s1.currentState == s2.currentState && s1.stackSize == s2.stackSize) {
		result = YES;
		int i = 0;
		for (; i < s1.stackSize; ++i) {
			if (s1.stack[i] != s2.stack[i]) {
				result = NO;
				break;
			}
		}
	}
	
	return result;
}

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
		stackInfo = (EDLexerStatesInfo) {
			.stackSize = 0,
			.currentState = 0
		};
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
			&& EDStacksEqual(stackInfo, token.stackInfo));
}

@end
