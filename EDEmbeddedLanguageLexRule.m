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

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer {
	return [[[self alloc] initWithStart:startString end:endString lexer:embeddedLexer tokenType:EDEmbeddedLanguageToken] autorelease];
}

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer
		 tokenType:(NSUInteger)theTokenType {
	return [[[self alloc] initWithStart:startString end:endString lexer:embeddedLexer tokenType:theTokenType] autorelease];
}

-(id)initWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer
		 tokenType:(NSUInteger)theTokenType {
	if (self = [self init]) {
		start = [startString copy];
		end = [endString copy];
		tokenType = theTokenType;
		lexer = [embeddedLexer retain];
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range {
	if (range.length < start.length) {
		return nil;
	}
	
	EDLexicalToken *tok = nil;
	
	if ([[string substringWithRange:NSMakeRange(range.location, start.length)] isEqualToString:start]) {
		NSUInteger offset = range.location;
		NSUInteger endOffset = range.location + range.length;
		NSMutableArray *tokens = [NSMutableArray array];
		
		while (tok = [lexer nextTokenInString:string range:NSMakeRange(offset, endOffset - offset)]) {
			[tokens addObject:tok];
			offset += tok.range.length;
			if (offset >= endOffset) {
				break;
			}
			
			if (offset + end.length < endOffset) {
				if ([[string substringWithRange:NSMakeRange(offset, end.length)] isEqualToString:end]) {
					// End of embedded block found
					offset += end.length;
					break;
				}
			}
		}
		
		tok = [EDLexicalToken tokenWithType:tokenType
									  range:NSMakeRange(range.location, range.length - (endOffset - offset))
							 sublexedResult:[EDLexerResult resultWithTokens:tokens]];
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
