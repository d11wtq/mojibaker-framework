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
#import "EDPatternLexRule.h"


@implementation EDLexer

@synthesize states;

+(id)lexerWithStates:(EDLexerStates *)stateMachine {
	return [[[self alloc] initWithStates:stateMachine] autorelease];
}

-(id)initWithStates:(EDLexerStates *)stateMachine {
	if (self = [self init]) {
		states = [stateMachine retain];
		rules = [[NSMutableArray alloc] init];
		EDLexRule * whiteSpaceRule = [EDCharacterSetLexRule
									  ruleWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
									  tokenType:EDWhitespaceToken];
		lastResortRules = [[NSMutableArray alloc] initWithObjects:whiteSpaceRule,
						   [EDPatternLexRule ruleWithPattern:@"^\\w+" tokenType:EDUnmatchedCharacterToken],
						   [EDAnyCharacterLexRule rule], nil];
	}
	
	return self;
}

-(void)addRule:(EDLexRule *)ruleToAdd {
	[rules addObject:ruleToAdd];
}

-(EDLexerResult *)lexString:(NSString *)string range:(NSRange)range
			 changeInLength:(NSInteger)delta previousResult:(EDLexerResult *)previousResult {
	
	NSUInteger offset = range.location;
	NSUInteger endOffset = range.location + range.length;
	NSMutableArray *tokens = [NSMutableArray array];
	
	NSEnumerator *enumerator = [previousResult.tokens objectEnumerator];
	EDLexicalToken *oldTok = nil;
	while (oldTok = [enumerator nextObject]) {
		// Copy all tokens from previous result before the given range
		if (oldTok.range.location < range.location) {
			[tokens addObject:oldTok];
			continue;
		}
		
		break;
	}
			
	oldTok = nil; // Discard this token
	
	// Lex, moving all the old tokens by the delta and comparing to see if we've got a match
	EDLexicalToken *newTok = nil;
	while (newTok = [self nextTokenInString:string range:NSMakeRange(offset, endOffset - offset)]) {
		if (oldTok
			&& oldTok.range.location == newTok.range.location
			&& oldTok.range.length == newTok.range.length
			&& oldTok.type == newTok.type) {
			
			[tokens addObject:oldTok];
			while (oldTok = [enumerator nextObject]) {
				[oldTok moveBy:delta];
				[tokens addObject:oldTok];
			}
			break;
		}
		
		[tokens addObject:newTok];
		for (EDLexicalToken *child in newTok.sublexedResult.tokens) {
			[tokens addObject:child];
		}
		
		offset += newTok.range.length;
		if (offset >= endOffset) {
			break;
		}
		
		// Shift forward within the old result until we reach the current point
		do {
			if (oldTok = [enumerator nextObject])
				[oldTok moveBy:delta];
		} while (oldTok && oldTok.range.location < newTok.range.location + newTok.range.length);
	}
	
	[states reset];
	
	return [EDLexerResult resultWithTokens:tokens];
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
	
	[states reset];
	
	return [EDLexerResult resultWithTokens:tokens];
}

-(EDLexerResult *)lexString:(NSString *)string {
	return [self lexString:string range:NSMakeRange(0, string.length)];
}

-(EDLexicalToken *)nextTokenInString:(NSString *)string range:(NSRange)range {
	EDLexicalToken *bestToken = nil;
	
	for (EDLexRule * rule in rules) {
		if (rule.exclusiveState > -1 && rule.exclusiveState != states.currentState) {
			continue;
		}
		
		if (rule.inclusiveState > -1 && ![states includesState:rule.inclusiveState]) {
			continue;
		}
		
		EDLexicalToken *tok = nil;
		if (tok = [rule lexInString:string range:range states:states]) {
			if (bestToken == nil || tok.range.length > bestToken.range.length) {
				bestToken = tok;
			}
		}
	}
	
	if (bestToken == nil) {
		for (EDLexRule * rule in lastResortRules) {
			EDLexicalToken *tok = nil;
			if (tok = [rule lexInString:string range:range states:states]) {
				bestToken = tok;
				break;
			}
		}
	}
	
	return bestToken;
}

-(void)dealloc {
	[states release];
	[rules release];
	[lastResortRules release];
	[super dealloc];
}

@end
