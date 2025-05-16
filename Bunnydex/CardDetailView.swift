//
//  CardDetailView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/8/25.
//

import SwiftUI
import SwiftData

struct CardDetailView: View {
    @Bindable var card: Card

    var body: some View {
        List {
            Section {
                LabeledContent("ID") {
                    Text(card.id)
                }
                LabeledContent("Card type") {
                    Text(card.type.rawValue)
                }
                LabeledContent("Bunny requirement") {
                    Text(card.bunnyRequirement.rawValue)
                }
            }
            ForEach(card.rules ?? [], id: \.title) { rule in
                Section(header: Text(rule.title)) {
                    Text(rule.text)
                }
            }
        }
        .navigationTitle(card.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CardDetailView(card: CARDS[0])
    }
}
