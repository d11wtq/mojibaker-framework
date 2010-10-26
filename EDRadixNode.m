//
//  EDRadixNode.m
//  EditorSDK
//
//  Created by Chris Corbyn on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDRadixNode.h"


@implementation EDRadixNode

@synthesize value;
@synthesize children;
@synthesize isWordEnd;

-(id)init {
	if (self = [super init]) {
		children = [[NSMutableArray alloc] init];
		isWordEnd = NO;
		value = @"";
	}
	
	return self;
}

-(id)initWithString:(NSString *)stringValue {
	if (self = [self init]) {
		value = [stringValue copy];
		isWordEnd = YES;
	}
	
	return self;
}

// FIXME: See if this can be optimized for insertion speed.
-(void)addString:(NSString *)stringToAdd {
	for (EDRadixNode *n in children) {
		if ([stringToAdd isEqualToString:n.value]) { // Already have this
			/*
			 Ensure existing node is flagged as a word-end.
			 */
			n.isWordEnd = YES;
			
			return;
		}
		else if ([n.value hasPrefix:stringToAdd]) { // e.g. Node = inspect; Value = in
			/*
			 1. Find the part that comes after the value.
			 2. Create a new node with the leftover portion.
			 3. Copy the old node's children and word-end status.
			 4. Replace the old node's value with the new value.
			 5. Replace the old node's word-end status with YES.
			 6. Replace the old node's children with the new node.
			 */
			NSString *notCommonPortion = [n.value substringFromIndex:stringToAdd.length];
			EDRadixNode *newNode = [[EDRadixNode alloc] initWithString:notCommonPortion];
			newNode.children = n.children;
			newNode.isWordEnd = n.isWordEnd;
			
			n.value = stringToAdd;
			n.isWordEnd = YES;
			n.children = [NSMutableArray arrayWithObject:newNode];
			[newNode release];
			
			return;
		} else if ([stringToAdd hasPrefix:n.value]) { // e.g. Node = in; Value = inspect
			/*
			 Get the node to store the extra portion.
			 */
			[n addString:[stringToAdd substringFromIndex:n.value.length]];
			
			return;
		} else if (n.value.length > stringToAdd.length) {
			// Test to see if node and new value share a common prefix
			// e.g. Node = information; Value = informative (Prefix = informati)
			NSUInteger idx = 0;
			NSUInteger len = stringToAdd.length;
			for (; idx < len; ++idx) {
				if ([stringToAdd characterAtIndex:idx] != [n.value characterAtIndex:idx]) {
					break;
				}
			}
			if (idx > 0) {
				/*
				 1. Get the common prefix.
				 2. Create the new node for the leftover portion of the current node.
				 3. Copy the current node's children to the new node.
				 4. Copy the current node's word-end status to the new node.
				 5. Create a new node for the leftover portion of the string we're adding.
				 6. Set the old node's value to the common prefix.
				 7. Set the old node's word-end status to NO.
				 8. Replace the node's children with our two new nodes
				 */
				NSString *prefix = [stringToAdd substringToIndex:idx];
				
				EDRadixNode *newNodeA = [[EDRadixNode alloc] initWithString:[n.value substringFromIndex:idx]];
				newNodeA.children = n.children;
				newNodeA.isWordEnd = n.isWordEnd;
				
				EDRadixNode *newNodeB = [[EDRadixNode alloc] initWithString:[stringToAdd substringFromIndex:idx]];
				
				n.value = prefix;
				n.isWordEnd = NO;
				n.children = [NSMutableArray arrayWithObjects:newNodeA, newNodeB, nil];
				
				[newNodeA release];
				[newNodeB release];
				
				return;
			}
		}
	}
	
	EDRadixNode *newNode = [[EDRadixNode alloc] initWithString:stringToAdd];
	[children addObject:newNode];
	[newNode release];
}

-(BOOL)containsString:(NSString *)stringToFind {
	for (EDRadixNode *n in children) {
		if ([stringToFind isEqualToString:n.value]) {
			return YES;
		} else if ([stringToFind hasPrefix:n.value]) {
			return [n containsString:[stringToFind substringFromIndex:n.value.length]];
		}
	}
	
	return NO;
}

-(NSArray *)entries {
	NSMutableArray *entries = [NSMutableArray array];
	if (isWordEnd) {
		[entries addObject:value];
	}
	for (EDRadixNode *n in children) {
		for (NSString *substring in n.entries) {
			[entries addObject:[value stringByAppendingString:substring]];
		}
	}
	return entries;
}

-(EDRadixNode *)prefixSearch:(NSString *)prefix {
	BOOL success = NO;
	EDRadixNode *resultTree = [[[EDRadixNode alloc] init] autorelease];
	
	if ([value hasPrefix:prefix]) {
		/*
		 End of search string reached.
		 */
		success = YES;
		[resultTree.children addObject:self];
	} else if ([prefix hasPrefix:value]) {
		/*
		 This node could lead to a match, ask children to continue search on remainder.
		 */
		NSString *notCommonPortion = [prefix substringFromIndex:value.length];
		
		EDRadixNode *subTree = [[[EDRadixNode alloc] initWithString:value] autorelease];
		subTree.isWordEnd = isWordEnd;
		
		if ([self shallowCopyResultsFromChildrenPrefixSearch:notCommonPortion intoTree:subTree]) {
			[resultTree.children addObject:subTree];
			success = YES;
		}
	} else if (value.length == 0) {
		/*
		 Root node can only consult its children.
		 */
		if ([self shallowCopyResultsFromChildrenPrefixSearch:prefix intoTree:resultTree]) {
			success = YES;
		}
	}
	
	return success ? resultTree : nil;
}

-(BOOL)shallowCopyResultsFromChildrenPrefixSearch:(NSString *)prefix intoTree:(EDRadixNode *)tree {
	/*
	 If any children contain a match, shallow copy the result's children (i.e. avoid the root node) into the tree.
	 */
	BOOL copied = NO;
	for (EDRadixNode *n in children) {
		EDRadixNode *nodeResults = [n prefixSearch:prefix];
		if (nodeResults) {
			for (EDRadixNode *branchChild in nodeResults.children) {
				[tree.children addObject:branchChild];
			}
			copied = YES;
		}
	}
	
	return copied;
}

-(void)dealloc {
	[value release];
	[children release];
	[super dealloc];
}

@end
