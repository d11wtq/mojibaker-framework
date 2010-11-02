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

@property (readonly) EDLexerStates *states;

+(id)lexerWithStates:(EDLexerStates *)stateMachine;
-(id)initWithStates:(EDLexerStates *)stateMachine;

-(void)addRule:(EDLexRule *)ruleToAdd;

-(void)lexString:(NSString *)string editedRange:(NSRange)editedRange changeInLength:(NSInteger)delta
  previousResult:(EDLexerResult *)previousResult intoResult:(EDLexerResult *)result;

-(void)lexString:(NSString *)string intoResult:(EDLexerResult *)result;

-(EDLexicalToken *)nextTokenInString:(NSString *)string range:(NSRange)range;

@end
