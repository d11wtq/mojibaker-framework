//
//  EDDelimitedStringLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@interface EDDelimitedStringLexRule : NSObject <EDLexRule> {
	NSString *start;
	NSString *end;
	NSString *escape;
	NSUInteger tokenType;
}

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString tokenType:(NSUInteger)theTokenType;

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString escape:(NSString *)escapeString
		 tokenType:(NSUInteger)theTokenType;

-(id)initWithStart:(NSString *)startString end:(NSString *)endString escape:(NSString *)escapeString
		 tokenType:(NSUInteger)theTokenType;

@end
