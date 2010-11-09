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

@interface EDWordListLexRule : EDLexRule {
	EDRadixNode *radixTree;
	BOOL caseInsensitive;
}

+(id)ruleWithList:(NSArray *)wordList caseInsensitive:(BOOL)isCaseInsensitive;
-(id)initWithList:(NSArray *)wordList caseInsensitive:(BOOL)isCaseInsensitive;

@end
