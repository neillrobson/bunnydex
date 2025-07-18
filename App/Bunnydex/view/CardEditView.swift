//
//  CardEditView.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/17/25.
//

import SwiftData
import SwiftUI

struct CardEditView: View {
    @Bindable var card: CardModel

    var body: some View {
        Form {
            Section("Fundamentals") {
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

            Section("Optionals") {
                Picker("Pawn", selection: $card.rawPawn) {
                    Text("None").tag(Int?(nil))
                    ForEach(Pawn.allCases) { pawn in
                        Text(pawn.description.display).tag(pawn.rawValue)
                    }
                }
            }
        }
        .navigationTitle("Edit card")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let fetchDescriptor = FetchDescriptor<CardModel>(predicate: #Predicate { $0.id == "0185" })

    if let card = try? previewContainer.mainContext.fetch(fetchDescriptor).first {
        NavigationStack {
            CardEditView(card: card)
                .modelContainer(previewContainer)
        }
    }
}
