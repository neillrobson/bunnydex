//
//  CardDetailView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/8/25.
//

import SwiftUI
import SwiftData

struct CardDetailView: View {
    let card: CardModel
    var imageId: String {
        "01x\(card.deck.isKinder ? "K" : "Q")\(card.id)"
    }
    @Binding var path: NavigationPath

    @State private var showEditor = false

    init(card: CardModel, path: Binding<NavigationPath>) {
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
                LabeledContent("Bunny requirement") {
                    Text(card.bunnyRequirement.description.display)
                }
                if let pawn = card.pawn {
                    LabeledContent("Pawn") {
                        Text(pawn.description.display)
                    }
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
                                            let die = card.dice[rowStart + offset].die
                                            Image(systemName: die.systemImageName)
                                                .foregroundStyle(die.color)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if !card.symbols.isEmpty {
                    LabeledContent("Symbols") {
                        Text(card.symbols.map(\.symbol.description.display).joined(separator: ", "))
                    }
                }
            }
            ForEach(card.orderedRules, id: \.title) { rule in
                Section(header: Text(rule.title)) {
                    Text(.init(rule.text))
                }
            }
            .environment(\.openURL, OpenURLAction(handler: { URL in
                if URL.scheme == "bunnypedia" || URL.scheme == "bunnydex" {
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

            Button {
                showEditor = true
            } label: {
                Image(systemName: "pencil.circle")
            }
        }
        .sheet(isPresented: $showEditor) {
            NavigationStack {
                CardEditView(card: card)
            }
        }
    }
}

#Preview(traits: .modifier(SampleData())) {
    @Previewable @Query(filter: #Predicate<CardModel> { $0.id == "0185" }) var cards: [CardModel]
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardDetailView(card: cards[0], path: $path)
    }
}

#Preview("Home Button", traits: .modifier(SampleData())) {
    @Previewable @Query(filter: #Predicate<CardModel> { $0.id == "0185" }) var cards: [CardModel]
    @Previewable @State var path = NavigationPath()

    NavigationStack(path: $path) {
        CardDetailView(card: cards[0], path: .constant(NavigationPath("stuff")))
    }
}
