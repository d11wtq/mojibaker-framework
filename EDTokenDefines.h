/*
 *  EDTokenDefines.h
 *  Editor
 *
 *  Created by Chris Corbyn on 23/10/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

typedef enum _EDLexicalTokenType {
	EDUnmatchedToken,
	EDWhitespaceToken,
	EDDefinerKeywordToken,
	EDKeywordToken,
	EDKeyword2Token,
	EDKeyword3Token,
	EDStringToken,
	EDString2Token,
	EDString3Token,
	EDSingleLineCommentToken,
	EDSingleLineComment2Token,
	EDMultilineCommentToken,
	EDMultilineComment2Token,
	EDMultilineComment3Token,
	EDFunctionDefinitionToken,
	EDVariableToken,
	EDVariable2Token,
	EDVariable3Token,
	EDConstantToken,
	EDBraceToken,
	EDFunctionCallToken,
	EDMethodCallToken,
	EDEmbeddedLanguageDelimiterToken
} EDLexicalTokenType;
