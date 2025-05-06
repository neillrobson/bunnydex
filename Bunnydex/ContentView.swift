//
//  ContentView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/5/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var cards: [Card]

    var body: some View {
        VStack {
            ForEach(cards) { card in
                Text(card.title)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(appContainer)
}
