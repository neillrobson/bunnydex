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
            var cards = try JSONDecoder().decode([Card].self, from: data)

            for c in cards.indices {
                guard let rules = cards[c].rules else { continue }
                for r in rules.indices {
                    var doc = BasicHTML(rawHTML: rules[r].text)
                    try doc.parse()
                    cards[c].rules![r].text = try doc.asMarkdown().trim()
                }
            }

            return cards
        }
    } catch {
        fatalError("Failed to read JSON file: \(error)")
    }
}

let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: CardModel.self)

        return container
    } catch {
        fatalError("Failed to create container: \(error)")
    }
}()

let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: CardModel.self)

        Task {
            let fetcher = ThreadsafeBackgroundActor(modelContainer: container)
            await fetcher.resetDatabase()
        }

        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
