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
    #if DEBUG
    @Environment(\.modelContext) var context
    @State private var loadingTask: Task<Void, Never>?
    private var isLoading: Bool { loadingTask != nil }
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
                    guard loadingTask == nil else { return }

                    loadingTask = Task {
                        let fetcher = ThreadsafeBackgroundActor(modelContainer: context.container)
                        await fetcher.resetDatabase()

                        await MainActor.run {
                            loadingTask = nil
                        }
                    }
                }
                .disabled(isLoading)
                #endif
            }
        }
    }
}

#Preview {
    InfoView()
        .modelContainer(previewContainer)
}
