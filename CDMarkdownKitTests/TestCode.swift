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

final class TestCode: XCTestCase {

    func getParser() -> CDMarkdownParser {
        let parser = CDMarkdownParser()

        parser.code.backgroundColor = .secondarySystemBackground
        parser.code.font =  CDFont.monospacedSystemFont(ofSize: 16, weight: .regular)

        parser.syntax.backgroundColor = .secondarySystemBackground
        parser.syntax.font =  CDFont.monospacedSystemFont(ofSize: 16, weight: .regular)

        return parser
    }

    func testCodeSingle() throws {
        let parser = getParser()

        let parsed = parser.parse("`code`")
        XCTAssertEqual(parsed.string, "code")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 0))
    }


    func testCodeMultiple() throws {
        let parser = getParser()

        let parsed = parser.parse("`test` abc `test` abc")
        XCTAssertEqual(parsed.string, "test abc test abc")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 2))
        XCTAssertFalse(TestHelpers.isMonospaced(testString: parsed, at: 6))
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 11))
        XCTAssertFalse(TestHelpers.isMonospaced(testString: parsed, at: 15))
    }

    func testCodeSentence() throws {
        let parser = getParser()

        var parsed = parser.parse("a `code` c")
        XCTAssertEqual(parsed.string, "a code c")
        XCTAssertFalse(TestHelpers.isMonospaced(testString: parsed, at: 0))
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 3))
        XCTAssertFalse(TestHelpers.isMonospaced(testString: parsed, at: 7))

        parsed = parser.parse("a ``code`` c")
        XCTAssertEqual(parsed.string, "a code c")
        XCTAssertFalse(TestHelpers.isMonospaced(testString: parsed, at: 0))
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 3))
        XCTAssertFalse(TestHelpers.isMonospaced(testString: parsed, at: 7))
    }

    func testCodeInWord() throws {
        let parser = getParser()

        let parsed = parser.parse("pre`code`post")
        XCTAssertEqual(parsed.string, "precodepost")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 4))
    }

    func testCodeInsideSyntax() throws {
        let parser = getParser()

        let parsed = parser.parse("```\n`code`\n```")
        XCTAssertEqual(parsed.string, "`code`\n")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 4))
    }

    /*
     // Expected to fail currently, because the CodeEscaping does not differentiate between code and syntax and always allows new lines
     func testCodeMultiline() throws {
        let parser = getParser()

        let parsed = parser.parse("Single backticks `\n`code`")
        XCTAssertEqual(parsed.string, "Single backticks`\ncode")
        XCTAssertTrue(TestHelpers.isMonospaced(testString: parsed, at: 19))
    }
     */
}
