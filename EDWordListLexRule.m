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

+(id)ruleWithList:(NSArray *)wordList tokenType:(EDLexicalTokenType)theTokenType caseInsensitive:(BOOL)isCaseInsensitive {
	return [[[self alloc] initWithList:wordList tokenType:theTokenType caseInsensitive:isCaseInsensitive] autorelease];
}

-(id)initWithList:(NSArray *)wordList tokenType:(EDLexicalTokenType)theTokenType caseInsensitive:(BOOL)isCaseInsensitive {
	if (self = [self init]) {
		radixTree = [[EDRadixNode alloc] init];
		for (NSString *string in wordList) {
			[radixTree addString:string];
		}
		tokenType = theTokenType;
		caseInsensitive = isCaseInsensitive;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range {
	NSUInteger matchedLength;
	if (matchedLength = [radixTree substringLengthMatchedFromString:[string substringWithRange:range]]) {
		return [EDLexicalToken tokenWithType:tokenType range:NSMakeRange(range.location, matchedLength)];
	} else {
		return nil;
	}
}

-(void)dealloc {
	[radixTree release];
	[super dealloc];
}

@end
