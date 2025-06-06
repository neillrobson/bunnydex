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
    var imageId: String {
        "01x\(card.deck.isKinder ? "K" : "Q")\(card.id)"
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
                LabeledContent("Deck") {
                    Text(card.deck.description)
                }
                LabeledContent("Card type") {
                    Text(card.type.rawValue)
                }
                LabeledContent("Bunny requirement") {
                    Text(card.bunnyRequirement.rawValue)
                }
                card.dice.map { dice in
                    LabeledContent("Dice") {
                        Grid(alignment: .center, horizontalSpacing: 5, verticalSpacing: 5) {
                            ForEach (0...dice.count/5, id: \.self) { row in
                                let rowStart = row * 5
                                let offsetEnd = min(dice.count - rowStart, 5)
                                let offsetStart = offsetEnd - 5

                                GridRow {
                                    ForEach(offsetStart..<offsetEnd, id: \.self) { offset in
                                        if offset < 0 {
                                            Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                                        } else {
                                            let die = dice[rowStart + offset]
                                            Image(systemName: die.systemImageName)
                                                .foregroundStyle(die.color)
                                        }
                                    }
                                }
                            }
                        }
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
        .toolbar {
            if path.count > 1 {
                Button {
                    path = NavigationPath()
                } label: {
                    Image(systemName: "house.circle")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()

    if let card = getCardsFromJSON().first(where: { $0.id == "0066" }) {
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
