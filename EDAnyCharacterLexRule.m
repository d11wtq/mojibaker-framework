//
//  EDAnyCharacterLexRule.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDAnyCharacterLexRule.h"
#import "EDLexicalToken.h"

@implementation EDAnyCharacterLexRule

+(id)ruleWithTokenType:(EDLexicalTokenType)theTokenType {
	return [[[self alloc] initWithTokenType:theTokenType] autorelease];
}

+(id)rule {
	return [[[self alloc] init] autorelease];
}

-(id)init {
	if (self = [super init]) {
		tokenType = EDUnmatchedCharacterToken;
	}
	
	return self;
}

-(id)initWithTokenType:(EDLexicalTokenType)theTokenType {
	if (self = [self init]) {
		tokenType = theTokenType;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states {
	return [EDLexicalToken tokenWithType:tokenType range:NSMakeRange(range.location, 1)];
}

@end
