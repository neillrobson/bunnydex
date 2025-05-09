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
        VStack {
            Text(card.id)
            Text(card.title)
            List {
                Section {
                    LabeledContent("Card type") {
                        Text(card.type.rawValue)
                    }
                    LabeledContent("Bunny requirement") {
                        Text(card.bunnyRequirement.rawValue)
                    }
                }
                Section(header: Text("Card Text")) {
                    Text("Players that have three bunnies in The Bunny Circle of the same color or kind may play two cards per turn.")
                }
            }
        }
        .navigationTitle(card.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CardDetailView(card: cards[0])
    }
}
