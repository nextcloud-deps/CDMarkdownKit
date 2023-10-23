//
//  CDMarkdownLayoutManager.swift
//  CDMarkdownKit
//
//  Created by Christopher de Haan on 12/8/16.
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

#if os(iOS) || os(tvOS)

import UIKit

open class CDMarkdownLayoutManager: NSLayoutManager {

    open var roundAllCorners: Bool = false
    open var roundCodeCorners: Bool = false
    open var roundSyntaxCorners: Bool = false

    open override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange: glyphsToShow, at: origin)

        let charRange = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        guard let attributedString = self.textStorage?.attributedSubstring(from: charRange) else { return }

        // Use systemFill color for all drawings
        UIColor.systemFill.set()

        var previousRects: [(Int, CGRect)] = []

        attributedString.enumerateAttribute(.quoteLevel, in: NSRange(location: 0, length: attributedString.length), using: { value, range, stop in
            guard let currentLevel = value as? Int else { return }

            // Since "range" is now relative to the attributedString range, we need to adjust the location for the layoutManager
            let adjustedRange = NSRange(location: range.location + glyphsToShow.location, length: range.length)

            // Determine the boundingRect of the quote
            let glyphRange = self.glyphRange(forCharacterRange: adjustedRange, actualCharacterRange: nil)
            let textRect = self.boundingRect(forGlyphRange: glyphRange, in: self.textContainers[0])

            // For multiline paragraphs we will always have x = 0,
            // therefore we check the position of the very first character to correctly determine the indention.
            let glyphRangeFirstLine = self.glyphRange(forCharacterRange: NSRange(location: adjustedRange.location, length: 1), actualCharacterRange: nil)
            let textRectFirstLine = self.boundingRect(forGlyphRange: glyphRangeFirstLine, in: self.textContainers[0])

            // Create a rect that would later become our quote indicator (the bar on the left side of the quote)
            let newRect = CGRectMake(textRectFirstLine.origin.x - 15, textRect.origin.y + 2, 8, textRect.size.height - 4);

            for i in previousRects.indices.reversed() {
                var (level, rect) = previousRects[i]

                if level < currentLevel {
                    // If there are lower levels than the current one, we want to adjust the height to include the current level
                    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + textRect.size.height)
                    previousRects[i] = (level, rect)
                } else {
                    // If there are higher levels than the current one, we want to draw these rects now
                    UIBezierPath(roundedRect: rect, cornerRadius: 4).fill()
                    previousRects.remove(at: i)
                }
            }

            previousRects.append((currentLevel, newRect))
        })

        // Any remaining rects need to be drawn now
        for i in previousRects.indices.reversed() {
            let (_, rect) = previousRects[i]
            UIBezierPath(roundedRect: rect, cornerRadius: 4).fill()
        }
    }

    override open func fillBackgroundRectArray(_ rectArray: UnsafePointer<CGRect>,
                                               count rectCount: Int,
                                               forCharacterRange charRange: NSRange,
                                               color: UIColor) {

        var cornerRadius: CGFloat = 0
        if (self.roundCodeCorners == true && color.isEqualTo(otherColor: UIColor.codeBackgroundRed())) ||
            (self.roundSyntaxCorners == true && color.isEqualTo(otherColor: UIColor.syntaxBackgroundGray())) ||
            self.roundAllCorners == true {

            cornerRadius = 3
        }

        let path = CGMutablePath()

        if rectCount == 1 ||
            rectCount == 2 && (rectArray[1].maxX < rectArray[0].minX) {
            // 1 rect or 2 rects without edges in contact
            path.addRect(rectArray[0].insetBy(dx: cornerRadius,
                                              dy: cornerRadius))
            if rectCount == 2 {
                path.addRect(rectArray[1].insetBy(dx: cornerRadius,
                                                  dy: cornerRadius))
            }
        } else {
            // 2 or 3 rects
            let lastRect: Int = rectCount - 1

            path.move(to: CGPoint(x: rectArray[0].minX + cornerRadius,
                                  y: rectArray[0].maxY + cornerRadius))

            path.addLine(to: CGPoint(x: rectArray[0].minX + cornerRadius,
                                     y: rectArray[0].minY + cornerRadius))
            path.addLine(to: CGPoint(x: rectArray[0].maxX - cornerRadius,
                                     y: rectArray[0].minY + cornerRadius))

            path.addLine(to: CGPoint(x: rectArray[0].maxX - cornerRadius,
                                     y: rectArray[lastRect].minY - cornerRadius))
            path.addLine(to: CGPoint(x: rectArray[lastRect].maxX - cornerRadius,
                                     y: rectArray[lastRect].minY - cornerRadius))

            path.addLine(to: CGPoint(x: rectArray[lastRect].maxX - cornerRadius,
                                     y: rectArray[lastRect].maxY - cornerRadius))
            path.addLine(to: CGPoint(x: rectArray[lastRect].minX + cornerRadius,
                                     y: rectArray[lastRect].maxY - cornerRadius))

            path.addLine(to: CGPoint(x: rectArray[lastRect].minX + cornerRadius,
                                     y: rectArray[0].maxY + cornerRadius))

            path.closeSubpath()
        }
        // set fill and stroke color
        color.set()

        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setAllowsAntialiasing(true)
        ctx?.setShouldAntialias(true)

        ctx?.setLineWidth(cornerRadius * 2)
        ctx?.setLineJoin(.round)

        ctx?.addPath(path)

        ctx?.drawPath(using: .fillStroke)
    }
}

#endif
