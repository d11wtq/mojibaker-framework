//
//  EDLexicalScope.m
//  EditorSDK
//
//  Created by Chris Corbyn on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexicalScope.h"


@implementation EDLexicalScope

+(id)scopeWithRangeValue:(NSValue *)aValue {
	return [[[self alloc] initWithRangeValue:aValue] autorelease];
}

-(id)initWithRangeValue:(NSValue *)aValue {
	if (self = [self init]) {
		rangeValue = [aValue retain];
	}
	
	return self;
}

-(NSRange)range {
	return [rangeValue rangeValue]; /* cough */
}

-(void)dealloc {
	[rangeValue release];
	[super dealloc];
}

@end
