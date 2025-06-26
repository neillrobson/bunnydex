//
//  SwiftDataAppContainer.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/6/25.
//

import Foundation
import SwiftData

func getCardsFromJSON() -> [JSONCard] {
    do {
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "data") else {
            fatalError("No data files found in bundle")
        }

        return try urls.flatMap { url in
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([JSONCard].self, from: data)
        }
    } catch {
        fatalError("Failed to read JSON file: \(error)")
    }
}

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Card.self)

        return container
    } catch {
        fatalError("Failed to create container: \(error)")
    }
}()

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Card.self)

        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
