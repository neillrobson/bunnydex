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
enum CardType: Int, LosslessStringConvertible, CaseIterable {
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
}

extension CardType: Identifiable {
    var id: Self { self }
}

@enumStringConvertible
enum Deck: Int, LosslessStringConvertible, CaseIterable {
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

enum Die: String, Codable {
    case blue = "BLUE",
         yellow = "YELLOW",
         violet = "VIOLET",
         orange = "ORANGE",
         green = "GREEN",
         red = "RED",
         pink = "PINK",
         black = "BLACK",
         clear = "CLEAR",
         brown = "BROWN",
         blueD10 = "BLUE_D10",
         yellowD10 = "YELLOW_D10",
         violetD10 = "VIOLET_D10",
         orangeD10 = "ORANGE_D10",
         greenD10 = "GREEN_D10",
         zodiac = "ZODIAC",
         chineseZodiac = "CHINESE_ZODIAC"

    var systemImageName: String {
        switch self {
        case .clear:
            return "20.square"
        case .blueD10, .yellowD10, .violetD10, .orangeD10, .greenD10:
            return "10.square.fill"
        case .zodiac:
            return "z.square.fill"
        case .chineseZodiac:
            return "c.square.fill"
        default:
            return "12.square.fill"
        }
    }

    var color: Color {
        switch self {
        case .blue, .blueD10:
            return .blue
        case .yellow, .yellowD10:
            return .yellow
        case .green, .greenD10:
            return .green
        case .violet, .violetD10:
            return .purple
        case .orange, .orangeD10:
            return .orange
        case .red:
            return .red
        case .pink:
            return .init(hue: 0.9, saturation: 0.5, brightness: 1.0)
        case .brown:
            return .init(hue: 0.1, saturation: 0.9, brightness: 0.75)
        case .black:
            return .black
        default:
            return .gray
        }
    }
}

@enumStringConvertible
enum Pawn: Int, Codable, CaseIterable {
    case blue, yellow, violet, orange, green, red, pink, black, brown
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

@Model
class Card: Codable {
    enum CodingKeys: CodingKey {
        case id,
        title,
        type,
        deck,
        bunnyRequirement,
        dice,
        pawn,
        rules
    }

    var id: String
    var title: String
    var rawType: Int
    var rawDeck: Int
    var rawPawn: Int?
    var rawRequirement: Int
    var dice: [Die]?
    var rules: [Rule]?

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

    init(id: String, title: String, type: Int, rawDeck: Int, bunnyRequirement: Int, dice: [Die]?, rules: [Rule]?) {
        self.id = id
        self.title = title
        self.rawType = type
        self.rawDeck = 0
        self.rawRequirement = bunnyRequirement
        self.dice = dice
        self.rules = rules
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.dice = try container.decodeIfPresent([Die].self, forKey: .dice)
        self.rules = try container.decodeIfPresent([Rule].self, forKey: .rules)

        let typeId = try container.decode(String.self, forKey: .type)
        guard let type = CardType.init(typeId) else {
            fatalError("Type ID \(typeId) not found")
        }
        self.rawType = type.rawValue

        let deckId = try container.decode(String.self, forKey: .deck)
        guard let deck = Deck.init(deckId) else {
            fatalError("Deck ID \(deckId) not found")
        }
        self.rawDeck = deck.rawValue

        self.rawRequirement = 0
        let requirementId = try container.decodeIfPresent(String.self, forKey: .bunnyRequirement)
        requirementId.map { requirementId in
            guard let bunnyRequirement = BunnyRequirement.init(requirementId) else {
                fatalError("Bunny requirement ID \(requirementId) not found")
            }

            self.rawRequirement = bunnyRequirement.rawValue
        }

        let pawnId = try container.decodeIfPresent(String.self, forKey: .pawn)
        pawnId.map { pawnId in
            guard let pawn = Pawn.init(pawnId) else {
                fatalError("Pawn ID \(pawnId) not found")
            }
            self.rawPawn = pawn.rawValue
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(type.description, forKey: .type)
        try container.encode(deck.description, forKey: .deck)
        try container.encode(bunnyRequirement.description, forKey: .bunnyRequirement)
        try container.encodeIfPresent(dice, forKey: .dice)
        try container.encodeIfPresent(pawn, forKey: .pawn)
        try container.encodeIfPresent(rules, forKey: .rules)
    }

    @MainActor static let placeholder = Card(
        id: "0000",
        title: "Placeholder Card",
        type: CardType.run.rawValue,
        rawDeck: Deck.blue.rawValue,
        bunnyRequirement: BunnyRequirement.no.rawValue,
        dice: [.violet, .orange, .green, .yellow, .blue, .pink, .black, .red, .brown, .clear, .violetD10, .orangeD10, .greenD10, .yellowD10, .blueD10, .zodiac, .chineseZodiac],
        rules: []
    )
}
