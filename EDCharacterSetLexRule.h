//
//  EDCharacterSetLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDTokenDefines.h"

@interface EDCharacterSetLexRule : NSObject <EDLexRule> {
	NSCharacterSet *permittedCharacterSet;
	EDLexicalTokenType tokenType;
}

+(id)ruleWithCharacterSet:(NSCharacterSet *)characterSet tokenType:(EDLexicalTokenType)theTokenType;

-(id)initWithCharacterSet:(NSCharacterSet *)characterSet tokenType:(EDLexicalTokenType)theTokenType;

@end
