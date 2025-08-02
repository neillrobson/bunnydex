//
//  Card.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/16/25.
//

import Foundation
import SwiftData

typealias CardModel = SchemaV3.CardModel

extension CardModel {
    var type: CardType {
        return .init(rawValue: rawType)!
    }

    var deck: Deck {
        return .init(rawValue: rawDeck)!
    }

    var pawn: Pawn? {
        return rawPawn.flatMap { .init(rawValue: $0) }
    }

    var bunnyRequirement: BunnyRequirement {
        return .init(rawValue: rawRequirement)!
    }

    /**
     Handles initializing, inserting, and defining relationships for a new Card model object.
     */
    @discardableResult
    static func create(json: Card, context: ModelContext, dice: [Die: DieModel], symbols: [Symbol: SymbolModel]) -> CardModel {
        let card = CardModel(json: json)
        context.insert(card)

        card.dice = json.dice?.compactMap { dice[$0] } ?? []
        card.symbols = json.symbols?.compactMap { symbols[$0] } ?? []

        return card
    }
}

struct Card: Codable, Sendable, Hashable, Identifiable {
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
