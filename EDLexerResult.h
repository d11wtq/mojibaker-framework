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
	NSMutableArray *newTokens;
	NSArray *scopes;
}

+(id)result;
+(id)resultWithTokens:(NSArray *)foundTokens;
-(id)initWithTokens:(NSArray *)foundTokens;

@property (readonly) NSArray *tokens;
@property (readonly) NSArray *newTokens;
@property (nonatomic, retain) NSArray *scopes;

-(void)addToken:(EDLexicalToken *)token;
-(void)addToken:(EDLexicalToken *)token isNew:(BOOL)newFlag;

-(EDLexicalToken *)tokenAtRange:(NSRange)range;

@end
