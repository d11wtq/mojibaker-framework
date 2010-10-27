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
@class EDLexerResult;

@interface EDLexer : NSObject {
	NSMutableArray *rules;
	id<EDLexRule> defaultRule;
}

+(id)lexer;

-(void)addRule:(id<EDLexRule>)ruleToAdd;

-(EDLexerResult *)lexString:(NSString *)string range:(NSRange)range;
-(EDLexerResult *)lexString:(NSString *)string;

-(EDLexicalToken *)nextTokenInString:(NSString *)string range:(NSRange)range;

@end
