//
// Copyright (c) 2024 Marcel Müller <marcel-mueller@gmx.de>
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

final class TestTask: XCTestCase {

    func getParser() -> CDMarkdownParser {
        let parser = CDMarkdownParser()

        return parser
    }

    func testTaskSingle() throws {
        let parser = getParser()
        let parsed = parser.parse("- [] ABC")

        XCTAssertTrue(parsed.string.contains("ABC"))
        XCTAssertFalse(parsed.string.contains("[]"))
        XCTAssertFalse(parsed.string.contains("-"))

        parsed.containsAttachments(in: NSRange(location: 0, length: parsed.length))
    }

    func testTaskMultiple() throws {
        let parser = getParser()
        let parsed = parser.parse("- [] ABC\n- [x] DEF")

        var attachmentCount = 0

        parsed.enumerateAttribute(.attachment, in: NSRange(location: 0, length: parsed.length)) { value, _, _ in
            if value is NSTextAttachment {
                attachmentCount += 1
            }
        }

        XCTAssertEqual(attachmentCount, 2)
    }



}
