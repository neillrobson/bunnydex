//
//  CardListView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/9/25.
//

import SwiftUI
import SwiftData

struct CardListView: View {
    @Query private var cards: [Card]
    @Binding var path: NavigationPath

    private let searchFilter: String

    init(searchFilter: String = "", path: Binding<NavigationPath>, predicate: Predicate<Card> = .true) {
        self.searchFilter = searchFilter

        _cards = Query(filter: predicate, sort: [SortDescriptor(\.rawDeck), SortDescriptor(\.id)])

        _path = path
    }

    var body: some View {
        List {
            ForEach(cards) { card in
                NavigationLink("\(card.id) — \(card.title)", value: card.id)
            }
        }
        .navigationTitle("Cards")
        .navigationDestination(for: String.self) { id in
            CardDetailQueryView(id: id, path: $path)
        }
        .overlay {
            if cards.isEmpty {
                if searchFilter.isEmpty {
                    ContentUnavailableView("No Cards found", systemImage: "magnifyingglass", description: Text("Try adjusting your filters."))
                } else {
                    ContentUnavailableView.search(text: searchFilter)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardListView(path: $path)
    }
    .modelContainer(previewContainer)
}

#Preview("Empty search") {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardListView(searchFilter: "does not exist", path: $path, predicate: .false)
    }
    .modelContainer(previewContainer)
}

#Preview("Filtered") {
    @Previewable @State var path = NavigationPath()
    let dice: Set<Die> = [.red]
    let predicate = predicateBuilder(dice: dice)

    NavigationStack(path: $path) {
        CardListView(path: $path, predicate: predicate)
    }
    .modelContainer(previewContainer)
}

#Preview("Empty filtered") {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardListView(path: $path, predicate: .false)
    }
    .modelContainer(previewContainer)
}
