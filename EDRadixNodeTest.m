//
//  EDRadixNodeTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "EDRadixNode.h"

@interface EDRadixNodeTest : GHTestCase
@end


@implementation EDRadixNodeTest

-(void)testTreeReportsWhatItContains {
	EDRadixNode *tree = [[EDRadixNode alloc] init];
	[tree addString:@"inform"];
	[tree addString:@"information"];
	[tree addString:@"informative"];
	[tree addString:@"instance"];
	[tree addString:@"inspect"];
	
	GHAssertTrue([tree containsString:@"information"], @"Tree should contain 'information'");
	GHAssertTrue([tree containsString:@"inspect"], @"Tree should contain 'inspect'");
	GHAssertTrue([tree containsString:@"inform"], @"Tree should contain 'inform'");
	GHAssertFalse([tree containsString:@"informati"], @"Tree should not contain 'informati'");
	
	[tree release];
}

-(void)testTreeCanBeAskedForItsEntriesBack {
	EDRadixNode *tree = [[EDRadixNode alloc] init];
	[tree addString:@"inform"];
	[tree addString:@"information"];
	[tree addString:@"informative"];
	[tree addString:@"instance"];
	[tree addString:@"inspect"];
	
	NSArray *entries = tree.entries;
	
	GHAssertTrue([entries containsObject:@"inform"], @"Tree should contain 'inform'");
	GHAssertTrue([entries containsObject:@"information"], @"Tree should contain 'information'");
	GHAssertTrue([entries containsObject:@"informative"], @"Tree should contain 'informative'");
	GHAssertTrue([entries containsObject:@"instance"], @"Tree should contain 'instance'");
	GHAssertTrue([entries containsObject:@"inspect"], @"Tree should contain 'inspect'");
	
	[tree release];
}

-(void)testTreeCanSearchForEntriesWithPrefix1 {
	EDRadixNode *tree = [[EDRadixNode alloc] init];
	[tree addString:@"inform"];
	[tree addString:@"information"];
	[tree addString:@"informative"];
	[tree addString:@"instance"];
	[tree addString:@"inspect"];
	
	NSArray *results = [tree prefixSearch:@"inf"].entries;
	
	GHAssertTrue([results containsObject:@"inform"], @"Results should contain 'inform'");
	GHAssertTrue([results containsObject:@"information"], @"Results should contain 'information'");
	GHAssertTrue([results containsObject:@"informative"], @"Results should contain 'informative'");
	GHAssertFalse([results containsObject:@"instance"], @"Results should not contain 'instance'");
	GHAssertFalse([results containsObject:@"inspect"], @"Results should not contain 'inspect'");
	
	[tree release];
}

-(void)testTreeCanSearchForEntriesWithPrefix2 {
	EDRadixNode *tree = [[EDRadixNode alloc] init];
	[tree addString:@"inform"];
	[tree addString:@"information"];
	[tree addString:@"informative"];
	[tree addString:@"instance"];
	[tree addString:@"inspect"];
	
	NSArray *results = [tree prefixSearch:@"inform"].entries;
	
	GHAssertTrue([results containsObject:@"inform"], @"Results should contain 'inform'");
	GHAssertTrue([results containsObject:@"information"], @"Results should contain 'information'");
	GHAssertTrue([results containsObject:@"informative"], @"Results should contain 'informative'");
	GHAssertFalse([results containsObject:@"instance"], @"Results should not contain 'instance'");
	GHAssertFalse([results containsObject:@"inspect"], @"Results should not contain 'inspect'");
	
	[tree release];
}

-(void)testTreeCanSearchForEntriesWithPrefix3 {
	EDRadixNode *tree = [[EDRadixNode alloc] init];
	[tree addString:@"inform"];
	[tree addString:@"information"];
	[tree addString:@"informative"];
	[tree addString:@"infedelity"];
	[tree addString:@"instance"];
	[tree addString:@"inspect"];
	
	NSArray *results = [tree prefixSearch:@"inf"].entries;
	
	GHAssertTrue([results containsObject:@"inform"], @"Results should contain 'inform'");
	GHAssertTrue([results containsObject:@"information"], @"Results should contain 'information'");
	GHAssertTrue([results containsObject:@"informative"], @"Results should contain 'informative'");
	GHAssertTrue([results containsObject:@"infedelity"], @"Results should contain 'infedelity'");
	GHAssertFalse([results containsObject:@"instance"], @"Results should not contain 'instance'");
	GHAssertFalse([results containsObject:@"inspect"], @"Results should not contain 'inspect'");
	
	[tree release];
}

-(void)testTreeCanSearchForEntriesWithPrefix4 {
	EDRadixNode *tree = [[EDRadixNode alloc] init];
	[tree addString:@"inform"];
	[tree addString:@"information"];
	[tree addString:@"informative"];
	[tree addString:@"infedelity"];
	[tree addString:@"instance"];
	[tree addString:@"inspect"];
	
	NSArray *results = [tree prefixSearch:@"ins"].entries;
	
	GHAssertFalse([results containsObject:@"inform"], @"Results should not contain 'inform'");
	GHAssertFalse([results containsObject:@"information"], @"Results should not contain 'information'");
	GHAssertFalse([results containsObject:@"informative"], @"Results should not contain 'informative'");
	GHAssertFalse([results containsObject:@"infedelity"], @"Results should not contain 'infedelity'");
	GHAssertTrue([results containsObject:@"instance"], @"Results should contain 'instance'");
	GHAssertTrue([results containsObject:@"inspect"], @"Results should contain 'inspect'");
	
	[tree release];
}

@end
