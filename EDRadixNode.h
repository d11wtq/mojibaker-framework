//
//  EDRadixNode.h
//  EditorSDK
//
//  Created by Chris Corbyn on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EDRadixNode;

@interface EDRadixNode : NSObject {
	NSMutableArray *children;
	NSString *value;
	BOOL isWordEnd;
}

@property (nonatomic, copy) NSString *value;
@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic) BOOL isWordEnd;

-(id)initWithString:(NSString *)stringValue;

-(void)addString:(NSString *)stringToAdd;
-(BOOL)containsString:(NSString *)stringToFind;
-(EDRadixNode *)prefixSearch:(NSString *)prefix;
-(NSUInteger)substringLengthMatchedFromString:(NSString *)haystack;

-(NSArray *)entries;

#pragma mark -
#pragma mark Internal methods

-(BOOL)shallowCopyResultsFromChildrenPrefixSearch:(NSString *)prefix intoTree:(EDRadixNode *)tree;

@end
