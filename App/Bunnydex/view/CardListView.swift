//
//  CardListView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/9/25.
//

import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var context

    @Binding var path: NavigationPath
    @Binding var cardFilter: CardPredicate

    @Query private var cards: [CardModel]
    @State private var isLoading = false

    func save() async {
        guard context.hasChanges else {
            print("No changes to save")
            return
        }

        self.isLoading = true
        defer { self.isLoading = false }

        let notifications = NotificationCenter.default.notifications(named: ModelContext.didSave)

        do {
            try context.save()
        } catch {
            print("Save failed: \(error)")
            return
        }

        // Wait for the save, and any downstream reactivity, to complete
        for await _ in notifications {
            break
        }
    }

    init(path: Binding<NavigationPath>, cardFilter: Binding<CardPredicate> = .constant(.init())) {
        _path = path
        _cardFilter = cardFilter
        _cards = Query(filter: self.cardFilter.predicate, sort: [SortDescriptor(\.rawDeck), SortDescriptor(\.cardId)])
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading cards")
            } else {
                List {
                    ForEach(cards) { card in
                        NavigationLink("\(card.cardId) — \(card.title)", value: card)
                    }
                }
                .overlay {
                    if cards.isEmpty {
                        if cardFilter.searchFilter.isEmpty {
                            ContentUnavailableView("No Cards found", systemImage: "magnifyingglass", description: Text("Try adjusting your filters."))
                        } else {
                            ContentUnavailableView.search(text: cardFilter.searchFilter)
                        }
                    }
                }
            }
        }
        .navigationTitle("Cards")
        .navigationDestination(for: CardModel.self) { card in
            CardDetailView(card: card, path: $path)
        }
        .navigationDestination(for: PersistentIdentifier.self) { id in
            CardDetailQueryView(id: id, path: $path)
        }
        .navigationDestination(for: String.self) { cardId in
            CardDetailQueryView(cardId: cardId, path: $path)
        }
        .task {
            await save()
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
    @Previewable @State var cardFilter = CardPredicate(searchFilter: "does not exist")

    NavigationStack(path: $path) {
        CardListView(path: $path, cardFilter: $cardFilter)
    }
    .modelContainer(previewContainer)
}

#Preview("Filtered") {
    @Previewable @State var path = NavigationPath()
    @Previewable @State var cardFilter = CardPredicate(dice: [.red])

    NavigationStack(path: $path) {
        CardListView(path: $path, cardFilter: $cardFilter)
    }
    .modelContainer(previewContainer)
}

#Preview("Empty filtered") {
    @Previewable @State var path = NavigationPath()
    @Previewable @State var cardFilter = CardPredicate(dice: [.red, .blueD10, .chineseZodiac])

    NavigationStack(path: $path) {
        CardListView(path: $path, cardFilter: $cardFilter)
    }
    .modelContainer(previewContainer)
}
