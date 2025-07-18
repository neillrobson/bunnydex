//
//  Symbol.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/20/25.
//

import SwiftData
import SwiftUI
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

extension Symbol: Hashable {
    var hashValue: Int { rawValue }
}

@Model
class SymbolModel {
    var id: Int
    var cards: [CardModel] = []

    init(_ symbol: Symbol) {
        id = symbol.rawValue
    }

    var symbol: Symbol {
        .init(rawValue: id)!
    }
}

extension SymbolModel: Hashable {
    var hashValue: Int { id }
}

func symbolMap(in context: ModelContext) -> [Symbol: SymbolModel] {
    Symbol.allCases.reduce(into: [Symbol: SymbolModel]()) {
        let id = $1.rawValue
        let fetchDescriptor = FetchDescriptor<SymbolModel>(predicate: #Predicate { $0.id == id })
        if let model = try? context.fetch(fetchDescriptor).first {
            $0[$1] = model
        } else {
            let newModel = SymbolModel($1)
            context.insert(newModel)
            $0[$1] = newModel
        }
    }
}
