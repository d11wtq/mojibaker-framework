//
//  EDLexer.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexer.h"
#import "EDLexerStates.h"
#import "EDLexicalToken.h"
#import "EDLexerResult.h"
#import "EDAnyCharacterLexRule.h"
#import "EDCharacterSetLexRule.h"


@implementation EDLexer

+(id)lexer {
	return [[[self alloc] init] autorelease];
}

-(id)init {
	if (self = [super init]) {
		rules = [[NSMutableArray alloc] init];
		defaultRule = [[EDAnyCharacterLexRule alloc] init];
		whiteSpaceRule = [[EDCharacterSetLexRule alloc] initWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] tokenType:EDWhitespaceToken];
		
	}
	
	return self;
}

-(void)addRule:(id<EDLexRule>)ruleToAdd {
	[rules addObject:ruleToAdd];
}

-(EDLexerResult *)lexString:(NSString *)string range:(NSRange)range {
	NSUInteger offset = range.location;
	NSUInteger endOffset = range.location + range.length;
	NSMutableArray *tokens = [NSMutableArray array];
	
	if (range.length != 0) {
		EDLexicalToken *tok = nil;
		
		while (tok = [self nextTokenInString:string range:NSMakeRange(offset, endOffset - offset)]) {
			[tokens addObject:tok];
			for (EDLexicalToken *child in tok.sublexedResult.tokens) {
				[tokens addObject:child];
			}
			offset += tok.range.length;
			if (offset >= endOffset) {
				break;
			}
		}
	}
	
	return [EDLexerResult resultWithTokens:tokens];
}

-(EDLexerResult *)lexString:(NSString *)string {
	return [self lexString:string range:NSMakeRange(0, string.length)];
}

-(EDLexicalToken *)nextTokenInString:(NSString *)string range:(NSRange)range {
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
		if (!(bestToken = [whiteSpaceRule lexInString:string range:range])) {
			bestToken = [defaultRule lexInString:string range:range];
		}
	}
	
	return bestToken;
}

-(void)dealloc {
	[rules release];
	[whiteSpaceRule release];
	[defaultRule release];
	[super dealloc];
}

@end
