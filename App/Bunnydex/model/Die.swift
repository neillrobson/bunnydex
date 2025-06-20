//
//  Die.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/18/25.
//

import SwiftData
import SwiftUI
import EnumStringConvertible

@enumStringConvertible
enum DieType: Int, CaseIterable {
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

@Model
class Die {
    var id: Int
    var cards: [Card] = []

    init(type: DieType) {
        self.id = type.rawValue
    }

    var dieType: DieType {
        get { DieType(rawValue: id)! }
        set { id = newValue.rawValue }
    }
}

@MainActor
final class DiceRepository {
    static let shared = DiceRepository()

    private(set) var diceMap: [DieType: Die] = [:]

    func ensureDiceExist(in context: ModelContext) throws {
        var didInsert = false

        for type in DieType.allCases {
            let id = type.rawValue
            let fetchDescriptor = FetchDescriptor<Die>(predicate: #Predicate { $0.id == id })
            if let existing = try? context.fetch(fetchDescriptor).first {
                diceMap[type] = existing
            } else {
                let newDie = Die(type: type)
                context.insert(newDie)
                diceMap[type] = newDie
                didInsert = true
            }
        }

        if didInsert {
            try context.save()
        }
    }
}
