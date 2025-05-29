//
//  CardDetailView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/8/25.
//

import SwiftUI
import SwiftData

extension String {
    func trimZeroes() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: CharacterSet(charactersIn: "0")) }) else {
            return self
        }

        return String(self[index...])
    }
}

struct CardDetailView: View {
    let card: Card
    var imageId: String {
        card.id.trimZeroes()
    }
    @Binding var path: NavigationPath

    let columns = [
        GridItem(.fixed(10), spacing: 15),
        GridItem(.fixed(10), spacing: 15),
        GridItem(.fixed(10), spacing: 15),
        GridItem(.fixed(10), spacing: 15),
        GridItem(.fixed(10), spacing: 15),
    ]

    var body: some View {
        List {
            if UIImage(named: imageId) != nil {
                Image(imageId)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 580, height: 200, alignment: .top)
                    .offset(x: 0, y: -160)
            }
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
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 5) {
                            ForEach(dice, id: \.self) { die in
                                Image(systemName: die.systemImageName)
                                    .foregroundStyle(die.color)
                            }
                        }
                        .environment(\.layoutDirection, .rightToLeft)
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
