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

final class TestBold: XCTestCase {

    func testBoldSingle() throws {
        let parser = CDMarkdownParser()

        var parsed = parser.parse("**bold**")
        XCTAssertEqual(parsed.string, "bold")
        XCTAssertTrue(TestHelpers.isBold(testString: parsed, at: 0))

        parsed = parser.parse("__bold__")
        XCTAssertEqual(parsed.string, "bold")
        XCTAssertTrue(TestHelpers.isBold(testString: parsed, at: 0))
    }

    func testBoldSentence() throws {
        let parser = CDMarkdownParser()

        let parsed = parser.parse("a __bold__ b **bold** c")
        XCTAssertEqual(parsed.string, "a bold b bold c")
        XCTAssertFalse(TestHelpers.isBold(testString: parsed, at: 0))
        XCTAssertTrue(TestHelpers.isBold(testString: parsed, at: 3))
        XCTAssertTrue(TestHelpers.isBold(testString: parsed, at: 10))
        XCTAssertFalse(TestHelpers.isBold(testString: parsed, at: 14))
    }

    func testBoldInWord() throws {
        let parser = CDMarkdownParser()

        // Using Asterisks should be bold inside words
        var parsed = parser.parse("pre**bold**post")
        XCTAssertEqual(parsed.string, "preboldpost")
        XCTAssertTrue(TestHelpers.isBold(testString: parsed, at: 4))

        // Using underscores should be ignored inside words
        parsed = parser.parse("pre__bold__post")
        XCTAssertEqual(parsed.string, "pre__bold__post")
        XCTAssertFalse(TestHelpers.isBold(testString: parsed, at: 4))
    }

    /*
     //Expected to fail currently, since a part of the attributedString can only be bold or italic
     func testBoldItalicSingle() throws {
     let parser = CDMarkdownParser()

     var parsed = parser.parse("_**bold**_")
     XCTAssertEqual(parsed.string, "bold")
     XCTAssertTrue(TestHelpers.isBold(testString: parsed, at: 0))
     XCTAssertTrue(TestHelpers.isItalic(testString: parsed, at: 0))

     parsed = parser.parse("__*bold*__")
     XCTAssertEqual(parsed.string, "bold")
     XCTAssertTrue(TestHelpers.isBold(testString: parsed, at: 0))
     XCTAssertTrue(TestHelpers.isItalic(testString: parsed, at: 0))
     }
     */
}
