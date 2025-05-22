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
                card.dice.map { dice in
                    LabeledContent("Dice") {
                        GeometryReader { geom in
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(dice, id: \.self) { die in
                                        Image(systemName: die.systemImageName)
                                            .foregroundStyle(die.color)
                                    }
                                }
                                .frame(width: geom.size.width, alignment: .trailing)
                            }
                        }
                        .background(Color.gray.opacity(0.2))
                    }
                }
            }
            ForEach(card.rules ?? [], id: \.title) { rule in
                Section(header: Text(rule.title)) {
                    Text(.init(rule.text))
                }
            }
            .environment(\.openURL, OpenURLAction(handler: { URL in
                if URL.scheme == "bunnypedia" {
                    let id = URL.lastPathComponent
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

    if let card = CARDS.first(where: { $0.id == "0066" }) {
        NavigationStack(path: $path) {
            CardDetailView(card: card, path: $path)
        }
        .modelContainer(appContainer)
    }
}

#Preview("Placeholder") {
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardDetailView(card: Card.placeholder, path: $path)
    }
    .modelContainer(appContainer)
}
