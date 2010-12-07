//
//  EDLexicalToken.h
//  Editor
//
//  Created by Chris Corbyn on 21/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "EDTokenDefines.h"

@class EDLexRule;
@class EDLexerResult;
@class EDLexicalToken;
@class EDLexicalScope;
@class EDLexerStatesSnapshot;

@interface EDLexicalToken : NSObject {
	EDLexRule *rule;
	EDLexicalTokenType type;
	NSRange range;
	NSString *value;
	EDLexicalScope *attachedScope;
	
	EDLexerStatesSnapshot *statesSnapshot;
}

@property (readonly) EDLexRule *rule;
@property (readonly) EDLexicalTokenType type;
@property (nonatomic) NSRange range;
@property (readonly) NSString *value;
@property (nonatomic, retain) EDLexicalScope *attachedScope;
@property (nonatomic, retain) EDLexerStatesSnapshot *statesSnapshot;

+(id)tokenWithType:(EDLexicalTokenType)aType range:(NSRange)aRange value:(NSString *)aValue rule:(EDLexRule *)aRule;
-(id)initWithType:(EDLexicalTokenType)aType range:(NSRange)aRange value:(NSString *)aValue rule:(EDLexRule *)aRule;

-(NSRange)effectiveRange;
-(void)moveBy:(NSInteger)delta;
-(BOOL)isEqualToToken:(EDLexicalToken *)token;

@end
