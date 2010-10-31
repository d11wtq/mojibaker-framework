//
//  EDPatternLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDTokenDefines.h"

@interface EDPatternLexRule : EDLexRule {
	NSString *pattern;
	EDLexicalTokenType tokenType;
}

+(id)ruleWithPattern:(NSString *)icuPattern tokenType:(EDLexicalTokenType)theTokenType;
-(id)initWithPattern:(NSString *)icuPattern tokenType:(EDLexicalTokenType)theTokenType;

@end
