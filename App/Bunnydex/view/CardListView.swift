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
    enum State {
        case idle
        case loading
        case failed(Error)
        case loaded([CardView])
    }

    private(set) var state = State.idle
    private var lastFilter: CardPredicate?
    private var lastReloadCount = 0

    nonisolated(unsafe) private var observationTask: Task<Void, Never>?

    deinit {
        observationTask?.cancel()
    }

    func loadExperiment(container: ModelContainer, filter: CardPredicate) {
        if let lastFilter = lastFilter, lastFilter == filter {
            return
        }

        state = .loading

        observationTask?.cancel()
        observationTask = Task { [weak self] in
            guard let stream = await self?.fetchExperiment(container: container, predicate: filter.predicate) else { return }

            for await cards in stream {
                self?.state = .loaded(cards)
            }
        }
    }

    nonisolated func fetchExperiment(container: ModelContainer, predicate: Predicate<CardModel>) async -> AsyncStream<[CardView]> {
        let service = ThreadsafeBackgroundActor(modelContainer: container)
        return await service.fetchExperiment(predicate)
    }

    func load(container: ModelContainer, filter: CardPredicate, reloadCount: Int = 0) async {
        if let lastFilter = lastFilter, lastFilter == filter && lastReloadCount == reloadCount {
            return
        }

        state = .loading
        lastReloadCount = reloadCount

        do {
            try await Task.sleep(nanoseconds: 250_000_000)
            let cards = try await fetchData(container: container, predicate: filter.predicate)
            lastFilter = filter
            state = .loaded(cards)
        } catch is CancellationError {
            state = .idle
        } catch {
            state = .failed(error)
        }
    }

    nonisolated func fetchData(container: ModelContainer, predicate: Predicate<CardModel>) async throws -> [CardView] {
        let service = ThreadsafeBackgroundActor(modelContainer: container)
        return try await service.fetchData(predicate)
    }
}

struct CardListView: View {
    @State private var viewModel = CardListViewModel()
    @Environment(\.modelContext) private var context
    @Binding var path: NavigationPath
    @Binding var cardFilter: CardPredicate
    @Binding var forceReload: Int

    init(path: Binding<NavigationPath>, cardFilter: Binding<CardPredicate> = .constant(.init()), forceReload: Binding<Int> = .constant(0)) {
        _path = path
        _cardFilter = cardFilter
        _forceReload = forceReload
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView("Loading cards")
            case .failed(let error):
                Text("Error: \(error)")
            case .loaded(let cards):
                List {
                    ForEach(cards) { card in
                        NavigationLink("\(card.cardId) — \(card.title)", value: card.id)
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
        .navigationDestination(for: PersistentIdentifier.self) { id in
            CardDetailQueryView(id: id, path: $path)
        }
        .navigationDestination(for: String.self) { cardId in
            CardDetailQueryView(cardId: cardId, path: $path)
        }
        .task(id: cardFilter) {
            viewModel.loadExperiment(container: context.container, filter: cardFilter)
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
