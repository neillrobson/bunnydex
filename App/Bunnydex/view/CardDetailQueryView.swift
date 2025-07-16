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
    let id: String
    @Binding var path: NavigationPath

    @State private var result: Result<Card, Error>?

    @Environment(\.modelContext) private var context

    init(id: String, path: Binding<NavigationPath>) {
        self.id = id
        self._path = path
    }

    var body: some View {
        switch result {
        case .success(let card):
            CardDetailView(card: card, path: $path)
        case .failure:
            ContentUnavailableView("Card does not exist", systemImage: "questionmark.text.page")
        case nil:
            ProgressView()
                .task {
                    let fetcher = ThreadsafeBackgroundActor(modelContainer: context.container)
                    let results: [Card]
                    do {
                        results = try await fetcher.fetchData(#Predicate { $0.id == id })
                    } catch {
                        result = .failure(error)
                        return
                    }

                    result = if let first = results.first {
                        .success(first)
                    } else {
                        .failure(CardDetailError.notFound)
                    }
                }
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
