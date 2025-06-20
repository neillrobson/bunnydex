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
}

extension Symbol: Identifiable {
    var id: Self { self }
}
