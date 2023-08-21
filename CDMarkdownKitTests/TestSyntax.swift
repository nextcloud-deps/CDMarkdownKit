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

final class TestSyntax: XCTestCase {

    func getParser() -> CDMarkdownParser {
        let parser = CDMarkdownParser()

        parser.code.backgroundColor = .secondarySystemBackground
        parser.code.font =  CDFont.monospacedSystemFont(ofSize: 16, weight: .regular)

        parser.syntax.backgroundColor = .secondarySystemBackground
        parser.syntax.font =  CDFont.monospacedSystemFont(ofSize: 16, weight: .regular)

        return parser
    }

    func testSyntaxSingle() throws {
        let parser = getParser()

        let parsed = parser.parse("```\nsyntax\n```")
        XCTAssertEqual(parsed.string, "syntax\n")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 4))
    }

    func testSyntaxSentence() throws {
        let parser = getParser()

        let parsed = parser.parse("a ```syntax``` c")
        XCTAssertEqual(parsed.string, "a syntax c")
        XCTAssertFalse(TestHelpers.isMonospaced(testString: parsed, at: 0))
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 3))
        XCTAssertFalse(TestHelpers.isMonospaced(testString: parsed, at: 9))
    }

    func testSyntaxInWord() throws {
        let parser = getParser()

        let parsed = parser.parse("a```syntax```b")
        XCTAssertEqual(parsed.string, "asyntaxb")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 4))
    }

    func testSyntaxEmpty() throws {
        let parser = getParser()

        // Info string is removed in multiline syntax blocks
        var parsed = parser.parse("``````")
        XCTAssertEqual(parsed.string, " \n")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 0))

        // If no new line is found, the content is not considered a infostring
        parsed = parser.parse("```\n```")
        XCTAssertEqual(parsed.string, " \n")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 0))
    }

    func testSyntaxMultiline() throws {
        let parser = getParser()

        var parsed = parser.parse("```\nsyntax```")
        XCTAssertEqual(parsed.string, "syntax")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 4))

        parsed = parser.parse("```\nsyntax\nsyntax2\nsyntax3\n```")
        XCTAssertEqual(parsed.string, "syntax\nsyntax2\nsyntax3\n")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 4))
        XCTAssertFalse(TestHelpers.anyBold(testString: parsed))
    }

    func testSyntaxInfostring() throws {
        let parser = getParser()

        // Info string is removed in multiline syntax blocks
        var parsed = parser.parse("```js\nsyntax```")
        XCTAssertEqual(parsed.string, "syntax")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 4))

        // If no new line is found, the content is not considered a infostring
        parsed = parser.parse("```syntax```")
        XCTAssertEqual(parsed.string, "syntax")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 4))
        XCTAssertFalse(TestHelpers.anyBold(testString: parsed))
    }

    func testSyntaxBoldItalic() throws {
        let parser = getParser()

        let parsed = parser.parse("```\nsyntax\n**bold**\n_italic_\n```")
        XCTAssertEqual(parsed.string, "syntax\n**bold**\n_italic_\n")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 4))
        XCTAssertFalse(TestHelpers.anyBold(testString: parsed))
        XCTAssertFalse(TestHelpers.anyItalic(testString: parsed))
    }
}
