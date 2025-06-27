//
//  ThreadsafeBackgroundActor.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/23/25.
//

import SwiftData
import Foundation

@ModelActor
actor ThreadsafeBackgroundActor: Sendable {
    private var context: ModelContext { modelExecutor.modelContext }

    func fetchData(_ predicate: Predicate<Card>? = nil) throws -> [JSONCard] {
        let descriptor = if let p = predicate {
            FetchDescriptor<Card>(predicate: p, sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.id)])
        } else {
            FetchDescriptor<Card>(sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.id)])
        }
        let cards = try context.fetch(descriptor)
        return cards.map(JSONCard.init)
    }

    func initializeDatabase() {
        let descriptor = FetchDescriptor<Card>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        if count == 0 {
            resetDatabase()
        }
    }

    func resetDatabase() {
        let dice = dieMap(in: context)
        let symbols = symbolMap(in: context)

        do {
            try context.delete(model: Card.self)
        } catch {
            print("Error deleting cards: \(error)")
        }

        for json in getCardsFromJSON() {
            Card.create(json: json, context: context, dice: dice, symbols: symbols)
        }

        do {
            try context.save()
        } catch {
            print("Error saving database: \(error)")
        }
    }
}
