//
//  InfoView.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/6/25.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle("About")
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
    InfoView()
}
