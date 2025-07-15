//
//  FilterView.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/13/25.
//

import SwiftUI

extension String {
    var display: String {
        self.replacing("_", with: " ").capitalized
    }
}

struct FilterExpandState {
    var deck = false
    var pawn = false
    var cardType = false
    var bunnyRequirement = false
    var dice = false
    var symbols = false
}

struct FilterView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var cardFilter: CardPredicate
    @Binding var expandState: FilterExpandState

    var body: some View {
        NavigationView {
            List {
                Section(isExpanded: $expandState.deck) {
                    ForEach(Deck.allCases) { deck in
                        Toggle(isOn: Binding(get: {
                            cardFilter.decks.contains(deck)
                        }, set: { value in
                            if value {
                                cardFilter.decks.insert(deck)
                            } else {
                                cardFilter.decks.remove(deck)
                            }
                        })) {
                            Text(deck.description.display)
                        }
                    }
                } header: {
                    Text("Decks")
                    if !cardFilter.decks.isEmpty {
                        Button {
                            cardFilter.decks.removeAll()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .imageScale(.small)
                        }
                    }
                }

                Section(isExpanded: $expandState.cardType) {
                    ForEach(CardType.allCases) { cardType in
                        Toggle(isOn: Binding(get: {
                            cardFilter.types.contains(cardType)
                        }, set: { value in
                            if value {
                                cardFilter.types.insert(cardType)
                            } else {
                                cardFilter.types.remove(cardType)
                            }
                        })) {
                            Text(cardType.description.display)
                        }
                    }
                } header: {
                    Text("Card Types")
                    if !cardFilter.types.isEmpty {
                        Button {
                            cardFilter.types.removeAll()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .imageScale(.small)
                        }
                    }
                }

                Section(isExpanded: $expandState.bunnyRequirement) {
                    ForEach(BunnyRequirement.allCases) { bunnyRequirement in
                        Toggle(isOn: Binding(get: {
                            cardFilter.requirements.contains(bunnyRequirement)
                        }, set: { value in
                            if value {
                                cardFilter.requirements.insert(bunnyRequirement)
                            } else {
                                cardFilter.requirements.remove(bunnyRequirement)
                            }
                        })) {
                            Text(bunnyRequirement.description.display)
                        }
                    }
                } header: {
                    Text("Bunny Requirements")
                    if !cardFilter.requirements.isEmpty {
                        Button {
                            cardFilter.requirements.removeAll()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .imageScale(.small)
                        }
                    }
                }

                Section(isExpanded: $expandState.pawn) {
                    ForEach(Pawn.allCases) { pawn in
                        Toggle(isOn: Binding(get: {
                            cardFilter.pawns.contains(pawn)
                        }, set: { value in
                            if value {
                                cardFilter.pawns.insert(pawn)
                            } else {
                                cardFilter.pawns.remove(pawn)
                            }
                        })) {
                            Text(pawn.description.display)
                        }
                    }
                } header: {
                    Text("Pawns")
                    if !cardFilter.pawns.isEmpty {
                        Button {
                            cardFilter.pawns.removeAll()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .imageScale(.small)
                        }
                    }
                }

                Section(isExpanded: $expandState.dice) {
                    ForEach(Die.allCases) { die in
                        Toggle(isOn: Binding(get: {
                            cardFilter.dice.contains(die)
                        }, set: { value in
                            if value {
                                cardFilter.dice.insert(die)
                            } else {
                                cardFilter.dice.remove(die)
                            }
                        })) {
                            Text(die.description.display)
                        }
                    }
                } header: {
                    Text("Dice")
                    if !cardFilter.dice.isEmpty {
                        Button {
                            cardFilter.dice.removeAll()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .imageScale(.small)
                        }
                    }
                }

                Section(isExpanded: $expandState.symbols) {
                    ForEach(Symbol.allCases) { symbol in
                        Toggle(isOn: Binding(get: {
                            cardFilter.symbols.contains(symbol)
                        }, set: { value in
                            if value {
                                cardFilter.symbols.insert(symbol)
                            } else {
                                cardFilter.symbols.remove(symbol)
                            }
                        })) {
                            Text(symbol.description.display)
                        }
                    }
                } header: {
                    Text("Symbols")
                    if !cardFilter.symbols.isEmpty {
                        Button {
                            cardFilter.symbols.removeAll()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .imageScale(.small)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Filters")
            .toolbar {
                if !cardFilter.decks.isEmpty
                    || !cardFilter.types.isEmpty
                    || !cardFilter.requirements.isEmpty
                    || !cardFilter.pawns.isEmpty
                    || !cardFilter.dice.isEmpty
                    || !cardFilter.symbols.isEmpty
                {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Reset") {
                            cardFilter.decks.removeAll()
                            cardFilter.types.removeAll()
                            cardFilter.requirements.removeAll()
                            cardFilter.pawns.removeAll()
                            cardFilter.dice.removeAll()
                            cardFilter.symbols.removeAll()
                        }
                    }
                }
                ToolbarItem {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var cardFilter = CardPredicate()
    @Previewable @State var expandState: FilterExpandState = .init()

    FilterView(cardFilter: $cardFilter, expandState: $expandState)
}
