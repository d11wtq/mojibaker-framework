//
//  EDLexerResult.h
//  EditorSDK
//
//  Created by Chris Corbyn on 24/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EDLexicalToken;

@interface EDLexerResult : NSObject {
	NSMutableArray *tokens;
}

+(id)result;
+(id)resultWithTokens:(NSArray *)foundTokens;
-(id)initWithTokens:(NSArray *)foundTokens;

@property (readonly) NSArray *tokens;

-(void)addToken:(EDLexicalToken *)token;

-(EDLexicalToken *)tokenAtRange:(NSRange)range;

@end
