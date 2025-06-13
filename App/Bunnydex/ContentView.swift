//
//  ContentView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/5/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showInfo: Bool = false
    @State private var showFilters: Bool = false
    @State private var searchText: String = ""
    @State private var decks: Set<Deck> = []
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            CardListView(searchFilter: searchText, path: $path, decks: decks)
            .searchable(text: $searchText, prompt: "Search")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                ToolbarItem {
                    Button {
                        showFilters.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }.sheet(isPresented: $showInfo) {
            InfoView()
        }.sheet(isPresented: $showFilters) {
            FilterView(deckSelection: $decks)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(appContainer)
}
