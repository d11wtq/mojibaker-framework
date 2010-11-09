//
//  EDLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EDLexicalToken;
@class EDLexerStates;

@interface EDLexRule : NSObject {
	BOOL isDefinite;
	NSInteger exclusiveState;
	NSInteger inclusiveState;
	NSInteger beginState;
	NSInteger pushState;
	BOOL popsState;
	BOOL beginsScope;
	BOOL endsScope;
}

@property (nonatomic, setter=setDefinite:) BOOL isDefinite;
@property (nonatomic) NSInteger exclusiveState;
@property (nonatomic) NSInteger inclusiveState;
@property (nonatomic) NSInteger beginState;
@property (nonatomic) NSInteger pushState;
@property (nonatomic) BOOL popsState;
@property (nonatomic) BOOL beginsScope;
@property (nonatomic) BOOL endsScope;

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states;

@end
