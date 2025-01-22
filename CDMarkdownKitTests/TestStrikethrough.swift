//
// Copyright (c) 2025 Marcel Müller <marcel-mueller@gmx.de>
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

final class TestStrikethrough: XCTestCase {

    func testStrikethrough() throws {
        let parser = CDMarkdownParser()

        var parsed = parser.parse("~~Test~~")
        XCTAssertEqual(parsed.string, "Test")
        XCTAssertTrue(TestHelpers.isStrikethrough(testString: parsed, at: 0))

        parsed = parser.parse("~Test~")
        XCTAssertEqual(parsed.string, "Test")
        XCTAssertTrue(TestHelpers.isStrikethrough(testString: parsed, at: 0))
    }

    func testNonStrikethrough() throws {
        let parser = CDMarkdownParser()

        let parsed = parser.parse("~~Test~")
        XCTAssertEqual(parsed.string, "Test~")
        XCTAssertFalse(TestHelpers.isStrikethrough(testString: parsed, at: 0))
    }
}
