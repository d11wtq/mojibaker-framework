//
//  EDPatternLexRule.m
//  EditorSDK
//
//  Created by Chris Corbyn on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDPatternLexRule.h"
#import "EDLexicalToken.h"
#import "RegexKitLite.h"

@implementation EDPatternLexRule

+(id)ruleWithPattern:(NSString *)icuPattern {
	return [[[self alloc] initWithPattern:icuPattern] autorelease];
}

-(id)initWithPattern:(NSString *)icuPattern {	
	if (self = [self init]) {
		pattern = [icuPattern copy];
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range buffer:(EDLexerBuffer *)buffer states:(EDLexerStates *)states {
	NSRange matchedRange = [string rangeOfRegex:pattern inRange:range];
	
	if (matchedRange.location != range.location) {
		return nil;
	} else {
		return [EDLexicalToken tokenWithType:tokenType range:matchedRange value:[string substringWithRange:matchedRange] rule:self];
	}
}

-(void)dealloc {
	[pattern release];
	[super dealloc];
}

@end
