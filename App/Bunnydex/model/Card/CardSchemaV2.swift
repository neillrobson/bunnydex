//
//  CardSchemaV2.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/21/25.
//

import SwiftData

extension SchemaV2 {
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
        @Relationship(deleteRule: .cascade, originalName: "newRules", inverse: \RuleModel.card)
        var rules: [RuleModel] = []

        init(json: Card) {
            id = json.id
            title = json.title

            rawType = json.type.rawValue
            rawDeck = json.deck.rawValue
            rawRequirement = json.bunnyRequirement?.rawValue ?? BunnyRequirement.no.rawValue

            rawPawn = json.pawn.map(\.rawValue)

            orderedRules = json.rules?.map(RuleModel.init) ?? []
        }

        init() {
            id = "0000"
            title = "Placeholder"

            rawType = 0
            rawDeck = 0
            rawRequirement = 0

            rawPawn = nil
        }
    }
}
