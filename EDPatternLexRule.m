//
//  EDPatternLexRule.m
//  EditorSDK
//
//  Created by Chris Corbyn on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDPatternLexRule.h"
#import "EDLexicalToken.h"
#import "RegexKitLite.h"

@implementation EDPatternLexRule

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType {
	
	return [[[self alloc] initWithPattern:icuPattern
								tokenType:theTokenType] autorelease];
}

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive {
	
	return [[[self alloc] initWithPattern:icuPattern
								tokenType:theTokenType
									state:stateId
								inclusive:isStateInclusive] autorelease];
}

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
		   pushState:(NSUInteger)newStateId {
	
	return [[[self alloc] initWithPattern:icuPattern
								tokenType:theTokenType
									state:stateId
								inclusive:isStateInclusive
								pushState:newStateId] autorelease];
}

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
		  beginState:(NSUInteger)newStateId {
	
	return [[[self alloc] initWithPattern:icuPattern
								tokenType:theTokenType
									state:stateId
								inclusive:isStateInclusive
							   beginState:newStateId] autorelease];
}

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
			popState:(BOOL)shouldPopState {
	
	return [[[self alloc] initWithPattern:icuPattern
								tokenType:theTokenType
									state:stateId
								inclusive:isStateInclusive
								 popState:shouldPopState] autorelease];
}

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
		   pushState:(NSUInteger)newStateId {
	
	return [[[self alloc] initWithPattern:icuPattern
								tokenType:theTokenType
								pushState:newStateId] autorelease];
}

+(id)ruleWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
		  beginState:(NSUInteger)newStateId {
	
	return [[[self alloc] initWithPattern:icuPattern
								tokenType:theTokenType
							   beginState:newStateId] autorelease];
}

#pragma mark -

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType {
	
	if (self = [self init]) {
		pattern = [icuPattern copy];
		tokenType = theTokenType;
	}
	
	return self;
}

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive {
	
	if (self = [self initWithPattern:icuPattern tokenType:theTokenType]) {
		if (isStateInclusive) {
			inclusiveState = stateId;
		} else {
			exclusiveState = stateId;
		}
	}
	
	return self;
}

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
		   pushState:(NSUInteger)newStateId {
	
	if (self = [self initWithPattern:icuPattern tokenType:theTokenType]) {
		if (isStateInclusive) {
			inclusiveState = stateId;
		} else {
			exclusiveState = stateId;
		}
		
		pushState = newStateId;
	}
	
	return self;
}

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
		  beginState:(NSUInteger)newStateId {
	
	if (self = [self initWithPattern:icuPattern tokenType:theTokenType]) {
		if (isStateInclusive) {
			inclusiveState = stateId;
		} else {
			exclusiveState = stateId;
		}
		
		beginState = newStateId;
	}
	
	return self;
}

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
			   state:(NSUInteger)stateId
		   inclusive:(BOOL)isStateInclusive
			popState:(BOOL)shouldPopState {
	
	if (self = [self initWithPattern:icuPattern tokenType:theTokenType]) {
		if (isStateInclusive) {
			inclusiveState = stateId;
		} else {
			exclusiveState = stateId;
		}
		
		popsState = shouldPopState;
	}
	
	return self;
}

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
		   pushState:(NSUInteger)newStateId {
	
	if (self = [self initWithPattern:icuPattern tokenType:theTokenType]) {
		pushState = newStateId;
	}
	
	return self;
}

-(id)initWithPattern:(NSString *)icuPattern
		   tokenType:(EDLexicalTokenType)theTokenType
		  beginState:(NSUInteger)newStateId {
	
	if (self = [self initWithPattern:icuPattern tokenType:theTokenType]) {
		beginState = newStateId;
	}
	
	return self;
}

#pragma mark -

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states {
	NSRange matchedRange = [string rangeOfRegex:pattern inRange:range];
	
	if (matchedRange.location != range.location) {
		return nil;
	} else {
		return [EDLexicalToken tokenWithType:tokenType range:matchedRange];
	}
}

-(void)dealloc {
	[pattern release];
	[super dealloc];
}

@end
