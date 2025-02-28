//
//  CDMarkdownQuote.swift
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

open class CDMarkdownQuote: CDMarkdownLevelElement {

    fileprivate static let regex = "^(\\>{1,%@})\\s*(.+)$"

    open var font: CDFont?
    open var maxLevel: Int
    open var indicator: String
    open var separator: String
    open var color: CDColor?
    open var backgroundColor: CDColor?
    open var paragraphStyle: NSParagraphStyle?
    open var underlineColor: CDColor?
    open var underlineStyle: NSUnderlineStyle?
    open var enabled: Bool = true

    lazy open var regularExpressions: [NSRegularExpression] = {
        let level: String = maxLevel > 0 ? "\(maxLevel)" : ""
        let formattedRegex = String(format: CDMarkdownQuote.regex, level)

        // swiftlint:disable:next force_try
        return [try! NSRegularExpression(pattern: formattedRegex, options: .anchorsMatchLines)]
    }()

    public init(font: CDFont? = nil,
                maxLevel: Int = 0,
                indicator: String = ">",
                separator: String = "  ",
                color: CDColor? = nil,
                backgroundColor: CDColor? = nil,
                paragraphStyle: NSParagraphStyle? = nil,
                underlineColor: CDColor? = nil,
                underlineStyle: NSUnderlineStyle? = nil) {
        self.font = font
        self.maxLevel = maxLevel
        self.indicator = indicator
        self.separator = separator
        self.color = color
        self.backgroundColor = backgroundColor
        self.paragraphStyle = paragraphStyle
        self.underlineColor = underlineColor
        self.underlineStyle = underlineStyle
    }

    open func formatText(_ attributedString: NSMutableAttributedString,
                         range: NSRange,
                         level: Int) {

        attributedString.replaceCharacters(in: range,
                                           with: "")
    }

    open func attributesForLevel(_ level: Int) -> [CDAttributedStringKey: AnyObject] {
        var attributes = self.attributes

        // Add a custom attribute to quote paragraph, so we can detect it later in the layout phase
        attributes[.quoteLevel] = NSNumber(value: level)

        let paragraphIndent = (level + 1) * 12
        let updatedParagraphStyle = paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        updatedParagraphStyle.headIndent = CGFloat(paragraphIndent)
        updatedParagraphStyle.firstLineHeadIndent = CGFloat(paragraphIndent)
        attributes.addParagraphStyle(updatedParagraphStyle)

        return attributes
    }
}

extension NSAttributedString.Key {
    static let quoteLevel: NSAttributedString.Key = .init("quoteLevel")
}
