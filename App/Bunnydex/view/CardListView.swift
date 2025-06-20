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
    var filteredCards: [Card] {
        return cards.filter { card in
            dice.isSubset(of: card.dice) &&
            symbols.isSubset(of: card.symbols)
        }
    }

    init(searchFilter: String = "", path: Binding<NavigationPath>, decks: Set<Deck> = [], types: Set<CardType> = [], requirements: Set<BunnyRequirement> = [], pawns: Set<Pawn> = [], dice: Set<Die> = [], symbols: Set<Symbol> = []) {
        let rawDecks = decks.map(\.rawValue)
        let rawTypes = types.map(\.rawValue)
        let rawRequirements = requirements.map(\.rawValue)
        let rawPawns = pawns.map(\.rawValue)

        self.searchFilter = searchFilter
        self.dice = dice
        self.symbols = symbols

        let searchPredicate = #Predicate<Card> { card in
            searchFilter.isEmpty || card.title.localizedStandardContains(searchFilter) || card.id == searchFilter
        }
        let deckPredicate = #Predicate<Card> { card in
            rawDecks.isEmpty || rawDecks.contains(card.rawDeck)
        }
        let typePredicate = #Predicate<Card> { card in
            rawTypes.isEmpty || rawTypes.contains(card.rawType)
        }
        let requirementPredicate = #Predicate<Card> { card in
            rawRequirements.isEmpty || rawRequirements.contains(card.rawRequirement)
        }
        let pawnPredicate = #Predicate<Card> { card in
            rawPawns.isEmpty || (card.rawPawn.flatMap { rawPawns.contains($0) } ?? false)
        }

        let predicate = #Predicate<Card> { card in
            searchPredicate.evaluate(card) &&
            deckPredicate.evaluate(card) &&
            typePredicate.evaluate(card) &&
            requirementPredicate.evaluate(card) &&
            pawnPredicate.evaluate(card)
        }

        _cards = Query(filter: predicate, sort: [SortDescriptor(\.rawDeck), SortDescriptor(\.id)])

        _path = path
    }

    var body: some View {
        List {
            ForEach(filteredCards) { card in
                NavigationLink("\(card.id) — \(card.title)", value: card)
            }
        }
        .navigationTitle("Cards")
        .navigationDestination(for: Card.self) { card in
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
