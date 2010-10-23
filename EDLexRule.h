//
//  EDLexRule.h
//  Editor
//
//  Created by Chris Corbyn on 22/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EDLexicalToken;

@protocol EDLexRule <NSObject>

/*!
 * Return the next token found in the string, or nil if not found.
 */
-(EDLexicalToken *)lexInString:(NSString *)string range:(NSRange)range;

@end
