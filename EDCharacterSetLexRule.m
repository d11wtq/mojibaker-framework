//
//  EDCharacterSetLexRule.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDCharacterSetLexRule.h"
#import "EDLexicalToken.h"

@implementation EDCharacterSetLexRule

+(id)ruleWithCharacterSet:(NSCharacterSet *)characterSet {
	return [[[self alloc] initWithCharacterSet:characterSet] autorelease];
}

-(id)initWithCharacterSet:(NSCharacterSet *)characterSet {
	if (self = [self init]) {
		permittedCharacterSet = [characterSet retain];
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range buffer:(EDLexerBuffer *)buffer states:(EDLexerStates *)states {
	// Test if the first character is in the set, if not, return early to save potentially expensive search
	if (![permittedCharacterSet characterIsMember:[string characterAtIndex:range.location]]) {
		return nil;
	}
	
	EDLexicalToken *tok = nil;
	
	NSString *matchedString = nil;
	NSScanner *scanner = [NSScanner scannerWithString:[string substringWithRange:range]];
	[scanner setCharactersToBeSkipped:nil];
	if ([scanner scanCharactersFromSet:permittedCharacterSet intoString:&matchedString]) {
		tok = [EDLexicalToken tokenWithType:tokenType
									  range:NSMakeRange(range.location, matchedString.length)
									  value:matchedString
									   rule:self];
	}
	
	return tok;
}

-(void)dealloc {
	[permittedCharacterSet release];
	[super dealloc];
}

@end
