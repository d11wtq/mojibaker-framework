//
//  EDLexerBufferTest.m
//  EditorSDK
//
//  Created by Chris Corbyn on 13/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import <EDSupport/EDSupport.h>

@interface EDLexerBufferTest : GHTestCase
@end


@implementation EDLexerBufferTest

-(void)testFindsLookaheadTokens {
	NSString *string = @"abc";
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	EDLexRule *r = [EDCharacterLexRule rule];
	
	EDLexicalToken *firstTok = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(0, 1) value:@"a" rule:r];
	
	[lexer addRule:r];
	
	EDLexerBuffer *buf = [[EDLexerBuffer alloc] initWithLexer:lexer string:string];
	buf.token = firstTok;
	
	GHAssertEqualStrings(@"b", [buf lookahead].value, @"The next token should be return from -lookahead");
	GHAssertEqualStrings(@"c", [buf lookahead].value, @"The next token should be return from -lookahead");
	
	[buf release];
}

-(void)testLookaheadBufferContentsCanBeRead {
	NSString *string = @"abc";
	EDLexer *lexer = [EDLexer lexerWithStates:nil];
	EDLexRule *r = [EDCharacterLexRule rule];
	
	EDLexicalToken *firstTok = [EDLexicalToken tokenWithType:EDUnmatchedToken range:NSMakeRange(0, 1) value:@"a" rule:r];
	
	[lexer addRule:r];
	
	EDLexerBuffer *buf = [[EDLexerBuffer alloc] initWithLexer:lexer string:string];
	buf.token = firstTok;
	
	[buf lookahead];
	[buf lookahead];
	
	NSArray *lookaheadTokens = [buf lookaheadStack];
	
	GHAssertEquals((NSUInteger) 2, [lookaheadTokens count], @"There should be two lookahead tokens");
	
	GHAssertEqualStrings(@"b", [[lookaheadTokens objectAtIndex:0] value], @"The first lookahead token should be 'b'");
	GHAssertEqualStrings(@"c", [[lookaheadTokens objectAtIndex:1] value], @"The second lookahead token should be 'c'");
	
	[buf release];
}

@end
