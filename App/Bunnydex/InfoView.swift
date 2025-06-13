//
//  InfoView.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/6/25.
//

import SwiftUI
import SwiftData

let infoText = """
                [Killer Bunnies](https://killerbunnies.com/) is a registered trademark of Jeffrey Bellinger. All rights reserved. All copyrights and trademarks used under license.

                This fan-made iOS application is designed and developed by [Neill Robson](https://neillrobson.com).

                Inspired by [Bunnypedia](https://play.google.com/store/apps/details?id=com.fueledbycaffeine.bunnypedia&hl=en_US), designed and developed by [Josh Friend](https://github.com/joshfriend/bunnypedia).

                App icon art by Jennifer Robson.
                """

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    #if DEBUG
    @Environment(\.modelContext) var context
    #endif

    var body: some View {
        NavigationStack {
            VStack {
                Text(.init(infoText))
                    .multilineTextAlignment(.center)
                    .padding()
                    .navigationTitle("About")

                #if DEBUG
                Button("Reset database") {
                    resetData(context)
                }
                #endif
            }
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
        .modelContainer(appContainer)
}
