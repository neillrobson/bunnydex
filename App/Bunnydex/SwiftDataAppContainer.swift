//
//  SwiftDataAppContainer.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/6/25.
//

import Foundation
import SwiftData

func getCardsFromJSON() -> [Card] {
    do {
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "data") else {
            fatalError("No data files found in bundle")
        }

        return try urls.flatMap { url in
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Card].self, from: data)
        }
    } catch {
        fatalError("Failed to read JSON file: \(error)")
    }
}

@MainActor
func resetData(_ context: ModelContext) {
    do {
        try context.delete(model: Card.self)
    } catch {
        print("Failed to delete existing data: \(error)")
    }

    for card in getCardsFromJSON() {
        context.insert(card)
    }
}

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Card.self)
        let hasLoadedData = UserDefaults.standard.bool(forKey: "hasLoadedData")

        if !hasLoadedData {
            resetData(container.mainContext)
            UserDefaults.standard.set(true, forKey: "hasLoadedData")
        }

        return container
    } catch {
        fatalError("Failed to create container: \(error)")
    }
}()
