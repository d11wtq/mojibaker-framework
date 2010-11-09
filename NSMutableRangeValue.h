//
//  NSMutableRangeValue.h
//  EditorSDK
//
//  Created by Chris Corbyn on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSMutableRangeValue : NSValue {
	NSRange range;
}

+(id)valueWithRange:(NSRange)aRange;
-(id)initWithRange:(NSRange)aRange;

-(NSRange)rangeValue;
-(void)setRangeValue:(NSRange)aRange;

@end
