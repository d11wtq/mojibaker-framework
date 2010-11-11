//
//  EDLexerResult.m
//  EditorSDK
//
//  Created by Chris Corbyn on 24/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexerResult.h"
#import "EDLexicalToken.h"
#import "EDLexRule.h"
#import "EDLexicalScope.h"
#import "NSMutableRangeValue.h"

@implementation EDLexerResult

@synthesize tokens;
@synthesize newTokens;
@synthesize scopes;

+(id)result {
	return [[[self alloc] init] autorelease];
}

+(id)resultWithTokens:(NSArray *)foundTokens {
	return [[[self alloc] initWithTokens:foundTokens] autorelease];
}

-(id)init {
	if (self = [super init]) {
		tokens = [[NSMutableArray alloc] init];
		newTokens = [[NSMutableArray alloc] init];
		scopes = [[NSMutableArray alloc] initWithCapacity:128];
		scopesStack = [[NSMutableArray alloc] initWithCapacity:20];
	}
	
	return self;
}

-(id)initWithTokens:(NSArray *)foundTokens {
	if (self = [self init]) {
		for (EDLexicalToken *tok in foundTokens) {
			[self addToken:tok];
		}
	}
	
	return self;
}

-(void)addToken:(EDLexicalToken *)token {
	[tokens addObject:token];
	
	if (token.rule.beginsScope) {
		NSValue *rangeValue = [NSMutableRangeValue valueWithRange:NSMakeRange(token.range.location, 0)];
		[scopesStack addObject:rangeValue];
		[scopes addObject:[EDLexicalScope scopeWithRangeValue:rangeValue]];
	}
	
	if (token.rule.endsScope) {
		if ([scopesStack count] > 0) {
			NSMutableRangeValue *value = [scopesStack lastObject];
			[scopesStack removeLastObject];
			
			NSRange actualRange = [value rangeValue];
			actualRange.length = NSMaxRange(token.range) - actualRange.location;
			[value setRangeValue:actualRange];
		}
	}
}

-(void)addToken:(EDLexicalToken *)token isNew:(BOOL)newFlag {
	[self addToken:token];
	if (newFlag) {
		[newTokens addObject:token];
	}
}

-(EDLexicalToken *)tokenAtRange:(NSRange)range {
	if (!tokens || tokens.count == 0) {
		return nil;
	}
	
	// Binary search for last token that ends before given range
	NSUInteger minIndex = 0;
	NSUInteger maxIndex = tokens.count - 1;
	NSUInteger lastTestedIndex = -1;
	NSUInteger startOffset = 0;
	
	for (;;) {
		NSUInteger testIndex = (NSUInteger) (minIndex + ((maxIndex - minIndex) / 2));
		if (testIndex == lastTestedIndex || testIndex == lastTestedIndex - 1) {
			// If we're comparing the same value, or we've moved backward by a single element
			startOffset = testIndex;
			break;
		}
		
		EDLexicalToken *tok = [tokens objectAtIndex:testIndex];
		NSUInteger tokEnd = tok.range.location + tok.range.length;
		if (tokEnd < range.location) {
			minIndex = testIndex;
		} else {
			maxIndex = testIndex;
		}
		
		lastTestedIndex = testIndex;
	}
	
	if (startOffset > 0) {
		startOffset--; // Rounding errors can mean it sticks one away from the correct position
	}
	
	EDLexicalToken *closestToken = nil;
	NSInteger closestLocationDelta = 0;
	NSInteger closestOverlapDelta = 0;
	
	NSUInteger i, len;
	for (i = startOffset, len = tokens.count; i < len; ++i) {
		EDLexicalToken *tok = [tokens objectAtIndex:i];
		if (tok.range.location > range.location + range.length) {
			// Token starts beyond the reach of given range
			break;
		}
		
		NSInteger locationDelta = range.location - tok.range.location;
		if (locationDelta >= 0) {
			NSInteger overlapDelta = tok.range.length - locationDelta - range.length;
			if (overlapDelta >= 0) {
				if (closestToken == nil || locationDelta < closestLocationDelta || overlapDelta < closestOverlapDelta) {
					closestToken = tok;
					closestLocationDelta = locationDelta;
					closestOverlapDelta = overlapDelta;
				}
			}
		}
	}
	
	return closestToken;
}

-(void)dealloc {
	[tokens release];
	[newTokens release];
	[scopes release];
	[scopesStack release];
	[super dealloc];
}

@end
