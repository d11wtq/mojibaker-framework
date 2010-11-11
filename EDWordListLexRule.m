//
//  EDWordListLexRule.m
//  EditorSDK
//
//  Created by Chris Corbyn on 25/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDWordListLexRule.h"
#import	"EDLexicalToken.h"
#import "EDRadixNode.h"

@implementation EDWordListLexRule

+(id)ruleWithList:(NSArray *)wordList caseInsensitive:(BOOL)isCaseInsensitive {
	return [[[self alloc] initWithList:wordList caseInsensitive:isCaseInsensitive] autorelease];
}

-(id)initWithList:(NSArray *)wordList caseInsensitive:(BOOL)isCaseInsensitive {
	if (self = [self init]) {
		radixTree = [[EDRadixNode alloc] init];
		for (NSString *string in wordList) {
			[radixTree addString:string];
		}
		caseInsensitive = isCaseInsensitive;
		isDefinite = NO;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range states:(EDLexerStates *)states {
	NSUInteger matchedLength;
	if (matchedLength = [radixTree substringLengthMatchedFromString:[string substringWithRange:range]]) {
		NSRange matchedRange = NSMakeRange(range.location, matchedLength);
		return [EDLexicalToken tokenWithType:tokenType
									   range:matchedRange
									   value:[string substringWithRange:matchedRange]
										rule:self];
	} else {
		return nil;
	}
}

-(void)dealloc {
	[radixTree release];
	[super dealloc];
}

@end
