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

    @State private var expanded = true

    var body: some View {
        NavigationView {
            List {
                Section(isExpanded: $expanded) {
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

    FilterView(deckSelection: $deckSelection)
}
