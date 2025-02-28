//
//  CDMarkdownCode.swift
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

open class CDMarkdownCode: CDMarkdownCommonElement {

    fileprivate static let regex = ["((?<!`))(`{1,2})(\\s*?[^`]*?\\s*?)(\\2)(?!`)"]

    open var font: CDFont?
    open var color: CDColor?
    open var backgroundColor: CDColor?
    open var paragraphStyle: NSParagraphStyle?
    open var underlineColor: CDColor?
    open var underlineStyle: NSUnderlineStyle?
    open var enabled: Bool = true

    lazy open var regularExpressions: [NSRegularExpression] = {
        // swiftlint:disable:next force_try
        return try! CDMarkdownCode.regex.map { try NSRegularExpression(pattern: $0, options: []) }
    }()

    public init(font: CDFont? = CDFont(name: "Menlo-Regular", size: 12),
                color: CDColor? = CDColor.codeTextRed(),
                backgroundColor: CDColor? = CDColor.codeBackgroundRed(),
                paragraphStyle: NSParagraphStyle? = nil,
                underlineColor: CDColor? = nil,
                underlineStyle: NSUnderlineStyle? = nil) {
        self.font = font
        self.color = color
        self.backgroundColor = backgroundColor
        self.paragraphStyle = paragraphStyle
        self.underlineColor = underlineColor
        self.underlineStyle = underlineStyle
    }

    open func addAttributes(_ attributedString: NSMutableAttributedString,
                            range: NSRange) {
        let matchString: String = attributedString.attributedSubstring(from: range).string
        guard let unescapedString = matchString.fromBase64() else { return }
        attributedString.replaceCharacters(in: range,
                                           with: unescapedString)
        let range = NSRange(location: range.location,
                            length: unescapedString.characterCount())
        attributedString.addAttributes(attributes,
                                       range: range)
        let mutableString = attributedString.mutableString
        // Remove \n if in string, not valid in Code element
        // Use Syntax element for \n to parse in string
        mutableString.replaceOccurrences(of: "\n",
                                         with: "",
                                         options: [],
                                         range: range)
    }
}
