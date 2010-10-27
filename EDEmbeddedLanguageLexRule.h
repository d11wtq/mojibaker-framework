//
//  EDEmbeddedLanguageLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDTokenDefines.h"

@class EDLexer;

@interface EDEmbeddedLanguageLexRule : NSObject <EDLexRule> {
	NSString *start;
	NSString *end;
	EDLexicalTokenType tokenType;
	EDLexer *lexer;
}

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer;
+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer
		 tokenType:(EDLexicalTokenType)theTokenType;
-(id)initWithStart:(NSString *)startString end:(NSString *)endString lexer:(EDLexer *)embeddedLexer
		 tokenType:(EDLexicalTokenType)theTokenType;

@end
