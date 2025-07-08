//
//  CardListView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/9/25.
//

import SwiftUI
import SwiftData

@MainActor @Observable
class CardListViewModel {
    var cards: [JSONCard] = []

    func load(container: ModelContainer, filter: Predicate<Card>) async {
        cards = (try? await fetchData(container: container, filter: filter)) ?? []
    }

    nonisolated func fetchData(container: ModelContainer, filter: Predicate<Card>) async throws -> [JSONCard] {
        let service = ThreadsafeBackgroundActor(modelContainer: container)
        return try await service.fetchData(filter)
    }
}

struct CardListView: View {
    @State private var viewModel = CardListViewModel()
    @Environment(\.modelContext) private var context
    @Binding var path: NavigationPath
    @Binding var cardFilter: CardPredicate

    init(path: Binding<NavigationPath>, cardFilter: Binding<CardPredicate> = .constant(.init())) {
        _path = path
        _cardFilter = cardFilter
    }

    var body: some View {
        List {
            ForEach(viewModel.cards) { card in
                NavigationLink("\(card.id) — \(card.title)", value: card.id)
            }
        }
        .navigationTitle("Cards")
        .navigationDestination(for: String.self) { id in
            CardDetailQueryView(id: id, path: $path)
        }
        .overlay {
            if viewModel.cards.isEmpty {
                if cardFilter.searchFilter.isEmpty {
                    ContentUnavailableView("No Cards found", systemImage: "magnifyingglass", description: Text("Try adjusting your filters."))
                } else {
                    ContentUnavailableView.search(text: cardFilter.searchFilter)
                }
            }
        }
        .task(id: cardFilter) {
            await viewModel.load(container: context.container, filter: cardFilter.predicate)
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
