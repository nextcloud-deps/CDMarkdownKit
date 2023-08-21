//
//  CDMarkdownKitTests.swift
//  CDMarkdownKitTests
//
//  Created by Marcel Müller on 17.08.23.
//  Copyright © 2023 Christopher de Haan. All rights reserved.
//

import XCTest
import CDMarkdownKit

final class TestMixed: XCTestCase {

    func testBoldItalic() throws {
        let parser = CDMarkdownParser()

        var parsed = parser.parse("**_bold_**")
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
}
