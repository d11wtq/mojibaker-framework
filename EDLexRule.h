//
//  EDLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDTokenDefines.h"

@class EDLexicalToken;
@class EDLexerStates;

@interface EDLexRule : NSObject {
	EDLexicalTokenType tokenType;
	BOOL isDefinite;
	NSInteger state;
	BOOL isStateInclusive;
	NSInteger beginState;
	NSInteger pushState;
	BOOL popsState;
	BOOL beginsScope;
	BOOL endsScope;
}

@property (nonatomic) EDLexicalTokenType tokenType;
@property (nonatomic, setter=setDefinite:) BOOL isDefinite;
@property (nonatomic) NSInteger state;
@property (nonatomic) BOOL isStateInclusive;
@property (nonatomic) NSInteger beginState;
@property (nonatomic) NSInteger pushState;
@property (nonatomic) BOOL popsState;
@property (nonatomic) BOOL beginsScope;
@property (nonatomic) BOOL endsScope;

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states;

@end
