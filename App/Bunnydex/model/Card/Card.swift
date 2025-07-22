//
//  Card.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/16/25.
//

import Foundation
import SwiftData

typealias CardModel = SchemaV2.CardModel

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
        id = card.id
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
