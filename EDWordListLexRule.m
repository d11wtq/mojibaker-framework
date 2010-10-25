//
//  EDWordListLexRule.m
//  EditorSDK
//
//  Created by Chris Corbyn on 25/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDWordListLexRule.h"
#import	"EDLexicalToken.h"

@implementation EDWordListLexRule

+(id)ruleWithList:(NSArray *)wordList tokenType:(NSUInteger)theTokenType caseInsensitive:(BOOL)isCaseInsensitive {
	return [[[self alloc] initWithList:wordList tokenType:theTokenType caseInsensitive:isCaseInsensitive] autorelease];
}

-(id)initWithList:(NSArray *)wordList tokenType:(NSUInteger)theTokenType caseInsensitive:(BOOL)isCaseInsensitive {
	if (self = [self init]) {
		list = [[wordList sortedArrayUsingSelector:@selector(compare:)] retain];
		tokenType = theTokenType;
		caseInsensitive = isCaseInsensitive;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range {
	__block NSString *bestMatch = nil;
	
	NSUInteger charIdx = 0;
	NSUInteger strLen = range.length;
	
	NSUInteger lowerBound = 0;
	NSUInteger upperBound = list.count - 1;
	
	for (; charIdx < strLen; ++charIdx) {
		unichar sourceChar = [string characterAtIndex:range.location + charIdx];
		
		NSComparator nthCharComparator = ^(id obj, id ignored) {
			if (charIdx >= [obj length]) {
				return (NSComparisonResult)NSOrderedAscending;
			} else {
				unichar testChar = [obj characterAtIndex:charIdx];
				if (testChar > sourceChar) {
					return (NSComparisonResult)NSOrderedDescending;
				} else if (testChar < sourceChar) {
					return (NSComparisonResult)NSOrderedAscending;
				} else {
					NSUInteger len = [obj length];
					if (len == charIdx + 1) {
						if (!bestMatch || bestMatch.length < len) {
							bestMatch = obj;
						}
					}
					return (NSComparisonResult)NSOrderedSame;
				}
			}
		};
		
		@try {
			lowerBound = [list indexOfObject:string
										  inSortedRange:NSMakeRange(lowerBound, upperBound - lowerBound + 1)
												options:NSBinarySearchingFirstEqual
										usingComparator:nthCharComparator];
			if (lowerBound >= 0) {
				upperBound = [list indexOfObject:string
								   inSortedRange:NSMakeRange(lowerBound, upperBound - lowerBound + 1)
										 options:NSBinarySearchingLastEqual
								 usingComparator:nthCharComparator];
			}
		}
		@catch (NSException *ex) {
			break;
		}
	}
	
	if (bestMatch != nil) {
		return [EDLexicalToken tokenWithType:tokenType range:NSMakeRange(range.location, bestMatch.length)];
	} else {
		return nil;
	}
}

-(void)dealloc {
	[list release];
	[super dealloc];
}

@end
