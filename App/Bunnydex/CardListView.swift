//
//  CardListView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/9/25.
//

import SwiftUI
import SwiftData

struct CardListView: View {
    @Query private var cards: [Card]
    @Binding var path: NavigationPath

    init(searchFilter: String = "", path: Binding<NavigationPath>, decks: Set<Deck> = []) {
        let rawDecks = decks.map(\.rawValue)
        let predicate = #Predicate<Card> { card in
            (searchFilter.isEmpty || card.title.localizedStandardContains(searchFilter) || card.id == searchFilter) &&
            (rawDecks.isEmpty || rawDecks.contains(card.rawDeck))
        }

        _cards = Query(filter: predicate, sort: [SortDescriptor(\.rawDeck), SortDescriptor(\.id)])

        _path = path
    }

    var body: some View {
        List {
            ForEach(cards) { card in
                NavigationLink("\(card.id) — \(card.title)", value: card)
            }
        }
        .navigationTitle("Cards")
        .navigationDestination(for: Card.self) { card in
            CardDetailView(card: card, path: $path)
        }
        .navigationDestination(for: String.self) { id in
            CardDetailQueryView(id: id, path: $path)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardListView(path: $path)
    }
    .modelContainer(appContainer)
}

#Preview("Filtered") {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardListView(searchFilter: "carrot", path: $path)
    }
    .modelContainer(appContainer)
}
