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

struct FilterView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var deckSelection: Set<Deck>
    @Binding var pawnSelection: Set<Pawn>

    @State private var deckExpanded = false
    @State private var pawnExpanded = false

    var body: some View {
        NavigationView {
            List {
                Section(isExpanded: $deckExpanded) {
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

                Section(isExpanded: $pawnExpanded) {
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
    @Previewable @State var pawnSelection: Set<Pawn> = []

    FilterView(deckSelection: $deckSelection, pawnSelection: $pawnSelection)
}
