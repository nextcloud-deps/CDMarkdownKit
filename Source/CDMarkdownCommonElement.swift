//
//  CDMarkdownCommonElement.swift
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

// MarkdownCommentElement represent the default Markdown elements which only manipulate content
// visually, (e.g. Bold or Italic)
public protocol CDMarkdownCommonElement: CDMarkdownElement, CDMarkdownStyle {

    func addAttributes(_ attributedString: NSMutableAttributedString,
                       range: NSRange)
}

public extension CDMarkdownCommonElement {

    func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
        attributedString.addAttributes(attributes, range: range)
    }

    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        let attributes = attributedString.attributes(at: match.nsRange(atIndex: 3).lowerBound, effectiveRange: nil)

        // Don't format parts of the string which already contain a link
        if attributes.contains(where: { $0.key == .link}) {
            return
        }

        // deleting trailing markdown
        attributedString.deleteCharacters(in: match.nsRange(atIndex: 4))
        // formatting string (may alter the length)
        addAttributes(attributedString, range: match.nsRange(atIndex: 3))
        // deleting leading markdown
        attributedString.deleteCharacters(in: match.nsRange(atIndex: 2))
    }
}
