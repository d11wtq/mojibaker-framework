//
//  EDLexRule.m
//  EditorSDK
//
//  Created by Chris Corbyn on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EDLexRule.h"


@implementation EDLexRule

@synthesize exclusiveState;

-(id)init {
	if (self = [super init]) {
		exclusiveState = 0;
	}
	
	return self;
}

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range {
	return nil;
}

@end