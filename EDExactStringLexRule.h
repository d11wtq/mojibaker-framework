//
//  EDExactStringLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@interface EDExactStringLexRule : NSObject <EDLexRule> {
	NSString *needleString;
	NSUInteger tokenType;
	BOOL caseInsensitive;
}

+(id)ruleWithString:(NSString *)string tokenType:(NSUInteger)theTokenType caseInsensitive:(BOOL)isCaseInsensitive;
-(id)initWithString:(NSString *)string tokenType:(NSUInteger)theTokenType caseInsensitive:(BOOL)isCaseInsensitive;

@end
