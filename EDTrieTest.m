//
//  EDTrieTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 15/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "EDTrie.h"

@interface EDTrieTest : GHTestCase
@end


@implementation EDTrieTest

-(void)testTrieReportsWhatItContains {
	EDTrie *trie = [[EDTrie alloc] init];
	[trie insertString:@"inform"];
	[trie insertString:@"information"];
	[trie insertString:@"informative"];
	[trie insertString:@"instance"];
	[trie insertString:@"inspect"];
	
	GHAssertTrue([trie containsString:@"information"], @"Trie should contain 'information'");
	GHAssertTrue([trie containsString:@"inspect"], @"Trie should contain 'inspect'");
	GHAssertTrue([trie containsString:@"inform"], @"Trie should contain 'inform'");
	GHAssertFalse([trie containsString:@"informati"], @"Trie should not contain 'informati'");
	
	[trie release];
}

-(void)testTrieCanBeAskedForItsEntriesBack {
	EDTrie *trie = [[EDTrie alloc] init];
	[trie insertString:@"inform"];
	[trie insertString:@"information"];
	[trie insertString:@"informative"];
	[trie insertString:@"instance"];
	[trie insertString:@"inspect"];
	
	NSArray *entries = [trie entries];
	
	GHAssertTrue([entries containsObject:@"inform"], @"Tree should contain 'inform'");
	GHAssertTrue([entries containsObject:@"information"], @"Tree should contain 'information'");
	GHAssertTrue([entries containsObject:@"informative"], @"Tree should contain 'informative'");
	GHAssertTrue([entries containsObject:@"instance"], @"Tree should contain 'instance'");
	GHAssertTrue([entries containsObject:@"inspect"], @"Tree should contain 'inspect'");
	
	[trie release];
}

-(void)testTrieCanSearchForEntriesWithPrefix1 {
	EDTrie *trie = [[EDTrie alloc] init];
	[trie insertString:@"inform"];
	[trie insertString:@"information"];
	[trie insertString:@"informative"];
	[trie insertString:@"instance"];
	[trie insertString:@"inspect"];
	
	NSArray *results = [[trie searchWithPrefix:@"inf"] entries];
	
	GHAssertTrue([results containsObject:@"inform"], @"Results should contain 'inform'");
	GHAssertTrue([results containsObject:@"information"], @"Results should contain 'information'");
	GHAssertTrue([results containsObject:@"informative"], @"Results should contain 'informative'");
	GHAssertFalse([results containsObject:@"instance"], @"Results should not contain 'instance'");
	GHAssertFalse([results containsObject:@"inspect"], @"Results should not contain 'inspect'");
	
	[trie release];
}

-(void)testTrieCanSearchForEntriesWithPrefix2 {
	EDTrie *trie = [[EDTrie alloc] init];
	[trie insertString:@"inform"];
	[trie insertString:@"information"];
	[trie insertString:@"informative"];
	[trie insertString:@"instance"];
	[trie insertString:@"inspect"];
	
	NSArray *results = [[trie searchWithPrefix:@"inform"] entries];
	
	GHAssertTrue([results containsObject:@"inform"], @"Results should contain 'inform'");
	GHAssertTrue([results containsObject:@"information"], @"Results should contain 'information'");
	GHAssertTrue([results containsObject:@"informative"], @"Results should contain 'informative'");
	GHAssertFalse([results containsObject:@"instance"], @"Results should not contain 'instance'");
	GHAssertFalse([results containsObject:@"inspect"], @"Results should not contain 'inspect'");
	
	[trie release];
}

-(void)testTrieCanSearchForEntriesWithPrefix3 {
	EDTrie *trie = [[EDTrie alloc] init];
	[trie insertString:@"inform"];
	[trie insertString:@"information"];
	[trie insertString:@"informative"];
	[trie insertString:@"infedelity"];
	[trie insertString:@"instance"];
	[trie insertString:@"inspect"];
	
	NSArray *results = [[trie searchWithPrefix:@"inf"] entries];
	
	GHAssertTrue([results containsObject:@"inform"], @"Results should contain 'inform'");
	GHAssertTrue([results containsObject:@"information"], @"Results should contain 'information'");
	GHAssertTrue([results containsObject:@"informative"], @"Results should contain 'informative'");
	GHAssertTrue([results containsObject:@"infedelity"], @"Results should contain 'infedelity'");
	GHAssertFalse([results containsObject:@"instance"], @"Results should not contain 'instance'");
	GHAssertFalse([results containsObject:@"inspect"], @"Results should not contain 'inspect'");
	
	[trie release];
}

-(void)testTreeCanSearchForEntriesWithPrefix4 {
	EDTrie *trie = [[EDTrie alloc] init];
	[trie insertString:@"inform"];
	[trie insertString:@"information"];
	[trie insertString:@"informative"];
	[trie insertString:@"infedelity"];
	[trie insertString:@"instance"];
	[trie insertString:@"inspect"];
	
	NSArray *results = [[trie searchWithPrefix:@"ins"] entries];
	
	GHAssertFalse([results containsObject:@"inform"], @"Results should not contain 'inform'");
	GHAssertFalse([results containsObject:@"information"], @"Results should not contain 'information'");
	GHAssertFalse([results containsObject:@"informative"], @"Results should not contain 'informative'");
	GHAssertFalse([results containsObject:@"infedelity"], @"Results should not contain 'infedelity'");
	GHAssertTrue([results containsObject:@"instance"], @"Results should contain 'instance'");
	GHAssertTrue([results containsObject:@"inspect"], @"Results should contain 'inspect'");
	
	[trie release];
}

-(void)testMatchedPortionOfStringCanBeReturned {
	EDTrie *trie = [[EDTrie alloc] init];
	[trie insertString:@"inform"];
	[trie insertString:@"information"];
	[trie insertString:@"informative"];
	[trie insertString:@"infedelity"];
	[trie insertString:@"instance"];
	[trie insertString:@"inspect"];
	
	GHAssertEqualStrings(@"inform", [trie substringMatchedFromString:@"informs"], @"Matched string should be 'inform'");
	GHAssertNil([trie substringMatchedFromString:@"in"], @"No string should be matched");
	GHAssertEqualStrings(@"inspect", [trie substringMatchedFromString:@"inspector"], @"Matched string should be 'inspect'");
	
	[trie release];
}

@end
