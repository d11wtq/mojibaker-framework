//
//  EDExactStringLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@interface EDExactStringLexRule : EDLexRule {
	NSString *needleString;
	BOOL caseInsensitive;
}

+(id)ruleWithString:(NSString *)string caseInsensitive:(BOOL)isCaseInsensitive;
-(id)initWithString:(NSString *)string caseInsensitive:(BOOL)isCaseInsensitive;

@end
