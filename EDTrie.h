//
//  EDTrie.h
//  EditorSDK
//
//  Created by Chris Corbyn on 15/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EDTrie;

@interface EDTrie : NSObject {
	BOOL tip;
	EDTrie * nodes[256];
}

@property (nonatomic, getter=isTip) BOOL tip;

-(void)insertString:(NSString *)string;
-(BOOL)containsString:(NSString *)string;
-(NSArray *)entries;
-(EDTrie *)searchWithPrefix:(NSString *)prefix;
-(NSString *)substringMatchedFromString:(NSString *)string;

@end
