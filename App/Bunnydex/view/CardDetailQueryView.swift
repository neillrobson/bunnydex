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
        if cards.isEmpty {
            ContentUnavailableView("Card does not exist", systemImage: "questionmark.text.page")
        } else {
            CardDetailView(card: cards.first!, path: $path)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardDetailQueryView(id: "0005", path: $path)
    }
    .modelContainer(previewContainer)
}

#Preview("Empty state") {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardDetailQueryView(id: "INVALID", path: $path)
    }
    .modelContainer(previewContainer)
}
