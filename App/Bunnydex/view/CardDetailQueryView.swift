//
//  CardDetailQueryView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/16/25.
//

import SwiftUI
import SwiftData

enum CardDetailError: Error {
    case notFound
}

struct CardDetailQueryView: View {
    @Binding var path: NavigationPath

    @Query private var cards: [CardModel]

    init(id: String, path: Binding<NavigationPath>) {
        self._path = path

        let predicate = #Predicate<CardModel> { $0.id == id }
        _cards = Query(filter: predicate)
    }

    var body: some View {
        if let card = cards.first {
            CardDetailView(card: card, path: $path)
        } else {
            ContentUnavailableView("Card does not exist", systemImage: "questionmark.text.page")
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
