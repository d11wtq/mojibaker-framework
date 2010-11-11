//
//  EDCharacterLexRule.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDCharacterLexRule.h"
#import "EDLexicalToken.h"

@implementation EDCharacterLexRule

+(id)rule {
	return [[[self alloc] init] autorelease];
}

+(id)ruleWithUnicodeChar:(unichar)aChar {
	return [[[self alloc] initWithUnicodeChar:aChar] autorelease];
}

-(id)init {
	if (self = [super init]) {
		ch = 0;
	}
	
	return self;
}

-(id)initWithUnicodeChar:(unichar)aChar {
	if (self = [self init]) {
		ch = aChar;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states {
	NSRange singleCharRange = NSMakeRange(range.location, 1);
	NSString *value = [string substringWithRange:singleCharRange];
	if (ch == 0) {
		return [EDLexicalToken tokenWithType:tokenType range:singleCharRange value:value rule:self];
	} else {
		unichar firstChar = [string characterAtIndex:range.location];
		if (ch == firstChar) {
			return [EDLexicalToken tokenWithType:tokenType range:singleCharRange value:value rule:self];
		} else {
			return nil;
		}
	}
}

@end
