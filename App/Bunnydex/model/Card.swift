//
//  Card.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/5/25.
//

import Foundation
import SwiftData
import SwiftUI
import EnumStringConvertible

@enumStringConvertible
enum CardType: Int, Codable, CaseIterable {
    case run,
         roamingRedRun,
         special,
         verySpecial,
         playImmediately,
         playRightNow,
         dolla,
         bunnyBuck,
         starter,
         carrotSupply,
         zodiac,
         chineseZodiac,
         rank,
         mysteriousPlace,
         senator,
         metal,
         bundergroundStation

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try .init(container.decode(String.self))!
    }
}

extension CardType: Identifiable {
    var id: Self { self }
}

@enumStringConvertible
enum Deck: Int, Codable, CaseIterable {
    case blue,
         yellow,
         red,
         violet,
         orange,
         green,
         twilightWhite,
         stainlessSteel,
         perfectlyPink,
         wackyKhaki,
         ominousOnyx,
         chocolate,
         fantastic,
         caramelSwirl,
         creatureFeature,
         pumpkinSpice,
         conquestBlue,
         conquestYellow,
         conquestRed,
         conquestViolet,
         kinderSkyBlue,
         kinderSunshineYellow,
         laDiDaLondon,
         cakeBatter,
         radioactiveRobots,
         almondCrisp

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try .init(container.decode(String.self))!
    }

    var isKinder: Bool {
        switch self {
        case .kinderSkyBlue, .kinderSunshineYellow: return true
        default: return false
        }
    }
}

extension Deck: Identifiable {
    var id: Self { self }
}

@enumStringConvertible
enum BunnyRequirement: Int, Codable, CaseIterable {
    case no,
         play,
         playX2,
         playAndSave

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try .init(container.decode(String.self))!
    }
}

extension BunnyRequirement: Identifiable {
    var id: Self { self }
}

@enumStringConvertible
enum Pawn: Int, Codable, CaseIterable {
    case blue, yellow, violet, orange, green, red, pink, black, brown

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try Pawn.init(container.decode(String.self))!
    }
}

extension Pawn: Identifiable {
    var id: Self { self }
}

struct Rule: Codable, Hashable {
    enum CodingKeys: CodingKey {
        case title
        case text
    }

    let title: String
    let text: String

    private let html: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        html = try container.decode(String.self, forKey: .text)

        var doc = BasicHTML(rawHTML: html)
        try doc.parse()
        text = try doc.asMarkdown().trim()
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.html, forKey: .text)
    }
}

struct JSONCard: Codable, Sendable, Hashable, Identifiable {
    let id: String
    let title: String
    let type: CardType
    let deck: Deck
    let bunnyRequirement: BunnyRequirement?
    let dice: [Die]?
    let pawn: Pawn?
    let symbols: [Symbol]?
    let rules: [Rule]?

    init(_ card: Card) {
        id = card.id
        title = card.title
        type = card.type
        deck = card.deck
        bunnyRequirement = card.bunnyRequirement
        dice = card.dice.map(\.die)
        pawn = card.pawn
        symbols = card.symbols.map(\.symbol)
        rules = card.rules
    }
}

@Model
class Card {
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

    init(json: JSONCard) {
        id = json.id
        title = json.title
        rules = json.rules ?? []

        rawType = json.type.rawValue
        rawDeck = json.deck.rawValue
        rawRequirement = json.bunnyRequirement?.rawValue ?? BunnyRequirement.no.rawValue

        rawPawn = json.pawn.map(\.rawValue)
    }

    /**
     Handles initializing, inserting, and defining relationships for a new Card model object.
     */
    @discardableResult
    static func create(json: JSONCard, context: ModelContext, dice: [Die: DieModel], symbols: [Symbol: SymbolModel]) -> Card {
        let card = Card(json: json)
        context.insert(card)

        card.dice = json.dice?.compactMap { dice[$0] } ?? []
        card.symbols = json.symbols?.compactMap { symbols[$0] } ?? []

        return card
    }
}
