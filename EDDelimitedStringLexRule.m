//
//  EDDelimitedStringLexRule.m
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDDelimitedStringLexRule.h"
#import "EDLexicalToken.h"

@implementation EDDelimitedStringLexRule

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString tokenType:(EDLexicalTokenType)theTokenType {
	return [self ruleWithStart:startString end:endString escape:@"\\" tokenType:theTokenType];
}

+(id)ruleWithStart:(NSString *)startString end:(NSString *)endString escape:(NSString *)escapeString
		 tokenType:(EDLexicalTokenType)theTokenType {
	return [[[self alloc] initWithStart:startString end:endString escape:escapeString tokenType:theTokenType] autorelease];
}

-(id)initWithStart:(NSString *)startString end:(NSString *)endString escape:(NSString *)escapeString
		 tokenType:(EDLexicalTokenType)theTokenType {
	if (self = [self init]) {
		start = [startString copy];
		end = [endString copy];
		escape = [escapeString copy];
		tokenType = theTokenType;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states {
	if (range.length < start.length) {
		return nil;
	}
	
	EDLexicalToken *tok = nil;
	
	NSRange matchRange = NSMakeRange(range.location, start.length);
	if ([[string substringWithRange:matchRange] isEqualToString:start]) {
		matchRange.location = range.location + start.length;
		matchRange.length = range.length - start.length;
		
		for (;;) {
			NSString *substringToScan = [string substringWithRange:matchRange];
			
			NSString *matchedString = nil;
			NSScanner *scanner = [NSScanner scannerWithString:substringToScan];
			[scanner setCharactersToBeSkipped:nil];
			
			NSRange endRange = [substringToScan rangeOfString:end];
			
			if (endRange.location == NSNotFound) { // Unterminated sequence, consider token to be entire range
				tok = [EDLexicalToken tokenWithType:tokenType range:range];
				break;
			} else {
				NSRange escapeRange = (escape != nil)
					? [substringToScan rangeOfString:escape]
					: NSMakeRange(NSNotFound, 0)
					;
				
				// Check if there's an escape before the terminating delimiter.
				if (escapeRange.location != NSNotFound && escapeRange.location < endRange.location) {
					if (![scanner scanUpToString:escape intoString:&matchedString]) {
						// FIXME: Raise an Exception
					}
					
					// Swallow everything up to the escape, plus the escape itself, plus the character it escapes, if any
					NSUInteger lengthConsumed = matchedString.length + escape.length + 1;
					matchRange.location += lengthConsumed;
					matchRange.length -= lengthConsumed;
					// Prevent overrun errors if there's no escaped char
					if (matchRange.length < 0) {
						matchRange.length = 0;
						--matchRange.location;
					}
				} else {
					if (![scanner scanUpToString:end intoString:&matchedString]) {
						// FIXME: Raise an Exception
					}
					
					NSUInteger lengthConsumed = matchedString.length + end.length;
					NSUInteger lengthRemaining = matchRange.length - lengthConsumed;
					
					tok = [EDLexicalToken tokenWithType:tokenType
												  range:NSMakeRange(range.location, range.length - lengthRemaining)];
					break;
				}
			}
		}
	}
	
	return tok;
}

-(void)dealloc {
	[start release];
	[end release];
	[escape release];
	[super dealloc];
}

@end
