//
//  EDLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDTokenDefines.h"

@class EDLexer;
@class EDLexRule;
@class EDLexicalToken;
@class EDLexerBuffer;
@class EDLexerStates;

@interface EDLexRule : NSObject {
	EDLexer *lexer;
	EDLexicalTokenType tokenType;
	BOOL isDefinite;
	NSInteger state;
	BOOL isStateInclusive;
	NSInteger beginState;
	NSInteger pushState;
	BOOL popsState;
	BOOL beginsScope;
	BOOL endsScope;
	BOOL attachToScope;
	EDLexRule *follows;  // FIXME: Rename -lookbehindRule
	EDLexRule *precedes; // FIXME: Rename -lookaheadRule
	
	BOOL includedInSymbolTree;
}

@property (nonatomic, assign) EDLexer *lexer;
@property (nonatomic) EDLexicalTokenType tokenType;
@property (nonatomic, setter=setDefinite:) BOOL isDefinite;
@property (nonatomic) NSInteger state;
@property (nonatomic) BOOL isStateInclusive;
@property (nonatomic) NSInteger beginState;
@property (nonatomic) NSInteger pushState;
@property (nonatomic) BOOL popsState;
@property (nonatomic) BOOL beginsScope;
@property (nonatomic) BOOL endsScope;
@property (nonatomic) BOOL attachToScope;
@property (nonatomic, retain) EDLexRule *follows;
@property (nonatomic, retain) EDLexRule *precedes;
@property (nonatomic) BOOL includedInSymbolTree;

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range buffer:(EDLexerBuffer *)buffer states:(EDLexerStates *)states;

@end
