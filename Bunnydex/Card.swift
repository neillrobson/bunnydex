//
//  Card.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/5/25.
//

import Foundation
import SwiftData

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
    bunderground = "BUNDERGROUND"
}

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
    case kinderBlue = "KINDER_BLUE"
    case kinderYellow = "KINDER_YELLOW"
    case ladidaLondon = "LA-DI-DA_LONDON"
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

struct Rule: Codable {
    var title: String
    var text: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        let rawText = try container.decode(String.self, forKey: .text)

        let regex = "<a href=\"(.+?)\">(.+?)<\\/a>"
        let repl = "[$2]($1)"

        self.text = rawText.replacingOccurrences(of: regex, with: repl, options: .regularExpression)
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
        rules
    }

    var id: String
    var title: String
    var type: CardType
    var deck: Deck
    var bunnyRequirement: BunnyRequirement
    var rules: [Rule]?

    init(id: String, title: String, type: CardType, deck: Deck, bunnyRequirement: BunnyRequirement, rules: [Rule]?) {
        self.id = id
        self.title = title
        self.type = type
        self.deck = deck
        self.bunnyRequirement = bunnyRequirement
        self.rules = rules
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try container.decode(String.self, forKey: .id)
        } catch DecodingError.typeMismatch {
            let intId = try container.decode(Int.self, forKey: .id)
            self.id = String(intId)
        }
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(CardType.self, forKey: .type)
        self.deck = try container.decode(Deck.self, forKey: .deck)
        self.bunnyRequirement = try container.decodeIfPresent(BunnyRequirement.self, forKey: .bunnyRequirement) ?? .no
        self.rules = try container.decodeIfPresent([Rule].self, forKey: .rules)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        try container.encode(deck, forKey: .deck)
        try container.encode(bunnyRequirement, forKey: .bunnyRequirement)
        try container.encodeIfPresent(rules, forKey: .rules)
    }

    static let placeholder = Card(
        id: "0000",
        title: "Placeholder Card",
        type: .run,
        deck: .blue,
        bunnyRequirement: .no,
        rules: []
    )
}
