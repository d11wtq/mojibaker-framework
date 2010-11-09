//
//  EDDelimitedStringLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDTokenDefines.h"

@interface EDDelimitedStringLexRule : EDLexRule {
	NSString *start;
	NSString *end;
	NSString *escape;
}

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString tokenType:(EDLexicalTokenType)theTokenType;

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString escape:(NSString *)escapeString
		 tokenType:(EDLexicalTokenType)theTokenType;

-(id)initWithStart:(NSString *)startString end:(NSString *)endString escape:(NSString *)escapeString
		 tokenType:(EDLexicalTokenType)theTokenType;

@end
