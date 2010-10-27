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

+(id)ruleWithPattern:(NSString *)icuPattern tokenType:(EDLexicalTokenType)theTokenType {
	return [[[self alloc] initWithPattern:icuPattern tokenType:theTokenType] autorelease];
}

-(id)initWithPattern:(NSString *)icuPattern tokenType:(EDLexicalTokenType)theTokenType {
	if (self = [self init]) {
		pattern = [icuPattern copy];
		tokenType = theTokenType;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range {
	NSRange matchedRange = [string rangeOfRegex:pattern inRange:range];
	
	if (matchedRange.location != range.location) {
		return nil;
	} else {
		return [EDLexicalToken tokenWithType:tokenType range:matchedRange];
	}
}

-(void)dealloc {
	[pattern release];
	[super dealloc];
}

@end
