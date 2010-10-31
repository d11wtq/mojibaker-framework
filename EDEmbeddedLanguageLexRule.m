//
//  EDEmbeddedLanguageLexRule.m
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDEmbeddedLanguageLexRule.h"
#import "EDLexer.h"
#import "EDLexerResult.h"
#import "EDLexicalToken.h"
#import "EDTokenDefines.h"

@implementation EDEmbeddedLanguageLexRule

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer
		usingState:(NSUInteger)stateId {
	return [[[self alloc] initWithStart:startString end:endString lexer:embeddedLexer usingState:stateId] autorelease];
}

-(id)initWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer usingState:(NSUInteger)stateId {
	if (self = [self init]) {
		start = [startString copy];
		end = [endString copy];
		lexer = [embeddedLexer retain];
		embeddedState = stateId;
		inclusiveState = stateId;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states {
	EDLexicalToken *tok = nil;
	
	if ([states includesState:embeddedState] && states.currentState > 0) {
		NSRange endRange = NSMakeRange(range.location, end.length);
		if (endRange.length <= range.length && [[string substringWithRange:endRange] isEqualToString:end]) {
			tok = [EDLexicalToken tokenWithType:EDEmbeddedLanguageDelimiterToken range:endRange];
			[states rewindToState:embeddedState];
			[states popState];
		} else {
			tok = [lexer nextTokenInString:string range:range];
		}
	} else {
		NSRange startRange = NSMakeRange(range.location, start.length);
		if (startRange.length <= range.length && [[string substringWithRange:startRange] isEqualToString:start]) {
			tok = [EDLexicalToken tokenWithType:EDEmbeddedLanguageDelimiterToken range:startRange];
			[states pushState:embeddedState];
		}
	}
	
	return tok;
}

-(void)dealloc {
	[start release];
	[end release];
	[lexer release];
	[super dealloc];
}

@end
