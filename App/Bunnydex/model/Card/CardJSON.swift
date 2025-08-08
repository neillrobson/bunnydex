//
//  CardJSON.swift
//  Bunnydex
//
//  Created by Neill Robson on 8/8/25.
//

import Foundation
import SwiftData

struct CardJSON: Codable, Sendable, Hashable, Identifiable {
    var id: String
    var title: String
    var type: CardType
    var deck: Deck
    var bunnyRequirement: BunnyRequirement?
    var dice: [Die]?
    var pawn: Pawn?
    var symbols: [Symbol]?
    var rules: [Rule]?

    init(_ card: CardModel) {
        id = card.cardId
        title = card.title
        type = card.type
        deck = card.deck
        bunnyRequirement = card.bunnyRequirement
        dice = card.dice.map(\.die)
        pawn = card.pawn
        symbols = card.symbols.map(\.symbol)
        rules = card.orderedRules.map(\.rule)
    }
}
