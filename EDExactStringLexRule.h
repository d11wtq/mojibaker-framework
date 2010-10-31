//
//  EDExactStringLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDTokenDefines.h"

@interface EDExactStringLexRule : EDLexRule {
	NSString *needleString;
	EDLexicalTokenType tokenType;
	BOOL caseInsensitive;
}

+(id)ruleWithString:(NSString *)string tokenType:(EDLexicalTokenType)theTokenType;
+(id)ruleWithString:(NSString *)string tokenType:(EDLexicalTokenType)theTokenType caseInsensitive:(BOOL)isCaseInsensitive;
-(id)initWithString:(NSString *)string tokenType:(EDLexicalTokenType)theTokenType caseInsensitive:(BOOL)isCaseInsensitive;

@end
