//
//  Enums.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/5/25.
//

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
