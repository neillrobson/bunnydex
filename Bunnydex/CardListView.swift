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

    init(searchFilter: String = "") {
        let predicate = #Predicate<Card> { card in
            searchFilter.isEmpty || card.title.localizedStandardContains(searchFilter)
        }

        _cards = Query(filter: predicate, sort: \Card.id)
    }

    var body: some View {
        List {
            ForEach(cards) { card in
                NavigationLink(card.title) {
                    CardDetailView(card: card)
                }
            }
        }
        .navigationTitle("Cards")
    }
}

#Preview {
    NavigationStack {
        CardListView()
            .modelContainer(appContainer)
    }
}

#Preview("Filtered") {
    NavigationStack {
        CardListView(searchFilter: "carrot")
            .modelContainer(appContainer)
    }
}
