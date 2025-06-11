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

    @State private var currentZoom = 0.0
    @State private var finalZoom = 1.0
    @State private var currentOffset: CGSize = .zero
    @State private var finalOffset: CGSize = .zero

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                currentOffset = value.translation
            }
            .onEnded({ value in
                finalOffset += currentOffset
                currentOffset = .zero
            })
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { amount in
                currentZoom = amount - 1
            }
            .onEnded({ amount in
                finalZoom += currentZoom
                currentZoom = 0
            })
    }

    var body: some View {
        List {
            if UIImage(named: imageId) != nil {
                Image(imageId)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .scaleEffect(currentZoom + finalZoom)
                    .offset(currentOffset + finalOffset)
                    .gesture(dragGesture.simultaneously(with: magnificationGesture))
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
