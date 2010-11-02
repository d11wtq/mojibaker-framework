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
						   [EDPatternLexRule ruleWithPattern:@"^[a-zA-Z0-9_]+" tokenType:EDUnmatchedCharacterToken],
						   [EDAnyCharacterLexRule rule], nil];
	}
	
	return self;
}

-(void)addRule:(EDLexRule *)ruleToAdd {
	[rules addObject:ruleToAdd];
}

-(EDLexerResult *)lexString:(NSString *)string editedRange:(NSRange)editedRange changeInLength:(NSInteger)delta
			 previousResult:(EDLexerResult *)previousResult {
	NSMutableArray *tokens = [NSMutableArray array];
	if (string.length == 0) {
		return [EDLexerResult resultWithTokens:tokens];
	}
	
	NSUInteger editedRangeEnd = editedRange.location + editedRange.length;
	
	NSRange nextRange = NSMakeRange(editedRange.location, 0);
	if (nextRange.location > 0) {
		nextRange.location--;
	}
	
	EDLexicalToken *existingToken = [previousResult tokenAtRange:nextRange];
	
	EDLexerStatesInfo stackInfo = existingToken.stackInfo;
	
	[states setStack:stackInfo.stack length:stackInfo.stackSize currentState:stackInfo.currentState];
	[states setIsChanged:NO];
	
	nextRange.location = existingToken.range.location;
	nextRange.length = string.length - nextRange.location;
	
	NSEnumerator *previousResultEnumerator = [previousResult.tokens objectEnumerator];
	
	while (existingToken = [previousResultEnumerator nextObject]) {
		if (existingToken.range.location < nextRange.location) {
			[tokens addObject:existingToken];
		} else {
			break;
		}
	}
	
	EDLexicalToken *newToken = nil;
	
	BOOL copyRemaining = NO;
	while (newToken = [self nextTokenInString:string range:nextRange]) {
		if (states.isChanged) {
			stackInfo = states.stackInfo;
			states.isChanged = NO;
		}
		
		newToken.stackInfo = stackInfo;
		
		if (existingToken && !NSEqualRanges(existingToken.range, editedRange) && [newToken isEqualToToken:existingToken]) {
			[tokens addObject:existingToken];
			if (existingToken.range.location >= editedRangeEnd) {
				copyRemaining = YES;
				break;
			}
		} else {
			[tokens addObject:newToken];
		}
		
		nextRange.location += newToken.range.length;
		nextRange.length -= newToken.range.length;
		
		if (nextRange.length <= 0) {
			break;
		}
		
		while (existingToken && existingToken.range.location < nextRange.location) {
			existingToken = [previousResultEnumerator nextObject];
			[existingToken moveBy:delta];
		}
	}
	
	if (copyRemaining) {
		while (existingToken = [previousResultEnumerator nextObject]) {
			[existingToken moveBy:delta];
			if (existingToken.range.location >= string.length) {
				break;
			}
			[tokens addObject:existingToken];
		}
	}
	
	[states reset];
	
	return [EDLexerResult resultWithTokens:tokens];
}

-(EDLexerResult *)lexString:(NSString *)string range:(NSRange)range
			 changeInLength:(NSInteger)delta previousResult:(EDLexerResult *)previousResult {
	NSMutableArray *tokens = [NSMutableArray array];
	
	EDLexicalToken *unchangedTok = nil;
	NSEnumerator *previousResultEnumerator = [previousResult.tokens objectEnumerator];
	while (unchangedTok = [previousResultEnumerator nextObject]) {
		if (unchangedTok.range.location < range.location) {
			[tokens addObject:unchangedTok];
		} else {
			break;
		}
	}
	
	EDLexerStatesInfo stackInfo = states.stackInfo;
	NSRange nextRange = range;
	EDLexicalToken *newTok = nil;
	BOOL canReusePreviousTokens = NO;
	while (!canReusePreviousTokens && (newTok = [self nextTokenInString:string range:nextRange])) {
		NSLog(@"oldTok = (%d,%d); newTok = (%d,%d)",
			  unchangedTok.range.location, unchangedTok.range.length,
			  newTok.range.location, newTok.range.length);
		if (states.isChanged) {
			stackInfo = states.stackInfo;
			states.isChanged = NO;
		}
		
		newTok.stackInfo = stackInfo;
		
		if ([newTok isEqualToToken:unchangedTok]) {
			[tokens addObject:unchangedTok];
		} else {
			[unchangedTok moveBy:delta];
			if ([newTok isEqualToToken:unchangedTok]) {
				[tokens addObject:unchangedTok];
				canReusePreviousTokens = YES;
				break;
			}
			NSLog(@"Collecting newTok!");
			[tokens addObject:newTok];
		}
		
		nextRange.length -= newTok.range.length;
		nextRange.location += newTok.range.length;
		
		if (nextRange.length <= 0) {
			break;
		}
		
		while (unchangedTok && (unchangedTok.range.location + delta) < nextRange.location) {
			unchangedTok = [previousResultEnumerator nextObject];
			NSLog(@"Iterated to oldTok = (%d,%d)", unchangedTok.range.location, unchangedTok.range.length);
		}
	}
	
	if (canReusePreviousTokens) {
		while (unchangedTok = [previousResultEnumerator nextObject]) {
			[unchangedTok moveBy:delta];
			[tokens addObject:unchangedTok];
		}
	}
	
	[states reset];
	
	return [EDLexerResult resultWithTokens:tokens];
}

/*-(EDLexerResult *)lexString:(NSString *)string range:(NSRange)range
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
	EDLexerStatesInfo stackInfo = states.stackInfo;
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
		
		newTok.stackInfo = stackInfo;
		[tokens addObject:newTok];
		NSLog(@"Adding newTok at (%d,%d)", newTok.range.location, newTok.range.length);
		
		if (states.isChanged) {
			stackInfo = states.stackInfo;
			states.isChanged = NO;
		}
		
		offset += newTok.range.length;
		if (offset >= endOffset) {
			break;
		}
		
		// Shift forward within the old result until we reach the current point
		while (oldTok = [enumerator nextObject]) {
			[oldTok moveBy:delta];
			if (oldTok.range.location < (newTok.range.location + newTok.range.length)) {
				continue;
			}
			break;
		}
	}
	
	[states reset];
	
	return [EDLexerResult resultWithTokens:tokens];
}*/

-(EDLexerResult *)lexString:(NSString *)string range:(NSRange)range {
	NSUInteger offset = range.location;
	NSUInteger endOffset = range.location + range.length;
	NSMutableArray *tokens = [NSMutableArray array];
	
	if (range.length != 0) {
		EDLexicalToken *tok = nil;
		
		EDLexerStatesInfo stackInfo = states.stackInfo;
		
		while (tok = [self nextTokenInString:string range:NSMakeRange(offset, endOffset - offset)]) {
			tok.stackInfo = stackInfo;
			[tokens addObject:tok];
			
			if (states.isChanged) {
				stackInfo = states.stackInfo;
				states.isChanged = NO;
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
			if (rule.isDefinite || bestToken == nil || tok.range.length > bestToken.range.length) {
				bestToken = tok;
			}
			
			if (rule.isDefinite) {
				break;
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
