//
//  EDLexer.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@class EDLexicalToken;

@interface EDLexer : NSObject {
	NSMutableArray *rules;
	id<EDLexRule> defaultRule;
}

+(id)lexer;

-(void)addRule:(id<EDLexRule>)ruleToAdd;

-(NSArray *)tokensInString:(NSString *)string;
-(EDLexicalToken *)lex:(NSString *)string range:(NSRange)range;

@end
