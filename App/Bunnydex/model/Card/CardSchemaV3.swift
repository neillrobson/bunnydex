//
//  CardSchemaV3.swift
//  Bunnydex
//
//  Created by Neill Robson on 8/2/25.
//

import Foundation
import SwiftData

extension SchemaV3 {
    @Model
    final class CardModel {
        var id: ObjectIdentifier {
            ObjectIdentifier(self)
        }

        @Attribute(originalName: "id")
        var cardId: String
        var title: String
        var rawType: Int
        var rawDeck: Int
        var rawPawn: Int?
        var rawRequirement: Int

        @Relationship(inverse: \DieModel.cards)
        var dice: [DieModel] = []
        @Relationship(inverse: \SymbolModel.cards)
        var symbols: [SymbolModel] = []
        @Relationship(deleteRule: .cascade, inverse: \RuleModel.card)
        var rules: [RuleModel] = []

        init(json: CardJSON) {
            cardId = json.id
            title = json.title

            rawType = json.type.rawValue
            rawDeck = json.deck.rawValue
            rawRequirement = json.bunnyRequirement?.rawValue ?? BunnyRequirement.no.rawValue

            rawPawn = json.pawn.map(\.rawValue)

            orderedRules = json.rules?.map(RuleModel.init) ?? []
        }

        init() {
            cardId = "0000"
            title = "Placeholder"

            rawType = 0
            rawDeck = 0
            rawRequirement = 0

            rawPawn = nil
        }

        var orderedRules: [RuleModel] {
            get {
                rules.sorted(using: SortDescriptor(\.order))
            }
            set {
                var oldValue = rules.sorted(using: SortDescriptor(\.order))
                for rule in newValue {
                    rule.card = self
                }
                let differences = newValue.difference(from: oldValue)

                func completelyRearrangeArray() {
                    let count = newValue.count

                    switch count {
                    case 0:
                        return
                    case 1:
                        newValue[0].order = 0
                        return
                    default:
                        break
                    }

                    let offset = Int.min / 2
                    let portion = Int.max / (count - 1)

                    for index in 0..<count {
                        newValue[index].order = offset + index * portion
                    }
                }

                for difference in differences {
                    switch difference {
                    case .remove(let offset, let element, _):
                        if !newValue.contains(element) {
                            modelContext?.delete(element)
                        }
                        oldValue.remove(at: offset)
                    case .insert(let offset, let element, _):
                        if oldValue.isEmpty {
                            element.order = 0
                            oldValue.insert(element, at: offset)
                            continue
                        }

                        var from = Int.min / 2
                        var to = Int.max / 2

                        if offset > 0 {
                            from = oldValue[offset - 1].order + 1
                        }
                        if offset < oldValue.count {
                            to = oldValue[offset].order
                        }

                        guard from < to else {
                            completelyRearrangeArray()
                            return
                        }

                        let range: Range<Int> = from..<to
                        element.order = range.randomElement()!

                        oldValue.insert(element, at: offset)
                    }
                }
            }
        }
    }
}
