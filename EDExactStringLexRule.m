//
//  EDExactStringLexRule.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDExactStringLexRule.h"
#import "EDLexicalToken.h"

@implementation EDExactStringLexRule

+(id)ruleWithString:(NSString *)string tokenType:(NSUInteger)theTokenType {
	return [[[self alloc] initWithString:string tokenType:theTokenType caseInsensitive:NO] autorelease];
}

+(id)ruleWithString:(NSString *)string tokenType:(NSUInteger)theTokenType caseInsensitive:(BOOL)isCaseInsensitive {
	return [[[self alloc] initWithString:string tokenType:theTokenType caseInsensitive:isCaseInsensitive] autorelease];
}

-(id)initWithString:(NSString *)string tokenType:(NSUInteger)theTokenType caseInsensitive:(BOOL)isCaseInsensitive {
	if (self = [self init]) {
		needleString = isCaseInsensitive
			? [[string lowercaseString] copy]
			: [string copy]
			;
		caseInsensitive = isCaseInsensitive;
		tokenType = theTokenType;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range {
	if (range.length < needleString.length) {
		return nil;
	}
	
	EDLexicalToken *tok = nil;
	
	NSRange matchRange = NSMakeRange(range.location, needleString.length);
	NSString *rangeSubstring = [string substringWithRange:matchRange];
	
	if (caseInsensitive) {
		rangeSubstring = [rangeSubstring lowercaseString];
	}
	
	if ([rangeSubstring isEqualToString:needleString]) {
		tok = [EDLexicalToken tokenWithType:tokenType range:matchRange];
	}
	
	return tok;
}

-(void)dealloc {
	[needleString release];
	[super dealloc];
}

@end
