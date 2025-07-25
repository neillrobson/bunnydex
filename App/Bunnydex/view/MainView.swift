//
//  MainView.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/25/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Browse", systemImage: "list.bullet.rectangle.portrait")
                }
            InfoView()
                .tabItem {
                    Label("About", systemImage: "info")
                }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(appContainer)
}
