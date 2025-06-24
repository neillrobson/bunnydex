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

    func fetchData() async throws -> [JSONCard] {
        let descriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\.rawDeck), SortDescriptor(\.id)])
        let cards = try context.fetch(descriptor)
        return cards.map(JSONCard.init)
    }
}
