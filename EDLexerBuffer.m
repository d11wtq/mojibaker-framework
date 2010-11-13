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
@synthesize token;

-(id)initWithLexer:(EDLexer *)aLexer string:(NSString *)sourceString {
	if (self = [self init]) {
		lexer = [aLexer retain];
		string = [sourceString retain]; // Safe to avoid copying since this is a highly controlled environment
		lookaheadStack = [[NSMutableArray alloc] init];
	}
	
	return self;
}

-(void)setToken:(EDLexicalToken *)tok {
	[token release];
	token = [tok retain];
	
	[lastToken release];
	lastToken = [tok retain];
	
	[lookaheadStack removeAllObjects];
}

-(EDLexicalToken *)lookahead {
	EDLexerBuffer *lookaheadBuffer = [[EDLexerBuffer alloc] initWithLexer:lexer string:string];
	lookaheadBuffer.lookbehind = lastToken;
	
	NSUInteger location = NSMaxRange(lastToken.range);
	
	[lastToken release];
	
	lastToken = [lexer nextTokenInString:string
								   range:NSMakeRange(location, string.length - location)
								  buffer:lookaheadBuffer];
	
	[lookaheadBuffer release];
	
	[lastToken retain];
	
	if (lastToken) {
		[lookaheadStack addObject:lastToken];
	}
	
	return lastToken;
}

-(NSArray *)lookaheadStack {
	return lookaheadStack;
}

-(void)dealloc {
	[lexer release];
	[string release];
	[lookaheadStack release];
	[lookbehind release];
	[token release];
	[lastToken release];
	[super dealloc];
}

@end
