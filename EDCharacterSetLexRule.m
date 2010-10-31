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

+(id)ruleWithCharacterSet:(NSCharacterSet *)characterSet tokenType:(EDLexicalTokenType)theTokenType {
	return [[[self alloc] initWithCharacterSet:characterSet tokenType:theTokenType] autorelease];
}

-(id)initWithCharacterSet:(NSCharacterSet *)characterSet tokenType:(EDLexicalTokenType)theTokenType {
	if (self = [self init]) {
		permittedCharacterSet = [characterSet retain];
		tokenType = theTokenType;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states {
	// Test if the first character is in the set, if not, return early to save potentially expensive search
	if (![permittedCharacterSet characterIsMember:[string characterAtIndex:range.location]]) {
		return nil;
	}
	
	EDLexicalToken *tok = nil;
	
	NSString *matchedString = nil;
	NSScanner *scanner = [NSScanner scannerWithString:[string substringWithRange:range]];
	[scanner setCharactersToBeSkipped:nil];
	if ([scanner scanCharactersFromSet:permittedCharacterSet intoString:&matchedString]) {
		tok = [EDLexicalToken tokenWithType:tokenType range:NSMakeRange(range.location, matchedString.length)];
	}
	
	return tok;
}

-(void)dealloc {
	[permittedCharacterSet release];
	[super dealloc];
}

@end
