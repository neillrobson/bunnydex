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

    @Test func unorderedList() throws {
        let raw = "May be placed on any bunny in The Bunny Circle.<ul><li>If all of the dice show different numbers then the player may choose a carrot from Kaballa's Market and take 7 Dolla from the Discard Pile.</li><li>If any two dice show the same number then feed the bunny 1 Cabbage Unit and 1 Water Unit.</li><li>If any three dice show the same number then the bunny is snuffed by the casino bosses.</li></ul>"
        let expected = """
        May be placed on any bunny in The Bunny Circle.

        - If all of the dice show different numbers then the player may choose a carrot from Kaballa's Market and take 7 Dolla from the Discard Pile.

        - If any two dice show the same number then feed the bunny 1 Cabbage Unit and 1 Water Unit.

        - If any three dice show the same number then the bunny is snuffed by the casino bosses.
        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown().trim()
        #expect(markdown == expected)
    }

}
