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
}

@property (nonatomic) BOOL isDefinite;
@property (nonatomic) NSInteger exclusiveState;
@property (nonatomic) NSInteger inclusiveState;

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states;

@end
