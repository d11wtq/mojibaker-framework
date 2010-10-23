//
//  EDAnyCharacterLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@interface EDAnyCharacterLexRule : NSObject <EDLexRule> {
	NSUInteger tokenType;
}

+(id)ruleWithTokenType:(NSUInteger)theTokenType;
+(id)rule;

-(id)initWithTokenType:(NSUInteger)theTokenType;

@end
