//
//  CardDetailView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/8/25.
//

import SwiftUI
import SwiftData

struct CardDetailView: View {
    let card: Card
    @Binding var path: NavigationPath

    var body: some View {
        List {
            Section {
                LabeledContent("ID") {
                    Text(card.id)
                }
                LabeledContent("Card type") {
                    Text(card.type.rawValue)
                }
                LabeledContent("Bunny requirement") {
                    Text(card.bunnyRequirement.rawValue)
                }
            }
            ForEach(card.rules ?? [], id: \.title) { rule in
                Section(header: Text(rule.title)) {
                    Text(.init(rule.text))
                }
            }
            .environment(\.openURL, OpenURLAction(handler: { URL in
                if URL.scheme == "bunnypedia" {
                    let rawId = URL.lastPathComponent
                    let id = String(String(rawId.reversed()).padding(toLength: 4, withPad: "0", startingAt: 0).reversed())
                    path.append(id)

                    return .handled
                }

                return .systemAction
            }))
        }
        .navigationTitle(card.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: String.self) { id in
            CardDetailQueryView(id: id, path: $path)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardDetailView(card: CARDS[0], path: $path)
    }
    .modelContainer(appContainer)
}
