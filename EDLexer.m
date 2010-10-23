//
//  EDLexer.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexer.h"
#import "EDLexicalToken.h"
#import "EDAnyCharacterLexRule.h"


@implementation EDLexer

+(id)lexer {
	return [[[self alloc] init] autorelease];
}

-(id)init {
	if (self = [super init]) {
		rules = [[NSMutableArray alloc] init];
		defaultRule = [[EDAnyCharacterLexRule alloc] init];
	}
	
	return self;
}

-(void)addRule:(id<EDLexRule>)ruleToAdd {
	[rules addObject:ruleToAdd];
}

-(NSArray *)tokensInString:(NSString *)string {
	NSUInteger offset = 0;
	NSUInteger stringLength = string.length;
	NSMutableArray *tokens = [NSMutableArray array];
	
	if (stringLength == 0) {
		return tokens;
	}
	
	EDLexicalToken *tok = nil;
	
	while (tok = [self lex:string range:NSMakeRange(offset, stringLength - offset)]) {
		[tokens addObject:tok];
		offset += tok.range.length;
		if (offset >= stringLength) {
			break;
		}
	}
	
	return tokens;
}

-(EDLexicalToken *)lex:(NSString *)string range:(NSRange)range {
	EDLexicalToken *bestToken = nil;
	
	for (id<EDLexRule> rule in rules) {
		EDLexicalToken *tok = nil;
		if (tok = [rule lexInString:string range:range]) {
			if (bestToken == nil || tok.range.length > bestToken.range.length) {
				bestToken = tok;
			}
		}
	}
	
	if (bestToken == nil) {
		bestToken = [defaultRule lexInString:string range:range];
	}
	
	return bestToken;
}

-(void)dealloc {
	[rules release];
	[defaultRule release];
	[super dealloc];
}

@end
