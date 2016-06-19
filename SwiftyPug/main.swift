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
    ("[a-zA-z0-9]*", {$0 == "def" ? .Define : .Identifier($0)}),
    ("[0-9.]+",{return Token.Number(Float($0)!)}),
    ("\\(",{_ in return .ParenOpen}),
    ("\\(",{_ in return .ParenClose})
]

var str = "0.9834259734892asdlfkjsdlakflsdkamflasdkmfl"
let match = str.rangeOfString("[0-9.]+", options: .RegularExpressionSearch)
print(str.substringWithRange(match!))
let index = str.substringWithRange(match!).characters.count
str = str.substringFromIndex(str.startIndex.advancedBy(index))
print(str)

func tokenize (input:String) -> [Token]
{
	var tokens: [Token] = []
	var content = input
	while (content.characters.count > 0)
	{
		var matched = false
		for(pattern, generator) in tokenList
		{
			guard let match = content.rangeOfString(pattern, options: .RegularExpressionSearch)
			else
			{
				break
			}
			if match != nil
			{
				if let t = generator(content.substringWithRange(match))
				{
					tokens.append(t)
				}
				content = content.substringFromIndex(content.startIndex.advancedBy(content.substringWithRange(match).characters.count))
				matched = true
				break
			}
			if !matched
			{
				let index = content.startIndex.advancedBy(1)
				tokens.append(.Other(content.substringToIndex(index)))
				content = content.substringFromIndex(index)
			}
		}
	}
	return tokens
}

print(tokenize("0.9834259734892 asdlfkjsdlakflsdkamflasdkmfl"))