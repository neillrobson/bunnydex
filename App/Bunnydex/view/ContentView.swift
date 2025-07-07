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

    @StateObject private var cardPredicate = CardPredicate()

    @State private var expandState: FilterExpandState = .init()
    @State private var path = NavigationPath()

    @State private var isCreatingDatabase = true

    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack(path: $path) {
            if isCreatingDatabase {
                ProgressView("Creating database")
            } else {
                CardListView(path: $path, cardFilter: cardPredicate)
                    .searchable(text: $cardPredicate.searchFilter, prompt: "Search")
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
            FilterView(cardFilter: cardPredicate, expandState: $expandState)
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
