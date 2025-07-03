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

    @Test func orderedList() throws {
        let raw = "When you draw a Zodiac card, you must immediately place it face up in front of you and draw another card. Zodiac cards may not be kept in your hand. If a player is given a Zodiac card during the initial deal at the start of the game, or picks one from the Draw Pile during play, then the card is saved and the player draws another card. This is very similar to how players save Kaballa Dolla. Many new cards will refer to these saved Zodiac cards during play.<br><br>At the end of the game (before The Magic Carrot is revealed), the small deck of Zodiac Cards, hidden away at the start of the game, is inspected. The small Zodiac Card at the bottom of the deck is considered the Winning Zodiac sign. If a player has the large Zodiac card saved with the Winning Zodiac sign, then he is awarded the following special privileges:<br><br><ol><li>The player may move any one bunny in The Bunny Circle from any one player to any other player. This may effectively eliminate a player from reaching the final draw of The Magic Carrot (if he has only one bunny in The Bunny Circle at the end of the game), or it may allow a player with no bunny in The Bunny Circle a chance at the final draw of The Magic Carrot.</li><li>If the Winning Zodiac sign is the player's birth zodiac sign or the current zodiac sign, then the player may also take any three Carrots from the opponent with the most Carrots. If two or more opponents have the same amount of Carrots, then the player may choose from which opponent he will take the three Carrots.</li><li>If the Winning Zodiac sign is both the player's birth zodiac sign and the current zodiac sign, then the player may take almost all of the Carrots from all of his opponents. Each opponent that had at least one Carrot must be left with only one Carrot, the rest of the Carrots will belong to the player.</li><br>It is possible that when the game ends no player is holding the Winning Zodiac sign. If this is the case, then the game simply continues by revealing The Magic Carrot using the small deck of Carrot Cards.<br><br>Each Zodiac card shows not only the beginning and end dates for its sign, but the name of the zodiac sign that appears previously and afterwards on the calendar. Also, each Zodiac card has a type or symbol: Air, Earth, Fire or Water. These zodiac symbols are indicated in the upper left corner of the card by the icons: Cloud, Planet, Flame and Waves respectfully. If a player has three consecutive saved Zodiac cards (by date), or all three Zodiac cards of the same symbol, then he may play two cards per turn."
        let expected = """
        When you draw a Zodiac card, you must immediately place it face up in front of you and draw another card. Zodiac cards may not be kept in your hand. If a player is given a Zodiac card during the initial deal at the start of the game, or picks one from the Draw Pile during play, then the card is saved and the player draws another card. This is very similar to how players save Kaballa Dolla. Many new cards will refer to these saved Zodiac cards during play.

        At the end of the game (before The Magic Carrot is revealed), the small deck of Zodiac Cards, hidden away at the start of the game, is inspected. The small Zodiac Card at the bottom of the deck is considered the Winning Zodiac sign. If a player has the large Zodiac card saved with the Winning Zodiac sign, then he is awarded the following special privileges:



        1. The player may move any one bunny in The Bunny Circle from any one player to any other player. This may effectively eliminate a player from reaching the final draw of The Magic Carrot (if he has only one bunny in The Bunny Circle at the end of the game), or it may allow a player with no bunny in The Bunny Circle a chance at the final draw of The Magic Carrot.

        2. If the Winning Zodiac sign is the player's birth zodiac sign or the current zodiac sign, then the player may also take any three Carrots from the opponent with the most Carrots. If two or more opponents have the same amount of Carrots, then the player may choose from which opponent he will take the three Carrots.

        3. If the Winning Zodiac sign is both the player's birth zodiac sign and the current zodiac sign, then the player may take almost all of the Carrots from all of his opponents. Each opponent that had at least one Carrot must be left with only one Carrot, the rest of the Carrots will belong to the player.
        It is possible that when the game ends no player is holding the Winning Zodiac sign. If this is the case, then the game simply continues by revealing The Magic Carrot using the small deck of Carrot Cards.

        Each Zodiac card shows not only the beginning and end dates for its sign, but the name of the zodiac sign that appears previously and afterwards on the calendar. Also, each Zodiac card has a type or symbol: Air, Earth, Fire or Water. These zodiac symbols are indicated in the upper left corner of the card by the icons: Cloud, Planet, Flame and Waves respectfully. If a player has three consecutive saved Zodiac cards (by date), or all three Zodiac cards of the same symbol, then he may play two cards per turn.
        """

        var document = BasicHTML(rawHTML: raw)
        try document.parse()

        let markdown = try document.asMarkdown().trim()
        #expect(markdown == expected)
    }

}
