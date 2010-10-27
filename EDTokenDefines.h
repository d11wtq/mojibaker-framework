/*
 *  EDTokenDefines.h
 *  Editor
 *
 *  Created by Chris Corbyn on 23/10/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

// FIXME: This should be an enum (and WTF? A negative unsigned int??)

/*#define EDUnmatchedCharacterToken -1
#define EDWhitespaceToken 0
#define EDDefinerKeywordToken 1
#define EDKeywordToken 2
#define EDString1Token 3
#define EDString2Token 4
#define EDString3Token 5
#define EDSingleLineComment1Token 6
#define EDSingleLineComment2Token 7
#define EDMultilineComment1Token 8
#define EDMultilineComment2Token 9
#define EDEmbeddedLanguageToken 10*/

typedef enum _EDLexicalTokenType {
	EDUnmatchedCharacterToken,
	EDWhitespaceToken,
	EDDefinerKeywordToken,
	EDKeywordToken,
	EDString1Token,
	EDString2Token,
	EDString3Token,
	EDSingleLineComment1Token,
	EDSingleLineComment2Token,
	EDMultilineComment1Token,
	EDMultilineComment2Token,
	EDEmbeddedLanguageToken
} EDLexicalTokenType;
