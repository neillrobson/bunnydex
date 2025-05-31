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

// TODO: Implement LosslessStringConvertible so that we can use Int RawValues for sorting
enum Deck: String, Codable {
    case blue = "BLUE"
    case yellow = "YELLOW"
    case red = "RED"
    case violet = "VIOLET"
    case orange = "ORANGE"
    case green = "GREEN"
    case twilightWhite = "TWILIGHT_WHITE"
    case stainlessSteel = "STAINLESS_STEEL"
    case perfectlyPink = "PERFECTLY_PINK"
    case wackyKhaki = "WACKY_KHAKI"
    case ominousOnyx = "OMINOUS_ONYX"
    case chocolate = "CHOCOLATE"
    case fantastic = "FANTASTIC"
    case caramelSwirl = "CARAMEL_SWIRL"
    case creatureFeature = "CREATURE_FEATURE"
    case pumpkinSpice = "PUMPKIN_SPICE"
    case conquestBlue = "CONQUEST_BLUE"
    case conquestYellow = "CONQUEST_YELLOW"
    case conquestRed = "CONQUEST_RED"
    case conquestViolet = "CONQUEST_VIOLET"
    case kinderSkyBlue = "KINDER_SKY_BLUE"
    case kinderSunshineYellow = "KINDER_SUNSHINE_YELLOW"
    case laDiDaLondon = "LA_DI_DA_LONDON"
    case cakeBatter = "CAKE_BATTER"
    case radioactiveRobots = "RADIOACTIVE_ROBOTS"
    case almondCrisp = "ALMOND_CRISP"
}

extension String {
    var deck: Deck {
        .init(rawValue: self) ?? .blue
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
        rules,
        deckSort
    }

    var id: String
    var title: String
    var type: CardType
    var deck: Deck
    var bunnyRequirement: BunnyRequirement
    var dice: [Die]?
    var pawn: Pawn?
    var rules: [Rule]?

    var deckSort: Int {
        switch deck {
        case .blue: return 0
        case .yellow: return 1
        case .red: return 2
        case .violet: return 3
        case .orange: return 4
        case .green: return 5
        case .twilightWhite: return 6
        case .stainlessSteel: return 7
        case .perfectlyPink: return 8
        case .wackyKhaki: return 9
        case .kinderSkyBlue: return 10
        case .kinderSunshineYellow: return 11
        case .ominousOnyx: return 12
        case .chocolate: return 13
        case .conquestBlue: return 14
        case .conquestYellow: return 15
        case .conquestRed: return 16
        case .conquestViolet: return 17
        case .fantastic: return 18
        case .caramelSwirl: return 19
        case .creatureFeature: return 20
        case .pumpkinSpice: return 21
        case .laDiDaLondon: return 22
        case .cakeBatter: return 23
        case .radioactiveRobots: return 24
        case .almondCrisp: return 25
        }
    }

    init(id: String, title: String, type: CardType, deck: Deck, bunnyRequirement: BunnyRequirement, dice: [Die]?, rules: [Rule]?) {
        self.id = id
        self.title = title
        self.type = type
        self.deck = deck
        self.bunnyRequirement = bunnyRequirement
        self.dice = dice
        self.rules = rules
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(CardType.self, forKey: .type)
        self.deck = try container.decode(Deck.self, forKey: .deck)
        self.bunnyRequirement = try container.decodeIfPresent(BunnyRequirement.self, forKey: .bunnyRequirement) ?? .no
        self.dice = try container.decodeIfPresent([Die].self, forKey: .dice)
        self.pawn = try container.decodeIfPresent(Pawn.self, forKey: .pawn)
        self.rules = try container.decodeIfPresent([Rule].self, forKey: .rules)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        try container.encode(deck, forKey: .deck)
        try container.encode(bunnyRequirement, forKey: .bunnyRequirement)
        try container.encodeIfPresent(dice, forKey: .dice)
        try container.encodeIfPresent(pawn, forKey: .pawn)
        try container.encodeIfPresent(rules, forKey: .rules)
    }

    static let placeholder = Card(
        id: "0000",
        title: "Placeholder Card",
        type: .run,
        deck: .blue,
        bunnyRequirement: .no,
        dice: [.violet, .orange, .green, .yellow, .blue, .pink, .black, .red, .brown, .clear, .violetD10, .orangeD10, .greenD10, .yellowD10, .blueD10, .zodiac, .chineseZodiac],
        rules: []
    )
}
