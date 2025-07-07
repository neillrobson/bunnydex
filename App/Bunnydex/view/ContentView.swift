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
    @State private var cardTypes: Set<CardType> = []
    @State private var bunnyRequirements: Set<BunnyRequirement> = []
    @State private var pawns: Set<Pawn> = []
    @State private var dice: Set<Die> = []
    @State private var symbols: Set<Symbol> = []

    private var predicate: Predicate<Card> {
        predicateBuilder(searchFilter: searchText, decks: decks, types: cardTypes, requirements: bunnyRequirements, pawns: pawns, dice: dice, symbols: symbols)
    }

    @State private var expandState: FilterExpandState = .init()
    @State private var path = NavigationPath()

    @State private var isCreatingDatabase = true

    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack(path: $path) {
            if isCreatingDatabase {
                ProgressView("Creating database")
            } else {
                CardListView(searchFilter: searchText, path: $path, predicate: predicate)
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
            }
        }.sheet(isPresented: $showInfo) {
            InfoView()
        }.sheet(isPresented: $showFilters) {
            FilterView(deckSelection: $decks, typeSelection: $cardTypes, requirementSelection: $bunnyRequirements, pawnSelection: $pawns, diceSelection: $dice, symbolSelection: $symbols, expandState: $expandState)
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
