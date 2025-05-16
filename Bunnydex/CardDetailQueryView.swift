//
//  CardDetailQueryView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/16/25.
//

import SwiftUI
import SwiftData

struct CardDetailQueryView: View {
    @Query private var cards: [Card]
    @Binding var path: NavigationPath

    init(id: String, path: Binding<NavigationPath>) {
        let predicate = #Predicate<Card> { card in
            card.id == id
        }

        _cards = Query(filter: predicate, sort: \Card.id)

        self._path = path
    }

    var body: some View {
        CardDetailView(card: cards.first ?? .placeholder, path: $path)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardDetailQueryView(id: "0005", path: $path)
    }
    .modelContainer(appContainer)
}
