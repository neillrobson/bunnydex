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
}

struct FilterView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var deckSelection: Set<Deck>
    @Binding var typeSelection: Set<CardType>
    @Binding var requirementSelection: Set<BunnyRequirement>
    @Binding var pawnSelection: Set<Pawn>
    @Binding var diceSelection: Set<Die>
    @Binding var expandState: FilterExpandState

    var body: some View {
        NavigationView {
            List {
                Section(isExpanded: $expandState.deck) {
                    ForEach(Deck.allCases) { deck in
                        Toggle(isOn: Binding(get: {
                            deckSelection.contains(deck)
                        }, set: { value in
                            if value {
                                deckSelection.insert(deck)
                            } else {
                                deckSelection.remove(deck)
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
                            typeSelection.contains(cardType)
                        }, set: { value in
                            if value {
                                typeSelection.insert(cardType)
                            } else {
                                typeSelection.remove(cardType)
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
                            requirementSelection.contains(bunnyRequirement)
                        }, set: { value in
                            if value {
                                requirementSelection.insert(bunnyRequirement)
                            } else {
                                requirementSelection.remove(bunnyRequirement)
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
                            pawnSelection.contains(pawn)
                        }, set: { value in
                            if value {
                                pawnSelection.insert(pawn)
                            } else {
                                pawnSelection.remove(pawn)
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
                            diceSelection.contains(die)
                        }, set: { value in
                            if value {
                                diceSelection.insert(die)
                            } else {
                                diceSelection.remove(die)
                            }
                        })) {
                            Text(die.description.display)
                        }
                    }
                } header: {
                    Text("Dice")
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
    @Previewable @State var deckSelection: Set<Deck> = []
    @Previewable @State var typeSelection: Set<CardType> = []
    @Previewable @State var requirementSelection: Set<BunnyRequirement> = []
    @Previewable @State var pawnSelection: Set<Pawn> = []
    @Previewable @State var diceSelection: Set<Die> = []
    @Previewable @State var expandState: FilterExpandState = .init()

    FilterView(deckSelection: $deckSelection, typeSelection: $typeSelection, requirementSelection: $requirementSelection, pawnSelection: $pawnSelection, diceSelection: $diceSelection, expandState: $expandState)
}
