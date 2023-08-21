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

import XCTest
import CDMarkdownKit

final class TestItalic: XCTestCase {

    func testItalicSingle() throws {
        let parser = CDMarkdownParser()

        var parsed = parser.parse("*italic*")
        XCTAssertEqual(parsed.string, "italic")
        XCTAssertTrue(TestHelpers.isItalic(testString: parsed, at: 0))

        parsed = parser.parse("_italic_")
        XCTAssertEqual(parsed.string, "italic")
        XCTAssertTrue(TestHelpers.isItalic(testString: parsed, at: 0))
    }

    func testItalicSentence() throws {
        let parser = CDMarkdownParser()

        let parsed = parser.parse("a _bold_ b *bold* c")
        XCTAssertEqual(parsed.string, "a bold b bold c")
        XCTAssertFalse(TestHelpers.isItalic(testString: parsed, at: 0))
        XCTAssertTrue(TestHelpers.isItalic(testString: parsed, at: 3))
        XCTAssertTrue(TestHelpers.isItalic(testString: parsed, at: 10))
        XCTAssertFalse(TestHelpers.isItalic(testString: parsed, at: 14))
    }

    func testItalicInWord() throws {
        let parser = CDMarkdownParser()

        // Using Asterisks should be italic inside words
        var parsed = parser.parse("pre*italic*post")
        XCTAssertEqual(parsed.string, "preitalicpost")
        XCTAssertTrue(TestHelpers.isItalic(testString: parsed, at: 4))

        // Using underscores should be ignored inside words
        parsed = parser.parse("pre_italic_post")
        XCTAssertEqual(parsed.string, "pre_italic_post")
        XCTAssertFalse(TestHelpers.isItalic(testString: parsed, at: 4))
    }
}
