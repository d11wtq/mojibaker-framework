//
//  EDEmbeddedLanguageLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@class EDLexer;

@interface EDEmbeddedLanguageLexRule : NSObject <EDLexRule> {
	NSString *start;
	NSString *end;
	NSUInteger tokenType;
	EDLexer *lexer;
}

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer;
+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer
		 tokenType:(NSUInteger)theTokenType;
-(id)initWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer
		 tokenType:(NSUInteger)theTokenType;

@end
