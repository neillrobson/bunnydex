//
//  MarkdownEditor.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/18/25.
//

import SwiftUI

struct MarkdownEditor: View {
    @Binding var rule: RuleModel

    var body: some View {
        Form {
            Section("Rule Title") {
                TextField("Blue Congenial", text: $rule.title)
            }
            Section {
                TextEditor(text: $rule.text)
                    .frame(minHeight: 100)
            } header: {
                Text("Rule Text")
            } footer: {
                Text("Inline markdown is supported. Lists and multiline formatting must be entered manually.\n\nLinks to other cards can be written as \\[display text](bunnydex://cards/1234), where 1234 is the Card ID.")
            }
            Section("Markdown Preview") {
                Text(.init(rule.text))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    @Previewable @State var rule: RuleModel = .init(title: "Card Title", text: "Here is some _italic_ text, **bold** text, and a [link](bunnydex://cards/1234).")

    MarkdownEditor(rule: $rule)
}
