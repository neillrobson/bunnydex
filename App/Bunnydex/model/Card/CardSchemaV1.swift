//
//  CardSchemaV1.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/16/25.
//

import SwiftData

enum CardSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { .init(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [CardModel.self]
    }

    @Model
    final class CardModel {
        var id: String
        var title: String
        var rawType: Int
        var rawDeck: Int
        var rawPawn: Int?
        var rawRequirement: Int

        @Relationship(inverse: \DieModel.cards)
        var dice: [DieModel] = []
        @Relationship(inverse: \SymbolModel.cards)
        var symbols: [SymbolModel] = []

        var rules: [Rule]

        init(json: Card) {
            id = json.id
            title = json.title
            rules = json.rules ?? []

            rawType = json.type.rawValue
            rawDeck = json.deck.rawValue
            rawRequirement = json.bunnyRequirement?.rawValue ?? BunnyRequirement.no.rawValue

            rawPawn = json.pawn.map(\.rawValue)
        }
    }
}
