//
//  CustomText.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/1/25.
//

import SwiftUI

struct CustomText: UIViewRepresentable {
    @Environment(\.openURL) private var openURL

    var attributedText: NSAttributedString

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.delegate = context.coordinator

        return textView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.attributedText = attributedText
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
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

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomText

        init(_ parent: CustomText) {
            self.parent = parent
        }

        func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
            if case .link(let url) = textItem.content {
                parent.openURL(url)
            }

            return nil
        }
    }
}
