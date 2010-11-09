//
//  NSMutableRangeValue.m
//  EditorSDK
//
//  Created by Chris Corbyn on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSMutableRangeValue.h"


@implementation NSMutableRangeValue

+(id)valueWithRange:(NSRange)aRange {
	return [[[self alloc] initWithRange:aRange] autorelease];
}

-(id)initWithRange:(NSRange)aRange {
	if (self = [self init]) {
		range = aRange;
	}
	
	return self;
}

-(NSRange)rangeValue {
	return range;
}

-(void)setRangeValue:(NSRange)aRange {
	range = aRange;
}

@end
