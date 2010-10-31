//
//  EDAnyCharacterLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDTokenDefines.h"

@interface EDAnyCharacterLexRule : EDLexRule {
	EDLexicalTokenType tokenType;
}

+(id)ruleWithTokenType:(EDLexicalTokenType)theTokenType;
+(id)rule;

-(id)initWithTokenType:(EDLexicalTokenType)theTokenType;

@end
