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
    dolla = "DOLLA",
    starter = "STARTER",
    carrotSupply = "CARROT_SUPPLY"
}

enum Deck: String, Codable {
    case blue = "BLUE"
}

enum BunnyRequirement: String, Codable {
    case no = "NO",
         play = "PLAY"
}

@Model
class Card: Codable {
    struct Rule: Codable {
        var title: String
        var text: String
    }

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
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(CardType.self, forKey: .type)
        self.deck = try container.decode(Deck.self, forKey: .deck)
        self.bunnyRequirement = try container.decode(BunnyRequirement.self, forKey: .bunnyRequirement)
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
