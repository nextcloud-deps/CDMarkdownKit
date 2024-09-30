//
//  CDMarkdownTask.swift
//  CDMarkdownKit
//
//  Created by Marcel Müller on 30/09/24.
//
//  Copyright (c) 2024 Marcel Müller <marcel-mueller@gmx.de>
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

open class CDMarkdownTask: CDMarkdownLevelElement {

    fileprivate static let regex = "^\\s*([\\*\\+\\-]{1,%@})[ \t]+\\[[ xX]?\\](.+)$"
    fileprivate static let checkedImage = UIImage(systemName: "checkmark.square.fill")?.withTintColor(.secondaryLabel).withRenderingMode(.alwaysOriginal)
    fileprivate static let uncheckedImage = UIImage(systemName: "square")?.withTintColor(.secondaryLabel).withRenderingMode(.alwaysOriginal)

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
    open var indicatorFont: CDFont?

    lazy open var regularExpressions: [NSRegularExpression] = {
        let level: String = maxLevel > 0 ? "\(maxLevel)" : ""
        let formattedRegex = String(format: CDMarkdownTask.regex, level)

        // swiftlint:disable:next force_try
        return [try! NSRegularExpression(pattern: formattedRegex, options: .anchorsMatchLines)]
    }()

    public init(font: CDFont? = nil,
                maxLevel: Int = 0,
                indicator: String = "",
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
        if let paragraphStyle = paragraphStyle {
            self.paragraphStyle = paragraphStyle
        } else {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 2
            paragraphStyle.paragraphSpacingBefore = 0
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.lineSpacing = 1.0
            self.paragraphStyle = paragraphStyle
        }
        self.underlineColor = underlineColor
        self.underlineStyle = underlineStyle
    }

    open func formatText(_ attributedString: NSMutableAttributedString,
                         range: NSRange,
                         level: Int) {
        var string = (0..<level).reduce("") { (string, _) -> String in
            return "\(string)\(separator)"
        }
        string = "\(string)\(indicator) "

        let rawString = attributedString.string
        guard let convertedRange = Range(range, in: rawString),
              let uncheckedImage = CDMarkdownTask.uncheckedImage, let checkedImage = CDMarkdownTask.checkedImage
        else { return }

        let subString = rawString[convertedRange]
        var textAttachment: NSTextAttachment

        // subString is only the indicator part, so "- []" or "- [x]"
        // so it's safe to check for "[x]" without a range check
        if subString.contains("[x]") {
            textAttachment = NSTextAttachment(image: checkedImage)
        } else {
            textAttachment = NSTextAttachment(image: uncheckedImage)
        }

        let attributedResult = NSMutableAttributedString(string: string)
        attributedResult.append(NSAttributedString(attachment: textAttachment))

        if let font = indicatorFont {
            let range = NSRange(location: 0, length: attributedResult.length)
            attributedResult.addFont(font, toRange: range)
        }

        attributedString.replaceCharacters(in: range,
                                           with: attributedResult)
    }

    open func addFullAttributes(_ attributedString: NSMutableAttributedString,
                                range: NSRange,
                                level: Int) {
        var attributesForSizing = attributes

        // In some cases we don't want to override the font of the string, but to calculate the correct
        // headIndent, we need to know the font that the indicator and separator uses
        if self.font == nil, let sizingFont = self.indicatorFont {
            attributesForSizing.addFont(sizingFont)
        }

        let indicatorSize = "\(indicator) ".sizeWithAttributes(attributesForSizing)
        let separatorSize = separator.sizeWithAttributes(attributesForSizing)

        let floatLevel = CGFloat(level)
        guard let paragraphStyle = self.paragraphStyle else { return }
        let updatedParagraphStyle = paragraphStyle.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        updatedParagraphStyle.headIndent = indicatorSize.width + (separatorSize.width * floatLevel)

        attributedString.addParagraphStyle(updatedParagraphStyle,
                                           toRange: range)
    }

    open func addAttributes(_ attributedString: NSMutableAttributedString,
                            range: NSRange,
                            level: Int) {
        attributedString.addAttributes(attributesForLevel(level-1),
                                       range: range)
    }
}
