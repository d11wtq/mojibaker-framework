//
//  EDLexRule.h
//  EditorSDK
//
//  Created by Chris Corbyn on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDLexicalToken.h"

@interface EDLexRule : NSObject {
	NSUInteger exclusiveState;
}

@property (nonatomic) NSUInteger exclusiveState;

-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range;

@end
