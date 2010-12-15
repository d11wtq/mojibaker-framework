//
//  EDTrie.m
//  EditorSDK
//
//  Created by Chris Corbyn on 15/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDTrie.h"

@interface EDTrie()

-(void)insertCString:(const char *)str;
-(BOOL)containsCString:(const char *)str;
-(NSArray *)entriesUsingPrefix:(char *)prefix;
-(EDTrie *)searchWithCPrefix:(const char *)prefix offset:(int)idx;
-(int)lengthMatchedFromCString:(const char *)str offset:(int)idx;

@end



@implementation EDTrie

-(id)init {
	if (self = [super init]) {
		tip = NO;
		int i;
		for (i = 0; i < 256; ++i) nodes[i] = nil;
	}
	
	return self;
}

@synthesize tip;

-(void)insertString:(NSString *)string {
	return [self insertCString:[string cStringUsingEncoding:NSNonLossyASCIIStringEncoding]];
}

-(void)insertCString:(const char *)str {
	int len = strlen(str);
	if (len > 0) {
		char c = str[0];
		if (nodes[c] == nil) {
			nodes[c] = [[EDTrie alloc] init];
		}
		
		if (len == 1) {
			[nodes[c] setTip:YES];
		} else {
			[nodes[c] insertCString:str + 1];
		}
	}
}

-(BOOL)containsString:(NSString *)string {
	return [self containsCString:[string cStringUsingEncoding:NSNonLossyASCIIStringEncoding]];
}

-(BOOL)containsCString:(const char *)str {
	int len = strlen(str);
	if (len == 0) {
		return NO;
	}
	
	char c = str[0];
	
	if (nodes[c] != nil) {
		return len == 1 ? [nodes[c] isTip] : [nodes[c] containsCString:str + 1];
	} else {
		return NO;
	}
}

-(NSArray *)entries {
	return [self entriesUsingPrefix:""];
}

-(NSArray *)entriesUsingPrefix:(char *)prefix {
	NSMutableArray *entries = [NSMutableArray array];
	
	if (tip) {
		[entries addObject:[NSString stringWithCString:prefix encoding:NSNonLossyASCIIStringEncoding]];
	}
	
	int i;
	for (i = 0; i < 256; ++i) {
		EDTrie *node = nodes[i];
		if (node != nil) {
			char ch[2] = { i, 0 };
			char *str = strcat(strdup(prefix), ch);
			if ([node isTip]) {
				[entries addObject:[NSString stringWithCString:str encoding:NSNonLossyASCIIStringEncoding]];
			}
			
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			
			for (NSString *suffixedString in [node entriesUsingPrefix:str]) {
				[entries addObject:suffixedString];
			}
			
			[pool drain];
		}
	}
	return entries;
}

-(EDTrie *)searchWithPrefix:(NSString *)prefix {
	return [self searchWithCPrefix:[prefix cStringUsingEncoding:NSNonLossyASCIIStringEncoding] offset:0];
}

-(EDTrie *)searchWithCPrefix:(const char *)prefix offset:(int)idx {
	EDTrie *trie = [[[EDTrie alloc] init] autorelease];
	
	int len = strlen(prefix);
	if (len > idx) {
		char c = prefix[idx];
		EDTrie *node = nodes[c];
		if (node != nil) {
			if (idx == (len - 1)) {
				for (NSString *entry in [node entriesUsingPrefix:(char *)prefix]) {
					[trie insertString:entry];
				}
			} else {
				return [node searchWithCPrefix:prefix offset:++idx];
			}
		}
	}
	
	return trie;
}

-(NSString *)substringMatchedFromString:(NSString *)string {
	const char *str = [string cStringUsingEncoding:NSNonLossyASCIIStringEncoding];
	int len = [self lengthMatchedFromCString:str offset:0];
	char matched[len];
	
	return len == 0 ? nil : [NSString stringWithCString:strncpy(matched, str, len) encoding:NSNonLossyASCIIStringEncoding];
}

-(int)lengthMatchedFromCString:(const char *)str offset:(int)idx {
	int len = strlen(str);
	if (idx < len) {
		char c = str[idx];
		EDTrie *node = nodes[c];
		if (node != nil) {
			int mylen = idx + 1;
			int nodelen = [node lengthMatchedFromCString:str offset:mylen];
			return ([node isTip] && mylen > nodelen) ? mylen : nodelen;
		}
	}
	
	return 0;
}

-(void)dealloc {
	int i;
	for (i = 0; i < 256; ++i) [nodes[i] release];
	[super dealloc];
}

@end
