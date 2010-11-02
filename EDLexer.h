//
//  EDLexer.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDLexerStates.h"

@class EDLexicalToken;
@class EDLexerResult;
@class EDLexerStates;

@interface EDLexer : NSObject {
	NSMutableArray *rules;
	NSArray *lastResortRules;
	EDLexerStates *states;
}

@property (nonatomic, retain) EDLexerStates *states;

+(id)lexerWithStates:(EDLexerStates *)stateMachine;
-(id)initWithStates:(EDLexerStates *)stateMachine;

-(void)addRule:(EDLexRule *)ruleToAdd;

-(EDLexerResult *)lexString:(NSString *)string editedRange:(NSRange)editedRange changeInLength:(NSInteger)delta
			 previousResult:(EDLexerResult *)previousResult;

-(EDLexerResult *)lexString:(NSString *)string range:(NSRange)range
			 changeInLength:(NSInteger)delta previousResult:(EDLexerResult *)previousResult;

-(EDLexerResult *)lexString:(NSString *)string range:(NSRange)range;
-(EDLexerResult *)lexString:(NSString *)string;

-(EDLexicalToken *)nextTokenInString:(NSString *)string range:(NSRange)range;

@end
