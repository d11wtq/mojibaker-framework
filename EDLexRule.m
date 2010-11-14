//
//  EDLexRule.m
//  EditorSDK
//
//  Created by Chris Corbyn on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexRule.h"
#import "EDLexer.h"
#import "EDLexicalToken.h"
#import "EDLexerBuffer.h"
#import "EDLexerStates.h"

@implementation EDLexRule

@synthesize lexer;
@synthesize tokenType;
@synthesize isDefinite;
@synthesize state;
@synthesize isStateInclusive;
@synthesize beginState;
@synthesize pushState;
@synthesize popsState;
@synthesize beginsScope;
@synthesize endsScope;
@synthesize follows;
@synthesize precedes;

-(id)init {
	if (self = [super init]) {
		tokenType = EDUnmatchedToken;
		isDefinite = YES;
		state = -1;
		isStateInclusive = NO;
		beginState = -1;
		pushState = -1;
		popsState = NO;
		beginsScope = NO;
		endsScope = NO;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range buffer:(EDLexerBuffer *)buffer states:(EDLexerStates *)states {
	return nil;
}

-(void)dealloc {
	[follows release];
	[precedes release];
	[super dealloc];
}

@end
