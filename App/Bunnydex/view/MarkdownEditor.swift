//
//  MarkdownEditor.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/18/25.
//

import SwiftUI

struct MarkdownEditor: View {
    @Binding var rule: Rule

    var body: some View {
        TextField(text: $rule.title, prompt: Text("hi")) {
            Text("label")
        }
    }
}

#Preview {
    @Previewable @State var rule: Rule = .init(title: "Card Text", text: "This is a card text")

    Form {
        MarkdownEditor(rule: $rule)
    }
}
