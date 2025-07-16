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

    init(card: Card, path: Binding<NavigationPath>) {
        self.card = card
        self._path = path
    }

    var body: some View {
        List {
            if UIImage(named: imageId) != nil {
                Image(imageId)
                    .resizable()
                    .scaledToFit()
                    .zoomable()
            }
            Section {
                LabeledContent("ID") {
                    Text(card.id)
                }
                LabeledContent("Deck") {
                    Text(card.deck.description.display)
                }
                LabeledContent("Card type") {
                    Text(card.type.description.display)
                }
                if let requirement = card.bunnyRequirement {
                    LabeledContent("Bunny requirement") {
                        Text(requirement.description.display)
                    }
                }
                if let dice = card.dice, !dice.isEmpty {
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
                if let symbols = card.symbols, !symbols.isEmpty {
                    LabeledContent("Symbols") {
                        Text(symbols.map(\.description.display).joined(separator: ", "))
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

    let fetchDescriptor = FetchDescriptor<CardModel>(predicate: #Predicate { $0.id == "0185" })

    if let card = try? previewContainer.mainContext.fetch(fetchDescriptor).first {
        NavigationStack(path: $path) {
            CardDetailView(card: Card(card), path: $path)
        }
        .modelContainer(previewContainer)
    }
}
