//
//  EDPatternLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDTokenDefines.h"

@interface EDPatternLexRule : EDLexRule {
	NSString *pattern;
	EDLexicalTokenType tokenType;
}

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType;

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive;

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
		   pushState:(NSUInteger)newStateId;

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
		  beginState:(NSUInteger)newStateId;

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
			popState:(BOOL)shouldPopState;

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
		   pushState:(NSUInteger)newStateId;

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
		  beginState:(NSUInteger)newStateId;

#pragma mark -

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType;

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive;

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
		   pushState:(NSUInteger)newStateId;

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
		  beginState:(NSUInteger)newStateId;

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
			popState:(BOOL)shouldPopState;

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
		   pushState:(NSUInteger)newStateId;

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
		  beginState:(NSUInteger)newStateId;

@end
