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

    func fetchData() throws -> [JSONCard] {
        let descriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.id)])
        let cards = try context.fetch(descriptor)
        return cards.map(JSONCard.init)
    }

    func initializeDatabase() {
        let dice = dieMap(in: context)
        let symbols = symbolMap(in: context)

        // TODO: Consider how to intelligently persist data.
        // For now, just purge and recreate every time.
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
