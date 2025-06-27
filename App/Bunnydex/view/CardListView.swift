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

    init(searchFilter: String = "", path: Binding<NavigationPath>, decks: Set<Deck> = [], types: Set<CardType> = [], requirements: Set<BunnyRequirement> = [], pawns: Set<Pawn> = [], dice: Set<Die> = [], symbols: Set<Symbol> = []) {
        self.searchFilter = searchFilter

        let predicate = predicateBuilder(searchFilter: searchFilter, decks: decks, types: types, requirements: requirements, pawns: pawns, dice: dice, symbols: symbols)

        _cards = Query(filter: predicate, sort: [SortDescriptor(\.rawDeck), SortDescriptor(\.id)])

        _path = path
    }

    var body: some View {
        List {
            ForEach(cards) { card in
                NavigationLink("\(card.id) — \(card.title)", value: JSONCard(card))
            }
        }
        .navigationTitle("Cards")
        .navigationDestination(for: JSONCard.self) { card in
            CardDetailView(card: card, path: $path)
        }
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

#Preview("Search") {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardListView(searchFilter: "carrot", path: $path)
    }
    .modelContainer(previewContainer)
}

#Preview("Empty search") {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardListView(searchFilter: "does not exist", path: $path)
    }
    .modelContainer(previewContainer)
}

#Preview("Filtered") {
    @Previewable @State var path = NavigationPath()
    let dice: Set<Die> = [.red]

    NavigationStack(path: $path) {
        CardListView(path: $path, dice: dice)
    }
    .modelContainer(previewContainer)
}

#Preview("Empty filtered") {
    @Previewable @State var path = NavigationPath()
    let dice: Set<Die> = [.red, .blueD10, .chineseZodiac]

    NavigationStack(path: $path) {
        CardListView(path: $path, dice: dice)
    }
    .modelContainer(previewContainer)
}
