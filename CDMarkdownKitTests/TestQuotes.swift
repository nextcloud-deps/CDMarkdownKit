//
// Copyright (c) 2026 Marcel Müller <marcel-mueller@gmx.de>
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

final class TestQuotes: XCTestCase {

    func testQuoteOnly() throws {
        let parser = CDMarkdownParser()

        let parsed = parser.parse("> Hello")
        XCTAssertEqual(parsed.string, "Hello")
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 0), 0)
    }

    func testQuoteSingleNewline() throws {
        let parser = CDMarkdownParser()

        var parsed = parser.parse("> Hello\nHello again")
        XCTAssertEqual(parsed.string, "Hello\nHello again")
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 0), 0)
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 8), 0)

        parsed = parser.parse("> Hello\n>Hello again")
        XCTAssertEqual(parsed.string, "Hello\nHello again")
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 0), 0)
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 10), 0)
    }

    func testQuoteMultiple() throws {
        let parser = CDMarkdownParser()
        parser.squashNewlines = false
        parser.trimLeadingWhitespaces = false

        let parsed = parser.parse("Normal\n> Hello\nHello again\n\nNormal again")
        XCTAssertEqual(parsed.string, "Normal\nHello\nHello again\n\nNormal again")
        XCTAssertEqual(TestHelpers.getHeadIndent(testString: parsed, at: 0), 0)
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 8), 0)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 8), 0)
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 16), 0)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 16), 0)
        XCTAssertEqual(TestHelpers.getHeadIndent(testString: parsed, at: 24), 0)
    }

    func testQuoteSingleNested() throws {
        let parser = CDMarkdownParser()

        let parsed = parser.parse(">> Hello")
        XCTAssertEqual(parsed.string, "Hello")
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 0), 15)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 0), 1)
    }

    func testQuoteNested() throws {
        let parser = CDMarkdownParser()
        parser.squashNewlines = false
        parser.trimLeadingWhitespaces = false

        var parsed = parser.parse("> Hello\n>> Hello")
        XCTAssertEqual(parsed.string, "Hello\nHello")
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 0), 0)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 0), 0)
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 6), 15)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 6), 1)

        parsed = parser.parse("> Hello\n\n>> Hello")
        XCTAssertEqual(parsed.string, "Hello\n\nHello")
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 0), 0)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 0), 0)
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 7), 15)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 7), 1)

        parsed = parser.parse("> Hello\n\n>> Hello\n>> Hello")
        XCTAssertEqual(parsed.string, "Hello\n\nHello\nHello")
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 0), 0)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 0), 0)
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 7), 15)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 7), 1)
        XCTAssertGreaterThan(TestHelpers.getHeadIndent(testString: parsed, at: 14), 15)
        XCTAssertEqual(TestHelpers.getQuoteLevel(testString: parsed, at: 14), 1)
    }

}
