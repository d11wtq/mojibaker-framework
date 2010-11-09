//
//  EDCharacterLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@interface EDCharacterLexRule : EDLexRule {
	unichar ch;
}

+(id)rule;
+(id)ruleWithUnicodeChar:(unichar)aChar;

-(id)initWithUnicodeChar:(unichar)aChar;

@end
