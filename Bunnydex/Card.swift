//
//  Card.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/5/25.
//

import Foundation
import SwiftData
import SwiftUI

// TODO: Automate upper-snake-case raw-value generation
// https://stackoverflow.com/a/56672572/2977638
enum CardType: String, Codable {
    case run = "RUN",
    roamingRedRun = "ROAMING_RED_RUN",
    special = "SPECIAL",
    verySpecial = "VERY_SPECIAL",
    playImmediately = "PLAY_IMMEDIATELY",
    playRightNow = "PLAY_RIGHT_NOW",
    dolla = "DOLLA",
    bunnyBuck = "BUNNY_BUCK",
    starter = "STARTER",
    carrotSupply = "CARROT_SUPPLY",
    zodiac = "ZODIAC",
    chineseZodiac = "CHINESE_ZODIAC",
    rank = "RANK",
    mysteriousPlace = "MYSTERIOUS_PLACE",
    senator = "SENATOR",
    metal = "METAL",
    bundergroundStation = "BUNDERGROUND_STATION"
}

enum Deck: Int, LosslessStringConvertible {
    case blue, yellow, red, violet, orange, green, twilightWhite, stainlessSteel, perfectlyPink, wackyKhaki, ominousOnyx, chocolate, fantastic, caramelSwirl, creatureFeature, pumpkinSpice, conquestBlue, conquestYellow, conquestRed, conquestViolet, kinderSkyBlue, kinderSunshineYellow, laDiDaLondon, cakeBatter, radioactiveRobots, almondCrisp;

    init?(_ description: String) {
        switch description {
        case "BLUE": self = .blue
        case "YELLOW": self = .yellow
        case "RED": self = .red
        case "VIOLET": self = .violet
        case "ORANGE": self = .orange
        case "GREEN": self = .green
        case "TWILIGHT_WHITE": self = .twilightWhite
        case "STAINLESS_STEEL": self = .stainlessSteel
        case "PERFECTLY_PINK": self = .perfectlyPink
        case "WACKY_KHAKI": self = .wackyKhaki
        case "OMINOUS_ONYX": self = .ominousOnyx
        case "CHOCOLATE": self = .chocolate
        case "FANTASTIC": self = .fantastic
        case "CARAMEL_SWIRL": self = .caramelSwirl
        case "CREATURE_FEATURE": self = .creatureFeature
        case "PUMPKIN_SPICE": self = .pumpkinSpice
        case "CONQUEST_BLUE": self = .conquestBlue
        case "CONQUEST_YELLOW": self = .conquestYellow
        case "CONQUEST_RED": self = .conquestRed
        case "CONQUEST_VIOLET": self = .conquestViolet
        case "KINDER_SKY_BLUE": self = .kinderSkyBlue
        case "KINDER_SUNSHINE_YELLOW": self = .kinderSunshineYellow
        case "LA_DI_DA_LONDON": self = .laDiDaLondon
        case "CAKE_BATTER": self = .cakeBatter
        case "RADIOACTIVE_ROBOTS": self = .radioactiveRobots
        case "ALMOND_CRISP": self = .almondCrisp
        default: return nil
        }
    }

    var description: String {
        switch self {
        case .blue: return "BLUE"
        case .yellow: return "YELLOW"
        case .red: return "RED"
        case .violet: return "VIOLET"
        case .orange: return "ORANGE"
        case .green: return "GREEN"
        case .twilightWhite: return "TWILIGHT_WHITE"
        case .stainlessSteel: return "STAINLESS_STEEL"
        case .perfectlyPink: return "PERFECTLY_PINK"
        case .wackyKhaki: return "WACKY_KHAKI"
        case .ominousOnyx: return "OMINOUS_ONYX"
        case .chocolate: return "CHOCOLATE"
        case .fantastic: return "FANTASTIC"
        case .caramelSwirl: return "CARAMEL_SWIRL"
        case .creatureFeature: return "CREATURE_FEATURE"
        case .pumpkinSpice: return "PUMPKIN_SPICE"
        case .conquestBlue: return "CONQUEST_BLUE"
        case .conquestYellow: return "CONQUEST_YELLOW"
        case .conquestRed: return "CONQUEST_RED"
        case .conquestViolet: return "CONQUEST_VIOLET"
        case .kinderSkyBlue: return "KINDER_SKY_BLUE"
        case .kinderSunshineYellow: return "KINDER_SUNSHINE_YELLOW"
        case .laDiDaLondon: return "LA_DI_DA_LONDON"
        case .cakeBatter: return "CAKE_BATTER"
        case .radioactiveRobots: return "RADIOACTIVE_ROBOTS"
        case .almondCrisp: return "ALMOND_CRISP"
        }
    }

    var isKinder: Bool {
        switch self {
        case .kinderSkyBlue, .kinderSunshineYellow: return true
        default: return false
        }
    }
}

enum BunnyRequirement: String, Codable {
    case no = "NO",
         play = "PLAY",
         playX2 = "PLAY_X2",
         playAndSave = "PLAY_AND_SAVE"

    init(from decoder: any Decoder) throws {
        self = try BunnyRequirement(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .no
    }
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

enum Pawn: String, Codable {
    case blue = "BLUE",
         yellow = "YELLOW",
         violet = "VIOLET",
         orange = "ORANGE",
         green = "GREEN",
         red = "RED",
         pink = "PINK",
         black = "BLACK",
         brown = "BROWN"
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
    var type: CardType
    var rawDeck: Int
    var bunnyRequirement: BunnyRequirement
    var dice: [Die]?
    var pawn: Pawn?
    var rules: [Rule]?

    var deck: Deck {
        return .init(rawValue: rawDeck)!
    }

    init(id: String, title: String, type: CardType, rawDeck: Int, bunnyRequirement: BunnyRequirement, dice: [Die]?, rules: [Rule]?) {
        self.id = id
        self.title = title
        self.type = type
        self.rawDeck = 0
        self.bunnyRequirement = bunnyRequirement
        self.dice = dice
        self.rules = rules
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(CardType.self, forKey: .type)
        self.bunnyRequirement = try container.decodeIfPresent(BunnyRequirement.self, forKey: .bunnyRequirement) ?? .no
        self.dice = try container.decodeIfPresent([Die].self, forKey: .dice)
        self.pawn = try container.decodeIfPresent(Pawn.self, forKey: .pawn)
        self.rules = try container.decodeIfPresent([Rule].self, forKey: .rules)

        let deckId = try container.decode(String.self, forKey: .deck)
        let deck = Deck.init(deckId)!
        self.rawDeck = deck.rawValue
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        try container.encode(deck.description, forKey: .deck)
        try container.encode(bunnyRequirement, forKey: .bunnyRequirement)
        try container.encodeIfPresent(dice, forKey: .dice)
        try container.encodeIfPresent(pawn, forKey: .pawn)
        try container.encodeIfPresent(rules, forKey: .rules)
    }

    static let placeholder = Card(
        id: "0000",
        title: "Placeholder Card",
        type: .run,
        rawDeck: Deck.blue.rawValue,
        bunnyRequirement: .no,
        dice: [.violet, .orange, .green, .yellow, .blue, .pink, .black, .red, .brown, .clear, .violetD10, .orangeD10, .greenD10, .yellowD10, .blueD10, .zodiac, .chineseZodiac],
        rules: []
    )
}
