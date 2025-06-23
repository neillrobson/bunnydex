//
//  Symbol.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/20/25.
//

import EnumStringConvertible

@enumStringConvertible
enum Symbol: Int, Codable, CaseIterable {
    case jupiter,
         mysteriousPlaceBall

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        self = .init(str)!
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension Symbol: Identifiable {
    var id: Self { self }
}
