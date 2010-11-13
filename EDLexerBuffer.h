//
//  EDLexerBuffer.h
//  EditorSDK
//
//  Created by Chris Corbyn on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EDLexer;
@class EDLexicalToken;

@interface EDLexerBuffer : NSObject {
	NSString *string;
	EDLexer *lexer;
	
	NSMutableArray *lookaheadStack;
	
	EDLexicalToken *lookbehind;
	EDLexicalToken *token;
	
	EDLexicalToken *lastToken;
}

-(id)initWithLexer:(EDLexer *)aLexer string:(NSString *)sourceString;

@property (nonatomic, retain) EDLexicalToken *lookbehind;
@property (nonatomic, retain) EDLexicalToken *token;

-(EDLexicalToken *)lookahead;
-(NSArray *)lookaheadStack;

@end
