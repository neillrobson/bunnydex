//
//  ContentView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/5/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showFilters: Bool = false

    @State private var cardPredicate = CardPredicate()
    @State private var expandState = FilterExpandState()
    @State private var path = NavigationPath()

    @State private var isCreatingDatabase = true

    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack(path: $path) {
            if isCreatingDatabase {
                ProgressView("Creating database")
            } else {
                CardListView(path: $path, cardFilter: $cardPredicate)
                    .searchable(text: $cardPredicate.searchFilter, prompt: "Search")
                .toolbar {
                    ToolbarItem {
                        Button {
                            print("Add card")
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showFilters.toggle()
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                    if !cardPredicate.decks.isEmpty
                        || !cardPredicate.types.isEmpty
                        || !cardPredicate.requirements.isEmpty
                        || !cardPredicate.pawns.isEmpty
                        || !cardPredicate.dice.isEmpty
                        || !cardPredicate.symbols.isEmpty
                    {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                cardPredicate.decks.removeAll()
                                cardPredicate.types.removeAll()
                                cardPredicate.requirements.removeAll()
                                cardPredicate.pawns.removeAll()
                                cardPredicate.dice.removeAll()
                                cardPredicate.symbols.removeAll()
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath.circle")
                            }
                        }
                    }
                }
            }
        }.sheet(isPresented: $showFilters) {
            FilterView(cardFilter: $cardPredicate, expandState: $expandState)
        }.task {
            isCreatingDatabase = true
            let fetcher = ThreadsafeBackgroundActor(modelContainer: context.container)
            await fetcher.initializeDatabase()
            isCreatingDatabase = false
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(appContainer)
}
