//
//  CardDetailView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/8/25.
//

import SwiftUI
import SwiftData

extension CGSize {
    static func +(lhs: Self, rhs: Self) -> Self {
        Self(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func +=(lhs: inout Self, rhs: Self) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }
}

struct CardDetailView: View {
    let card: Card
    var imageId: String {
        "01x\(card.deck.isKinder ? "K" : "Q")\(card.id)"
    }
    @Binding var path: NavigationPath

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
                LabeledContent("Bunny requirement") {
                    Text(card.bunnyRequirement.description.display)
                }
                if !card.dice.isEmpty {
                    LabeledContent("Dice") {
                        Grid(alignment: .center, horizontalSpacing: 5, verticalSpacing: 5) {
                            ForEach (0...card.dice.count/5, id: \.self) { row in
                                let rowStart = row * 5
                                let offsetEnd = min(card.dice.count - rowStart, 5)
                                let offsetStart = offsetEnd - 5

                                GridRow {
                                    ForEach(offsetStart..<offsetEnd, id: \.self) { offset in
                                        if offset < 0 {
                                            Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                                        } else {
                                            let die = card.dice[rowStart + offset]
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
            ForEach(card.rules, id: \.title) { rule in
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

    let fetchDescriptor = FetchDescriptor<Card>(predicate: #Predicate { $0.id == "0066" })

    if let card = try? previewContainer.mainContext.fetch(fetchDescriptor).first {
        NavigationStack(path: $path) {
            CardDetailView(card: card, path: $path)
        }
        .modelContainer(previewContainer)
    }
}
