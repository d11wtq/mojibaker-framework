//
//  EDLexer.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexer.h"
#import "EDLexerStates.h"
#import "EDLexerStatesSnapshot.h"
#import "EDLexicalToken.h"
#import "EDLexerResult.h"
#import "EDLexerBuffer.h"
#import "EDCharacterLexRule.h"
#import "EDCharacterSetLexRule.h"
#import "EDPatternLexRule.h"


@implementation EDLexer

@synthesize states;
@synthesize documentType;

+(id)lexerWithStates:(EDLexerStates *)stateMachine {
	return [[[self alloc] initWithStates:stateMachine] autorelease];
}

-(id)initWithStates:(EDLexerStates *)stateMachine {
	if (self = [self init]) {
		states = [stateMachine retain];
		rules = [[NSMutableArray alloc] init];
		EDLexRule *whiteSpaceRule = [EDCharacterSetLexRule ruleWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		whiteSpaceRule.tokenType = EDWhitespaceToken;
		
		lastResortRules = [[NSMutableArray alloc] initWithObjects:whiteSpaceRule,
						   [EDPatternLexRule ruleWithPattern:@"^[a-zA-Z0-9_]+"],
						   [EDCharacterLexRule rule], nil];
	}
	
	return self;
}

-(void)addRule:(EDLexRule *)ruleToAdd {
	[rules addObject:ruleToAdd];
}

-(void)lexString:(NSString *)string editedRange:(NSRange)editedRange changeInLength:(NSInteger)delta
			previousResult:(EDLexerResult *)previousResult intoResult:(EDLexerResult *)result {
	
	if (string.length == 0) {
		return;
	}
	
	EDLexerBuffer *buffer = [[EDLexerBuffer alloc] initWithLexer:self string:string];
	
	EDLexerStatesSnapshot *snapshot = [[states snapshot] retain];
	
	NSUInteger editedRangeEnd = editedRange.location + editedRange.length;
	
	NSRange nextRange = NSMakeRange(editedRange.location, 0);
	if (nextRange.location > 0) {
		nextRange.location--;
	}
	
	EDLexicalToken *existingToken = [previousResult tokenAtRange:nextRange];
	
	nextRange.location = existingToken.range.location;
	nextRange.length = string.length - nextRange.location;
	
	NSEnumerator *previousResultEnumerator = [previousResult.tokens objectEnumerator];
	
	while (existingToken = [previousResultEnumerator nextObject]) {
		if (existingToken.range.location < nextRange.location) {
			[result addToken:existingToken];
		} else {
			break;
		}
	}
	
	buffer.lookbehind = existingToken;
	
	if (existingToken) {
		snapshot = [existingToken statesSnapshot];
		[states applySnapshot:snapshot];
	}
	
	EDLexicalToken *newToken = nil;
	
	BOOL copyRemaining = NO;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	while (newToken = [self nextTokenInString:string range:nextRange buffer:buffer]) {
		buffer.lookbehind = newToken;
		newToken.statesSnapshot = snapshot;
		
		if (states.isChanged) {
			[snapshot release];
			snapshot = [[states snapshot] retain];
			states.isChanged = NO;
		}
		
		if (existingToken && !NSEqualRanges(existingToken.range, editedRange) && [newToken isEqualToToken:existingToken]) {
			[result addToken:existingToken];
			if (existingToken.range.location >= editedRangeEnd) {
				copyRemaining = YES;
				break;
			}
		} else {
			[result addToken:newToken isNew:YES];
		}
		
		nextRange.location += newToken.range.length;
		nextRange.length -= newToken.range.length;
		
		if (nextRange.length <= 0) {
			break;
		}
		
		[pool release]; pool = [[NSAutoreleasePool alloc] init];
		
		while (existingToken && existingToken.range.location < nextRange.location) {
			existingToken = [previousResultEnumerator nextObject];
			[existingToken moveBy:delta];
		}
	}
	
	[pool release]; pool = nil;
	
	if (copyRemaining) {
		while (existingToken = [previousResultEnumerator nextObject]) {
			[existingToken moveBy:delta];
			if (existingToken.range.location >= string.length) {
				break;
			}
			[result addToken:existingToken];
		}
	}
	
	[snapshot release];
	[buffer release];
	[states reset];
}

-(void)lexString:(NSString *)string intoResult:(EDLexerResult *)result {
	[self lexString:string
		editedRange:NSMakeRange(0, string.length)
	 changeInLength:string.length
	 previousResult:[EDLexerResult result]
		 intoResult:result];
}

-(EDLexicalToken *)nextTokenInString:(NSString *)string range:(NSRange)range buffer:(EDLexerBuffer *)buffer {
	EDLexRule *bestRule = nil;
	EDLexicalToken *bestToken = nil;
	
	for (EDLexRule *rule in rules) {
		if (rule.follows && rule.follows != buffer.lookbehind.rule) {
			continue;
		}
		
		if (rule.state > -1) {
			if (!rule.isStateInclusive && rule.state != states.currentState) {
				continue;
			}
			
			if (rule.isStateInclusive && ![states includesState:rule.state]) {
				continue;
			}
		}
		
		EDLexicalToken *tok = nil;
		if (tok = [rule lexInString:string range:range buffer:buffer states:states]) {
			if (bestToken == nil || tok.range.length > bestToken.range.length) {
				bestToken = tok;
				bestRule = rule;
			}
			
			if (rule.isDefinite) {
				break;
			}
		}
	}
	
	if (bestToken == nil) {
		for (EDLexRule *rule in lastResortRules) {
			EDLexicalToken *tok = nil;
			if (tok = [rule lexInString:string range:range buffer:buffer states:states]) {
				bestToken = tok;
				bestRule = rule;
				break;
			}
		}
	}
	
	if (bestRule.popsState) {
		[states popState];
	}
	
	if (bestRule.pushState > -1) {
		[states pushState:bestRule.pushState];
	}
	
	if (bestRule.beginState > -1) {
		[states beginState:bestRule.beginState];
	}
	
	return bestToken;
}

-(void)dealloc {
	[documentType release];
	[states release];
	[rules release];
	[lastResortRules release];
	[super dealloc];
}

@end
