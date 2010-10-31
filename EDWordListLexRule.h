//
//  EDWordListLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 25/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexRule.h"
#import "EDTokenDefines.h"

@class EDRadixNode;

@interface EDWordListLexRule : EDLexRule {
	EDRadixNode *radixTree;
	EDLexicalTokenType tokenType;
	BOOL caseInsensitive;
}

+(id)ruleWithList:(NSArray *)wordList tokenType:(EDLexicalTokenType)theTokenType caseInsensitive:(BOOL)isCaseInsensitive;
-(id)initWithList:(NSArray *)wordList tokenType:(EDLexicalTokenType)theTokenType caseInsensitive:(BOOL)isCaseInsensitive;

@end
