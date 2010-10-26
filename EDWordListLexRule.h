//
//  EDWordListLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 25/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"

@class EDRadixNode;

@interface EDWordListLexRule : NSObject <EDLexRule> {
	EDRadixNode *radixTree;
	NSUInteger tokenType;
	BOOL caseInsensitive;
}

+(id)ruleWithList:(NSArray *)wordList tokenType:(NSUInteger)theTokenType caseInsensitive:(BOOL)isCaseInsensitive;
-(id)initWithList:(NSArray *)wordList tokenType:(NSUInteger)theTokenType caseInsensitive:(BOOL)isCaseInsensitive;

@end
