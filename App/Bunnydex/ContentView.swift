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
    @State private var searchText: String = ""
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            CardListView(searchFilter: searchText, path: $path)
            .searchable(text: $searchText, prompt: "Search")
            .toolbar {
                ToolbarItem {
                    Button {
                        showInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }.sheet(isPresented: $showInfo) {
            InfoView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(appContainer)
}
