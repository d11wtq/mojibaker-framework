//
//  EDExactStringLexRule.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDExactStringLexRule.h"
#import "EDLexicalToken.h"

@implementation EDExactStringLexRule

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag {
	
	return [[[self alloc] initWithString:string
							   tokenType:theTokenType
						 caseInsensitive:caseFlag] autorelease];
}

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive {
	
	return [[[self alloc] initWithString:string
							   tokenType:theTokenType
						 caseInsensitive:caseFlag
								   state:stateId
							   inclusive:isStateInclusive] autorelease];
}

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		  pushState:(NSUInteger)newStateId {
	
	return [[[self alloc] initWithString:string
							   tokenType:theTokenType
						 caseInsensitive:caseFlag
								   state:stateId
							   inclusive:isStateInclusive
							   pushState:newStateId] autorelease];
}

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		 beginState:(NSUInteger)newStateId {
	
	return [[[self alloc] initWithString:string
							   tokenType:theTokenType
						 caseInsensitive:caseFlag
								   state:stateId
							   inclusive:isStateInclusive
							  beginState:newStateId] autorelease];
}

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		   popState:(BOOL)shouldPopState {
	
	return [[[self alloc] initWithString:string
							   tokenType:theTokenType
						 caseInsensitive:caseFlag
								   state:stateId
							   inclusive:isStateInclusive
								popState:shouldPopState] autorelease];
}

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
		  pushState:(NSUInteger)newStateId {
	
	return [[[self alloc] initWithString:string
							   tokenType:theTokenType
						 caseInsensitive:caseFlag
							   pushState:newStateId] autorelease];
}

+(id)ruleWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
		 beginState:(NSUInteger)newStateId {
	
	return [[[self alloc] initWithString:string
							   tokenType:theTokenType
						 caseInsensitive:caseFlag
							  beginState:newStateId] autorelease];
}

#pragma mark -

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag {
	if (self = [self init]) {
		needleString = caseFlag
			? [[string lowercaseString] copy]
			: [string copy]
			;
		caseInsensitive = caseFlag;
		tokenType = theTokenType;
	}
	
	return self;
}

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive {
	
	if (self = [self initWithString:string tokenType:theTokenType caseInsensitive:caseFlag]) {
		if (isStateInclusive) {
			inclusiveState = stateId;
		} else {
			exclusiveState = stateId;
		}
	}
	
	return self;
}

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		  pushState:(NSUInteger)newStateId {
	
	if (self = [self initWithString:string tokenType:theTokenType caseInsensitive:caseFlag]) {
		if (isStateInclusive) {
			inclusiveState = stateId;
		} else {
			exclusiveState = stateId;
		}
		
		pushState = newStateId;
	}
	
	return self;
}

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		 beginState:(NSUInteger)newStateId {
	
	if (self = [self initWithString:string tokenType:theTokenType caseInsensitive:caseFlag]) {
		if (isStateInclusive) {
			inclusiveState = stateId;
		} else {
			exclusiveState = stateId;
		}
		
		beginState = newStateId;
	}
	
	return self;
}

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
			  state:(NSUInteger)stateId
		  inclusive:(BOOL)isStateInclusive
		   popState:(BOOL)shouldPopState {
	
	if (self = [self initWithString:string tokenType:theTokenType caseInsensitive:caseFlag]) {
		if (isStateInclusive) {
			inclusiveState = stateId;
		} else {
			exclusiveState = stateId;
		}
		
		popsState = shouldPopState;
	}
	
	return self;
}

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
		  pushState:(NSUInteger)newStateId {
	
	if (self = [self initWithString:string tokenType:theTokenType caseInsensitive:caseFlag]) {
		pushState = newStateId;
	}
	
	return self;
}

-(id)initWithString:(NSString *)string
		  tokenType:(EDLexicalTokenType)theTokenType
	caseInsensitive:(BOOL)caseFlag
		 beginState:(NSUInteger)newStateId {
	
	if (self = [self initWithString:string tokenType:theTokenType caseInsensitive:caseFlag]) {
		beginState = newStateId;
	}
	
	return self;
}

#pragma mark -

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states {
	if (range.length < needleString.length) {
		return nil;
	}
	
	EDLexicalToken *tok = nil;
	
	NSRange matchRange = NSMakeRange(range.location, needleString.length);
	NSString *rangeSubstring = [string substringWithRange:matchRange];
	
	if (caseInsensitive) {
		rangeSubstring = [rangeSubstring lowercaseString];
	}
	
	if ([rangeSubstring isEqualToString:needleString]) {
		tok = [EDLexicalToken tokenWithType:tokenType range:matchRange];
	}
	
	return tok;
}

-(void)dealloc {
	[needleString release];
	[super dealloc];
}

@end
