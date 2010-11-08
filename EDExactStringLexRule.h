//
//  EDExactStringLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDTokenDefines.h"

@interface EDExactStringLexRule : EDLexRule {
	NSString *needleString;
	EDLexicalTokenType tokenType;
	BOOL caseInsensitive;
}

#pragma mark -
#pragma mark Initializers

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)isCaseInsensitive;

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive;

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		  pushState:(NSUInteger)newStateId;

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		 beginState:(NSUInteger)newStateId;

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		   popState:(BOOL)shouldPopState;

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
		  pushState:(NSUInteger)newStateId;

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
		 beginState:(NSUInteger)newStateId;

#pragma mark -

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)isCaseInsensitive;

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive;

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		  pushState:(NSUInteger)newStateId;

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		 beginState:(NSUInteger)newStateId;

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		   popState:(BOOL)shouldPopState;

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
		  pushState:(NSUInteger)newStateId;

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
		 beginState:(NSUInteger)newStateId;

@end
