//
//  CardSchemaV1_1.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/21/25.
//

import SwiftData

extension SchemaV1_1 {
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
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1_1.RuleModel.card)
        var newRules: [SchemaV1_1.RuleModel] = []

        var rules: [Rule]

        init(json: Card) {
            id = json.id
            title = json.title
            rules = json.rules ?? []
            newRules = json.rules?.map(SchemaV1_1.RuleModel.init) ?? []

            rawType = json.type.rawValue
            rawDeck = json.deck.rawValue
            rawRequirement = json.bunnyRequirement?.rawValue ?? BunnyRequirement.no.rawValue

            rawPawn = json.pawn.map(\.rawValue)
        }

        init() {
            id = "0000"
            title = "Placeholder"
            rules = []

            rawType = 0
            rawDeck = 0
            rawRequirement = 0

            rawPawn = nil
        }
    }
}
