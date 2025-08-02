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

    func fetchData(_ predicate: Predicate<CardModel>? = nil) throws -> [Card] {
        let descriptor = if let p = predicate {
            FetchDescriptor<CardModel>(predicate: p, sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.cardId)])
        } else {
            FetchDescriptor<CardModel>(sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.cardId)])
        }
        let cards = try context.fetch(descriptor)
        return cards.map(Card.init)
    }

    func initializeDatabase() {
        let descriptor = FetchDescriptor<CardModel>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        if count == 0 {
            resetDatabase()
        }
    }

    func resetDatabase() {
        resetDatabaseWith(context)
    }
}

func resetDatabaseWith(_ context: ModelContext) {
    let dice = dieMap(in: context)
    let symbols = symbolMap(in: context)

    do {
        try context.delete(model: CardModel.self)
    } catch {
        print("Error deleting cards: \(error)")
    }

    for json in getCardsFromJSON() {
        CardModel.create(json: json, context: context, dice: dice, symbols: symbols)
    }

    do {
        try context.save()
    } catch {
        print("Error saving database: \(error)")
    }
}
