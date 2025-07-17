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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let fetchDescriptor = FetchDescriptor<CardModel>(predicate: #Predicate { $0.id == "0185" })

    if let card = try? previewContainer.mainContext.fetch(fetchDescriptor).first {
        CardEditView(card: card)
            .modelContainer(previewContainer)
    }
}
