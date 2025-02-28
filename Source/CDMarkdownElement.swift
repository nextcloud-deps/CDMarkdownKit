//
//  CDMarkdownElement.swift
//  CDMarkdownKit
//
//  Created by Christopher de Haan on 11/7/16.
//
//  Copyright © 2016-2022 Christopher de Haan <contact@christopherdehaan.me>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// The base protocol for all Markdown Elements, it handles parsing through regex.
public protocol CDMarkdownElement: AnyObject {

    var regularExpressions: [NSRegularExpression] { get }
    var enabled: Bool { get set }

    func parse(_ attributedString: NSMutableAttributedString)
    func match(_ match: NSTextCheckingResult,
               attributedString: NSMutableAttributedString)
}

public extension CDMarkdownElement {

    func parse(_ attributedString: NSMutableAttributedString) {
        var location = 0

        for regex in regularExpressions {
            location = 0
            while let regexMatch =
                    regex.firstMatch(in: attributedString.string,
                                     options: .withoutAnchoringBounds,
                                     range: NSRange(location: location,
                                                    length: attributedString.length - location)) {

                let oldLength = attributedString.length
                match(regexMatch, attributedString: attributedString)
                let newLength = attributedString.length
                location = regexMatch.range.location + regexMatch.range.length + newLength - oldLength
            }
        }
    }
}
