//
//  EDLexicalToken.m
//  Editor
//
//  Created by Chris Corbyn on 21/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexicalToken.h"
#import "EDLexRule.h"
#import "EDLexerResult.h"
#import "EDLexerStatesSnapshot.h"

@implementation EDLexicalToken

@synthesize rule;
@synthesize type;
@synthesize range;
@synthesize value;
@synthesize statesSnapshot;

+(id)tokenWithType:(EDLexicalTokenType)aType range:(NSRange)aRange value:(NSString *)aValue rule:(EDLexRule *)aRule {
	return [[[self alloc] initWithType:aType range:aRange value:aValue rule:aRule] autorelease];
}

-(id)initWithType:(EDLexicalTokenType)aType range:(NSRange)aRange value:(NSString *)aValue rule:(EDLexRule *)aRule {
	if (self = [self init]) {
		type = aType;
		range = aRange;
		value = [aValue copy];
		rule = [aRule retain];
	}
	
	return self;
}

-(void)moveBy:(NSInteger)delta {
	range.location += delta;
}

-(BOOL)isEqualToToken:(EDLexicalToken *)token {
	return token
		&& (range.location == token.range.location
			&& range.length == token.range.length
			&& type == token.type
			&& rule == token.rule
			&& [statesSnapshot isEqualToSnapshot:token.statesSnapshot]);
}

-(void)dealloc {
	[rule release];
	[value release];
	[super dealloc];
}

@end
