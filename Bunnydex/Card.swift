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
    enum CodingKeys: CodingKey {
        case id,
        title,
        type,
        deck,
        bunnyRequirement
    }

    var id: String
    var title: String
    var type: CardType
    var deck: Deck
    var bunnyRequirement: BunnyRequirement

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(CardType.self, forKey: .type)
        self.deck = try container.decode(Deck.self, forKey: .deck)
        self.bunnyRequirement = try container.decode(BunnyRequirement.self, forKey: .bunnyRequirement)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        try container.encode(deck, forKey: .deck)
        try container.encode(bunnyRequirement, forKey: .bunnyRequirement)
    }
}
