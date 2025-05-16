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

    init(searchFilter: String = "", path: Binding<NavigationPath>) {
        let predicate = #Predicate<Card> { card in
            searchFilter.isEmpty || card.title.localizedStandardContains(searchFilter)
        }

        _cards = Query(filter: predicate, sort: \Card.id)

        _path = path
    }

    var body: some View {
        List {
            ForEach(cards) { card in
                NavigationLink(card.title, value: card)
            }
        }
        .navigationTitle("Cards")
        .navigationDestination(for: Card.self) { card in
            CardDetailView(card: card, path: $path)
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
