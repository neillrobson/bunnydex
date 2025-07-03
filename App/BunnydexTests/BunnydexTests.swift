//
//  BunnydexTests.swift
//  BunnydexTests
//
//  Created by Neill Robson on 7/3/25.
//

import Testing
@testable import Bunnydex

struct BunnydexTests {

    @Test func basicHTML() async throws {
        let raw = "Link to <a href=\"https://www.google.com\">Google</a>."
        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown().trim()
        #expect(markdown == "Link to [Google](https://www.google.com).")
    }

}
