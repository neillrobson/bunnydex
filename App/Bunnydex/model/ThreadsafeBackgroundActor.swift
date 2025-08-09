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

    func fetchExperiment(_ predicate: Predicate<CardModel>? = nil) -> AsyncStream<[CardView]> {
        let descriptor = if let p = predicate {
            FetchDescriptor<CardModel>(predicate: p, sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.cardId)])
        } else {
            FetchDescriptor<CardModel>(sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.cardId)])
        }

        return AsyncStream { continuation in
            let task = Task {
                for await _ in NotificationCenter.default.notifications(named: .NSPersistentStoreRemoteChange
                ).map({ _ in () }) {
                    do {
                        let cards = try context.fetch(descriptor)
                        continuation.yield(cards.map(CardView.init))
                    } catch {
                        // TODO: figure out error handling
                    }
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }

            do {
                let cards = try context.fetch(descriptor)
                continuation.yield(cards.map(CardView.init))
            } catch {
                // TODO: figure out error handling
            }
        }
    }

    func fetchData(_ predicate: Predicate<CardModel>? = nil) throws -> [CardView] {
        let descriptor = if let p = predicate {
            FetchDescriptor<CardModel>(predicate: p, sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.cardId)])
        } else {
            FetchDescriptor<CardModel>(sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.cardId)])
        }
        let cards = try context.fetch(descriptor)
        return cards.map(CardView.init)
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
