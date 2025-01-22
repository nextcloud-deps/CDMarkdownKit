//
// Copyright (c) 2023 Marcel Müller <marcel-mueller@gmx.de>
//
// Author Marcel Müller <marcel-mueller@gmx.de>
//
// GNU GPL version 3 or any later version
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import UIKit

class TestHelpers {

    private static func isHelper(testString: NSAttributedString, at location: Int, trait: UIFontDescriptor.SymbolicTraits) -> Bool {
        let attributes = testString.attributes(at: location, effectiveRange: nil)

        return attributes.contains { $0.key == .font && ($0.value as! UIFont).fontDescriptor.symbolicTraits.contains(trait) }
    }

    static func isBold(testString: NSAttributedString, at location: Int) -> Bool {
        return isHelper(testString: testString, at: location, trait: .traitBold)
    }

    static func isItalic(testString: NSAttributedString, at location: Int) -> Bool {
        return isHelper(testString: testString, at: location, trait: .traitItalic)
    }

    static func isMonospaced(testString: NSAttributedString, at location: Int) -> Bool {
        return isHelper(testString: testString, at: location, trait: .traitMonoSpace)
    }

    static func isStrikethrough(testString: NSAttributedString, at location: Int) -> Bool {
        let attributes = testString.attributes(at: location, effectiveRange: nil)

        return attributes.contains { $0.key == .strikethroughStyle && NSUnderlineStyle(rawValue: $0.value as! Int) == .single }
    }

    private static func anyHelper(testString: NSAttributedString, trait: UIFontDescriptor.SymbolicTraits) -> Bool {
        var found = false

        testString.enumerateAttribute(.font, in: .init(location: 0, length: testString.length)) { (value, range, stop) in
            if let font = value as? UIFont {
                if font.fontDescriptor.symbolicTraits.contains(trait) {
                    found = true
                    stop.pointee = true
                }
            }
        }

        return found
    }

    static func anyBold(testString: NSAttributedString) -> Bool {
        return anyHelper(testString: testString, trait: .traitBold)
    }

    static func anyItalic(testString: NSAttributedString) -> Bool {
        return anyHelper(testString: testString, trait: .traitItalic)
    }

    static func anyMonospaced(testString: NSAttributedString) -> Bool {
        return anyHelper(testString: testString, trait: .traitMonoSpace)
    }

    static func hasBackgroundColor(testString: NSAttributedString, at location: Int, color: UIColor) -> Bool {
        let attributes = testString.attributes(at: location, effectiveRange: nil)

        return attributes.contains { $0.key == .backgroundColor && ($0.value as! UIColor).isEqualTo(otherColor: color) }
    }

    
}
