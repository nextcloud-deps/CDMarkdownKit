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

final class TestEscape: XCTestCase {

    func getParser() -> CDMarkdownParser {
        let parser = CDMarkdownParser()

        return parser
    }

    func testEscapeSingle() throws {
        let parser = getParser()

        let parsed = parser.parse("\\# Hello")
        XCTAssertEqual(parsed.string, "# Hello")
    }

    func testEscapedSyntax() throws {
        let parser = getParser()

        let parsed = parser.parse("\\`\\`\\`\nHello\\`\\`\\`")
        XCTAssertEqual(parsed.string, "```\nHello```")
    }

    func testEscapedCode() throws {
        let parser = getParser()

        let parsed = parser.parse("Hello \\`Hi\\\\nABC\\`")
        XCTAssertEqual(parsed.string, "Hello `Hi\\nABC`")
    }


    func testUnescapeInSyntax() throws {
        let parser = getParser()

        let parsed = parser.parse("```\nHello\\nthis should not trigger a (un-)escape```")
        XCTAssertEqual(parsed.string, "Hello\\nthis should not trigger a (un-)escape")
    }

    func testUnescapeQuoteInSyntax() throws {
        let parser = getParser()

        let parsed = parser.parse("```\n> This should be left as is```")
        XCTAssertEqual(parsed.string, "> This should be left as is")
    }
}
