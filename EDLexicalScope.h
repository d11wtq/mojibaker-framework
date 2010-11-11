//
//  EDLexicalScope.h
//  EditorSDK
//
//  Created by Chris Corbyn on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EDLexicalScope : NSObject {
	NSValue *rangeValue;
}

+(id)scopeWithRangeValue:(NSValue *)aValue;
-(id)initWithRangeValue:(NSValue *)aValue;

-(NSRange)range;

@end
