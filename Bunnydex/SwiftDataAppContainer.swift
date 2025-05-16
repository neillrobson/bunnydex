//
//  SwiftDataAppContainer.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/6/25.
//

import Foundation
import SwiftData

let CARDS: [Card] = {
    do {
        guard let url = Bundle.main.url(forResource: "01_deck_blue", withExtension: "json", subdirectory: "data") else {
            fatalError("Failed to find 01_deck_blue.json")
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Card].self, from: data)
    } catch {
        fatalError("Failed to read JSON file: \(error)")
    }
}()

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Card.self)

        var itemFetchDescriptor = FetchDescriptor<Card>()
        itemFetchDescriptor.fetchLimit = 1

        // TODO: Determine how to intelligently pre-load or re-load the database
//        guard try container.mainContext.fetchCount(itemFetchDescriptor) == 0 else {
//            return container
//        }

        try container.mainContext.delete(model: Card.self)

        for card in CARDS {
            container.mainContext.insert(card)
        }

        return container
    } catch {
        fatalError("Failed to create container: \(error)")
    }
}()
