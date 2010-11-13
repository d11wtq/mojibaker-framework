//
//  EDLexerBuffer.m
//  EditorSDK
//
//  Created by Chris Corbyn on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexerBuffer.h"
#import "EDLexer.h"
#import "EDLexicalToken.h"

@implementation EDLexerBuffer

@synthesize lookbehind;

-(id)initWithLexer:(EDLexer *)aLexer string:(NSString *)sourceString {
	if (self = [self init]) {
		lexer = [aLexer retain];
		string = [sourceString retain]; // Safe to avoid copying since this is a highly controlled environment
	}
	
	return self;
}

-(void)dealloc {
	[lexer release];
	[string release];
	[lookbehind release];
	[super dealloc];
}

@end
