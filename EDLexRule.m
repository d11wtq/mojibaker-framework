//
//  EDLexRule.m
//  EditorSDK
//
//  Created by Chris Corbyn on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexRule.h"
#import "EDLexicalToken.h"
#import "EDLexerStates.h"

@implementation EDLexRule

@synthesize tokenType;
@synthesize isDefinite;
@synthesize exclusiveState;
@synthesize inclusiveState;
@synthesize beginState;
@synthesize pushState;
@synthesize popsState;
@synthesize beginsScope;
@synthesize endsScope;

-(id)init {
	if (self = [super init]) {
		tokenType = EDUnmatchedToken;
		isDefinite = YES;
		exclusiveState = -1;
		inclusiveState = -1;
		beginState = -1;
		pushState = -1;
		popsState = NO;
		beginsScope = NO;
		endsScope = NO;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states {
	return nil;
}

@end
