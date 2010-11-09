//
//  EDPatternLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@interface EDPatternLexRule : EDLexRule {
	NSString *pattern;
}

+(id)ruleWithPattern:(NSString *)icuPattern;
-(id)initWithPattern:(NSString *)icuPattern;

@end
