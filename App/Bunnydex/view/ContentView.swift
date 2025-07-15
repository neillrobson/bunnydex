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
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showInfo.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                        }
                    }
                    if !cardPredicate.decks.isEmpty
                        || !cardPredicate.types.isEmpty
                        || !cardPredicate.requirements.isEmpty
                        || !cardPredicate.pawns.isEmpty
                        || !cardPredicate.dice.isEmpty
                        || !cardPredicate.symbols.isEmpty
                    {
                        ToolbarItem {
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
                    ToolbarItem {
                        Button {
                            showFilters.toggle()
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
            }
        }.sheet(isPresented: $showInfo) {
            InfoView()
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
