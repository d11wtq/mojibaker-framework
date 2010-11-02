/*
 *  EDLexerStatesInfo.h
 *  EditorSDK
 *
 *  Created by Chris Corbyn on 31/10/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#define EDLexerStatesStackSize 100

typedef struct _EDLexerStatesInfo {
	NSUInteger stack[EDLexerStatesStackSize];
	NSUInteger stackSize;
	NSUInteger currentState;
} EDLexerStatesInfo;
