//
//  main.swift
//  SwiftyPug
//
//  Created by Robin Malhotra on 19/06/16.
//  Copyright © 2016 Robin Malhotra. All rights reserved.
//
// Mark : http://blog.matthewcheok.com/writing-a-lexer-in-swift/

import Foundation

enum Token
{
    case Define,
    Number(Float),
    Identifier(String),
    ParenOpen,
    ParenClose,
    Comma,
    Other(String)
}

let tokenList : [(String, (String) -> Token?)] =
[
    ("[\t \n]", {_ in return nil}),
    ("[a-zA-Z][a-zA-z0-9]*", {$0 == "def" ? .Define : .Identifier($0)}),
    ("[0-9.]+",{return Token.Number(Float($0)!)}),
    ("\\(",{_ in return .ParenOpen}),
    ("\\)",{_ in return .ParenClose})
]
let str = "def xyz() = 2 + 1"
func tokenize(input:String) -> [Token]
{
	var str = input
	var tokens : [Token] = []
	while(str.characters.count > 0)
	{
		var matched = false
		for (pattern, generator) in tokenList
		{
			if let match = str.rangeOfString(pattern, options: .RegularExpressionSearch) where (match.startIndex == str.startIndex)
			{
				matched = true
				if let token = generator(str.substringWithRange(match))
				{
					tokens.append(token)
				}
				let index = str.substringWithRange(match).characters.count
				str = str.substringFromIndex(str.startIndex.advancedBy(index))
				break
			}
		}
		if !matched
		{
			let index = str.startIndex.advancedBy(1)
			tokens.append(.Other(str.substringToIndex(index)))
			str = str.substringFromIndex(index)
		}
	}
	return tokens
}

print(tokenize(str))