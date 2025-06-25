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
    private let dice: Set<Die>
    private let symbols: Set<Symbol>
    @State private var fetchedCards: [JSONCard] = []
    var filteredCards: [JSONCard] {
        return cards.map(JSONCard.init).filter { card in
            dice.isSubset(of: card.dice ?? []) &&
            symbols.isSubset(of: card.symbols ?? [])
        }
    }

    @Environment(\.modelContext) private var context
    @State var isFetchingCards = false

    init(searchFilter: String = "", path: Binding<NavigationPath>, decks: Set<Deck> = [], types: Set<CardType> = [], requirements: Set<BunnyRequirement> = [], pawns: Set<Pawn> = [], dice: Set<Die> = [], symbols: Set<Symbol> = []) {
        self.searchFilter = searchFilter
        self.dice = dice
        self.symbols = symbols

        let predicate = predicateBuilder(searchFilter: searchFilter, decks: decks, types: types, requirements: requirements, pawns: pawns, dice: dice, symbols: symbols)

        _cards = Query(filter: predicate, sort: [SortDescriptor(\.rawDeck), SortDescriptor(\.id)])

        _path = path
    }

    var body: some View {
        List {
            Button("Reload cards") {
                isFetchingCards = true
                Task {
                    let fetcher = ThreadsafeBackgroundActor(modelContainer: context.container)
                    fetchedCards = try await fetcher.fetchData()
                    isFetchingCards = false
                }
            }
            .disabled(isFetchingCards)
            ForEach(filteredCards) { card in
                NavigationLink("\(card.id) — \(card.title)", value: card)
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
            if filteredCards.isEmpty {
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
