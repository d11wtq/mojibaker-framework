//
//  EDCharacterSetLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@interface EDCharacterSetLexRule : EDLexRule {
	NSCharacterSet *permittedCharacterSet;
}

+(id)ruleWithCharacterSet:(NSCharacterSet *)characterSet;
-(id)initWithCharacterSet:(NSCharacterSet *)characterSet;

@end
