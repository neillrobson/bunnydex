//
//  CardDetailQueryView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/16/25.
//

import SwiftUI
import SwiftData

enum CardDetailError: Error {
    case notFound
}

struct CardDetailQueryView: View {
    @Binding var path: NavigationPath

    @Query private var cards: [CardModel]

    init(id: PersistentIdentifier, path: Binding<NavigationPath>) {
        self._path = path

        let predicate = #Predicate<CardModel> { $0.persistentModelID == id }
        _cards = Query(filter: predicate)
    }

    init(cardId: String, path: Binding<NavigationPath>) {
        self._path = path

        let predicate = #Predicate<CardModel> { $0.cardId == cardId }
        _cards = Query(filter: predicate)
    }

    var body: some View {
        if let card = cards.first {
            CardDetailView(card: card, path: $path)
        } else {
            ContentUnavailableView("Card does not exist", systemImage: "questionmark.text.page")
        }
    }
}

#Preview(traits: .modifier(SampleData())) {
    @Previewable @Query(filter: #Predicate<CardModel> { $0.cardId == "0185" }) var cards: [CardModel]
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardDetailQueryView(id: cards[0].id, path: $path)
            .navigationDestination(for: String.self) { cardId in
                CardDetailQueryView(cardId: cardId, path: $path)
            }
    }
}

#Preview("Empty state") {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardDetailQueryView(cardId: "Invalid", path: $path)
    }
    .modelContainer(previewContainer)
}
