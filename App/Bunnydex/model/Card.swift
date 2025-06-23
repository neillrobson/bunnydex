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
enum BunnyRequirement: Int, LosslessStringConvertible, CaseIterable {
    case no,
         play,
         playX2,
         playAndSave
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

struct Rule: Codable {
    var title: String
    var text: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        let rawText = try container.decode(String.self, forKey: .text)

        let regex = "<a href=\"(.+?)\">(.+?)<\\/a>"
        let repl = "[$2]($1)"

        self.text = rawText
            .replacingOccurrences(of: regex, with: repl, options: .regularExpression)
            .replacingOccurrences(of: "<br>", with: "\n")
            .replacingOccurrences(of: "<ul>", with: "\n")
            .replacingOccurrences(of: "</ul>", with: "\n")
            .replacingOccurrences(of: "<li>", with: "\n- ")
            .replacingOccurrences(of: "</li>", with: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct JSONCard: Codable, Sendable {
    let id: String
    let title: String
    let type: CardType
    let deck: Deck
    let bunnyRequirement: String?
    let dice: [String]?
    let pawn: Pawn?
    let symbols: [String]?
    let rules: [Rule]?
}

@Model
class Card {
    var id: String
    var title: String
    var rawType: Int
    var rawDeck: Int
    var rawPawn: Int?
    var rawRequirement: Int
    var dice: [Die]
    var symbols: [Symbol]
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

        let requirementString = json.bunnyRequirement ?? "NO"
        guard let bunnyRequirement = BunnyRequirement.init(requirementString) else {
            fatalError("Bunny requirement ID \(requirementString) not found")
        }
        self.rawRequirement = bunnyRequirement.rawValue

        self.rawPawn = json.pawn.map(\.rawValue)
        self.dice = json.dice?.compactMap(Die.init) ?? []
        self.symbols = json.symbols?.compactMap(Symbol.init) ?? []
    }

    /**
     Handles initializing, inserting, and defining relationships for a new Card model object.

     Although no relationships are currently used in the Card model, they should be initialized after the model's insertion into the database.
     */
    @discardableResult
    @MainActor
    static func create(json: JSONCard, context: ModelContext) -> Card {
        let card = Card(json: json)
        context.insert(card)

        // Define relationships here (post-insertion), as necessary

        return card
    }
}
