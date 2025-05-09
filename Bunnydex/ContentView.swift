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
            CardListView(searchFilter: searchText)
            .searchable(text: $searchText, prompt: "Search")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(appContainer)
}
