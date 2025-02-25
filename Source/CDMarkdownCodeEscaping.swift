//
//  CDMarkdownCodeEscaping.swift
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

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

open class CDMarkdownCodeEscaping: CDMarkdownElement {

    fileprivate static let regex = ["(?<!\\\\)(?:\\\\\\\\)*+(`+(?!`))([\\s\\S]*?)(\\1)"]
    open var enabled: Bool = true

    lazy open var regularExpressions: [NSRegularExpression] = {
        // swiftlint:disable:next force_try
        return try! CDMarkdownCodeEscaping.regex.map { try NSRegularExpression(pattern: $0, options: []) }
    }()

    open func match(_ match: NSTextCheckingResult,
                    attributedString: NSMutableAttributedString) {

        let range = match.nsRange(atIndex: 2)

        // escaping all characters
        var matchString = attributedString.attributedSubstring(from: range).string

        if matchString.first == "\n" || matchString.first == "\r" {
            // If the first character is a newline, remove it to have the code block start properly
            matchString.remove(at: matchString.startIndex)
        } else if matchString.contains("\n") || matchString.contains("\r") {
            // If the codeblock contains a info string on the first line, we want to remove that
            if let range = matchString.range(of: ".*?[\\n\\r]", options: .regularExpression) {
                matchString = matchString.replacingCharacters(in: range, with: "")
            }
        }

        attributedString.replaceCharacters(in: range,
                                           with: matchString.toBase64())
    }
}
