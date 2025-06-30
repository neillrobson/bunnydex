//
//  CardDetailView.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/8/25.
//

import SwiftUI
import SwiftData

struct CustomTextControllerRepresentable: UIViewControllerRepresentable {
    var attributedText: NSAttributedString

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()

        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        controller.view = textView

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let textView = uiViewController.view as? UITextView else { return }

        textView.attributedText = attributedText
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: UIViewController, context: Context) -> CGSize? {
        let dimensions = proposal.replacingUnspecifiedDimensions(
            by: .init(width: 0, height: CGFloat.greatestFiniteMagnitude)
        )

        let calculatedHeight = calculateTextViewHeight(containerSize: dimensions, attributedString: attributedText)

        return .init(
            width: dimensions.width,
            height: calculatedHeight
        )
    }

    private func calculateTextViewHeight(containerSize: CGSize, attributedString: NSAttributedString) -> CGFloat {
        let boundingRect = attributedString.boundingRect(
            with: .init(width: containerSize.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        return boundingRect.height
    }
}

struct CustomText: UIViewRepresentable {
    var attributedText: NSAttributedString

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero

        return textView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.attributedText = attributedText
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        let dimensions = proposal.replacingUnspecifiedDimensions(
            by: .init(width: 0, height: CGFloat.greatestFiniteMagnitude)
        )

        let calculatedHeight = calculateTextViewHeight(containerSize: dimensions, attributedString: attributedText)

        return .init(
            width: dimensions.width,
            height: calculatedHeight
        )
    }

    private func calculateTextViewHeight(containerSize: CGSize, attributedString: NSAttributedString) -> CGFloat {
        let boundingRect = attributedString.boundingRect(
            with: .init(width: containerSize.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        return boundingRect.height
    }
}

struct CardDetailView: View {
    let card: JSONCard
    var imageId: String {
        "01x\(card.deck.isKinder ? "K" : "Q")\(card.id)"
    }
    @Binding var path: NavigationPath

    let displayRules: [( title: String, text: NSAttributedString )]

    init(card: JSONCard, path: Binding<NavigationPath>) {
        self.card = card
        self._path = path

        displayRules = card.rules?.map { rule in
            let text = rule.text.htmlToAttributedString(font: UIFont.systemFont(ofSize: UIFont.labelFontSize), underlinedLinks: false, linkColor: .link, boldLinks: false)

            return (
                title: rule.title,
                text: text
            )
        } ?? []
    }

    var body: some View {
        List {
            if UIImage(named: imageId) != nil {
                Image(imageId)
                    .resizable()
                    .scaledToFit()
                    .zoomable()
            }
            Section {
                LabeledContent("ID") {
                    Text(card.id)
                }
                LabeledContent("Deck") {
                    Text(card.deck.description.display)
                }
                LabeledContent("Card type") {
                    Text(card.type.description.display)
                }
                if let requirement = card.bunnyRequirement {
                    LabeledContent("Bunny requirement") {
                        Text(requirement.description.display)
                    }
                }
                if let dice = card.dice, !dice.isEmpty {
                    LabeledContent("Dice") {
                        Grid(alignment: .center, horizontalSpacing: 5, verticalSpacing: 5) {
                            ForEach (0...dice.count/5, id: \.self) { row in
                                let rowStart = row * 5
                                let offsetEnd = min(dice.count - rowStart, 5)
                                let offsetStart = offsetEnd - 5

                                GridRow {
                                    ForEach(offsetStart..<offsetEnd, id: \.self) { offset in
                                        if offset < 0 {
                                            Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                                        } else {
                                            let die = dice[rowStart + offset]
                                            Image(systemName: die.systemImageName)
                                                .foregroundStyle(die.color)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if let symbols = card.symbols, !symbols.isEmpty {
                    LabeledContent("Symbols") {
                        Text(symbols.map(\.description.display).joined(separator: ", "))
                    }
                }
            }
            ForEach(displayRules, id: \.title) { rule in
                Section(header: Text(rule.title)) {
                    CustomTextControllerRepresentable(attributedText: rule.text)
                }
            }
            .environment(\.openURL, OpenURLAction(handler: { URL in
                print("openURL \(URL)")
                if URL.scheme == "bunnypedia" {
                    let id = URL.lastPathComponent
                    path.append(id)

                    return .handled
                }

                return .systemAction
            }))
        }
        .navigationTitle(card.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if path.count > 1 {
                Button {
                    path = NavigationPath()
                } label: {
                    Image(systemName: "house.circle")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()

    let fetchDescriptor = FetchDescriptor<Card>(predicate: #Predicate { $0.id == "0066" })

    if let card = try? previewContainer.mainContext.fetch(fetchDescriptor).first {
        NavigationStack(path: $path) {
            CardDetailView(card: JSONCard(card), path: $path)
        }
        .modelContainer(previewContainer)
    }
}
