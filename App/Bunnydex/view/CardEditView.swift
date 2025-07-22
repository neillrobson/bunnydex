//
//  CardEditView.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/17/25.
//

import SwiftData
import SwiftUI

struct CardEditView: View {
    @Query var dice: [DieModel]
    @Query var symbols: [SymbolModel]

    @Bindable var card: CardModel

    var body: some View {
        Form {
            Section("Required Fields") {
                LabeledContent("ID") {
                    TextField("0000", text: $card.id)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("Title") {
                    TextField("Choose A Carrot", text: $card.title)
                        .multilineTextAlignment(.trailing)
                }
                Picker("Deck", selection: $card.rawDeck) {
                    ForEach(Deck.allCases) { deck in
                        Text(deck.description.display).tag(deck.rawValue)
                    }
                }
                Picker("Card type", selection: $card.rawType) {
                    ForEach(CardType.allCases) { type in
                        Text(type.description.display).tag(type.rawValue)
                    }
                }
                Picker("Bunny requirement", selection: $card.rawRequirement) {
                    ForEach(BunnyRequirement.allCases) { requirement in
                        Text(requirement.description.display).tag(requirement.rawValue)
                    }
                }
            }

            Section("Optional Fields") {
                Picker("Pawn", selection: $card.rawPawn) {
                    Text("None").tag(Int?(nil))
                    ForEach(Pawn.allCases) { pawn in
                        Text(pawn.description.display).tag(pawn.rawValue)
                    }
                }
                MultiPicker(label: Text("Dice"), options: dice, optionToString: \.die.description.display, selected: $card.dice)
                MultiPicker(label: Text("Symbols"), options: symbols, optionToString: \.symbol.description.display, selected: $card.symbols)
            }

            Section("Bunny Bits") {
                ForEach($card.orderedRules, id: \.self) { rule in
                    NavigationLink {
                        MarkdownEditor(rule: rule)
                            .navigationTitle("Edit Rule")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Text(rule.wrappedValue.title)
                    }
                }
            }
        }
        .navigationTitle("Edit Card")
    }
}

#Preview(traits: .modifier(SampleData())) {
    @Previewable @Query(filter: #Predicate<CardModel> { $0.id == "0185" }) var cards: [CardModel]

    NavigationStack {
        CardEditView(card: cards[0])
    }
}
