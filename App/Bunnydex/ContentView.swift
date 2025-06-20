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

    @State private var expandState: FilterExpandState = .init()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            CardListView(searchFilter: searchText, path: $path, decks: decks, types: cardTypes, requirements: bunnyRequirements, pawns: pawns)
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
            FilterView(deckSelection: $decks, typeSelection: $cardTypes, requirementSelection: $bunnyRequirements, pawnSelection: $pawns, expandState: $expandState)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
