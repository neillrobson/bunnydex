//
//  Index.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/16/25.
//

import SwiftData

typealias CardModel = CardSchemaV1.CardModel

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
    static func create(json: JSONCard, context: ModelContext, dice: [Die: DieModel], symbols: [Symbol: SymbolModel]) -> CardModel {
        let card = CardModel(json: json)
        context.insert(card)

        card.dice = json.dice?.compactMap { dice[$0] } ?? []
        card.symbols = json.symbols?.compactMap { symbols[$0] } ?? []

        return card
    }
}
