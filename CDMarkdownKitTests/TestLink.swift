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

final class TestLink: XCTestCase {

    func testLinkWithNormalText() throws {
        let parser = CDMarkdownParser()

        var parsed = parser.parse("Test [ABC](https://test.invalid)")
        XCTAssertEqual(parsed.string, "Test ABC")
        XCTAssertTrue(TestHelpers.hasLink(testString: parsed, at: 6, link: "https://test.invalid"))
        XCTAssertFalse(TestHelpers.hasLink(testString: parsed, at: 1, link: "https://test.invalid"))

        parsed = parser.parse("[ABC](https://test.invalid) Test")
        XCTAssertEqual(parsed.string, "ABC Test")
        XCTAssertTrue(TestHelpers.hasLink(testString: parsed, at: 2, link: "https://test.invalid"))
        XCTAssertFalse(TestHelpers.hasLink(testString: parsed, at: 6, link: "https://test.invalid"))
        XCTAssertTrue(TestHelpers.hasLink(testString: parsed, at: 2, link: "https://test.invalid"))

        parsed = parser.parse("Foo [ABC](https://test.invalid) Test")
        XCTAssertEqual(parsed.string, "Foo ABC Test")
        XCTAssertFalse(TestHelpers.hasLink(testString: parsed, at: 2, link: "https://test.invalid"))
        XCTAssertFalse(TestHelpers.hasLink(testString: parsed, at: 3, link: "https://test.invalid"))
        XCTAssertTrue(TestHelpers.hasLink(testString: parsed, at: 4, link: "https://test.invalid"))
        XCTAssertTrue(TestHelpers.hasLink(testString: parsed, at: 5, link: "https://test.invalid"))
        XCTAssertTrue(TestHelpers.hasLink(testString: parsed, at: 6, link: "https://test.invalid"))
        XCTAssertFalse(TestHelpers.hasLink(testString: parsed, at: 7, link: "https://test.invalid"))
        XCTAssertFalse(TestHelpers.hasLink(testString: parsed, at: 10, link: "https://test.invalid"))
    }

    func testLinkOnly() throws {
        let parser = CDMarkdownParser()

        let parsed = parser.parse("[ABC](https://test.invalid)")
        XCTAssertEqual(parsed.string, "ABC")
        XCTAssertTrue(TestHelpers.hasLink(testString: parsed, at: 0, link: "https://test.invalid"))
        XCTAssertTrue(TestHelpers.hasLink(testString: parsed, at: 1, link: "https://test.invalid"))
        XCTAssertTrue(TestHelpers.hasLink(testString: parsed, at: 2, link: "https://test.invalid"))
    }

}
