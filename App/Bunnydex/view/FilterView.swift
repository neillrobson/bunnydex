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

    @ObservedObject var cardFilter: CardPredicate

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
                    Text("Symbol")
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Filters")
            .toolbar {
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
    @Previewable @StateObject var cardFilter = CardPredicate()
    @Previewable @State var expandState: FilterExpandState = .init()

    FilterView(cardFilter: cardFilter, expandState: $expandState)
}
