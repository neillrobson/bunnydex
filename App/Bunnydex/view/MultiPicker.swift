//
//  MultiPicker.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/18/25.
//

import SwiftUI

struct MultiPicker<LabelView: View, Selectable: Identifiable & Hashable>: View {
    let label: LabelView
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    var selected: Binding<[Selectable]>

    private var formattedSelectedListString: String {
        ListFormatter.localizedString(byJoining: selected.wrappedValue.sorted {
            $0.hashValue < $1.hashValue
        }.map(optionToString))
    }

    var body: some View {
        NavigationLink(destination: multiSelectionView()) {
            HStack {
                label
                Spacer()
                Text(formattedSelectedListString)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    private func multiSelectionView() -> some View {
        MultiPickerView(options: options, optionToString: optionToString, selected: selected)
    }
}

struct MultiPickerView<Selectable: Identifiable & Hashable>: View {
    let options: [Selectable]
    let optionToString: (Selectable) -> String

    @Binding var selected: [Selectable]

    var body: some View {
        List {
            ForEach(options.sorted { $0.hashValue < $1.hashValue }) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text(optionToString(selectable)).foregroundColor(.primary)
                        Spacer()
                        if selected.contains(selectable) {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
    }

    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.append(selectable)
        }
    }
}

#Preview {
    @Previewable @State var selectedDice: [Die] = [.red, .blue, .chineseZodiac]

    NavigationView {
        Form {
            MultiPicker<Text, Die>(
                label: Text("Dice"),
                options: Die.allCases,
                optionToString: \.description.display,
                selected: $selectedDice
            )
        }
    }
}
