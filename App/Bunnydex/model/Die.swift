//
//  Die.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/18/25.
//

import SwiftUI
import EnumStringConvertible

@enumStringConvertible
enum Die: Int, Codable, CaseIterable {
    case blue,
         yellow,
         violet,
         orange,
         green,
         red,
         pink,
         black,
         clear,
         brown,
         blueD10,
         yellowD10,
         violetD10,
         orangeD10,
         greenD10,
         zodiac,
         chineseZodiac

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        self = .init(str)!
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }

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

extension Die: Identifiable {
    var id: Self { self }
}
