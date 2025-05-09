//
//  ContentView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/5/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Card.id) var cards: [Card]

    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(cards.filter {
                    searchText.isEmpty || $0.title.lowercased().contains(searchText.lowercased())
                }) { card in
                    NavigationLink(card.title) {
                        CardDetailView(card: card)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            .navigationTitle("Cards")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(appContainer)
}
