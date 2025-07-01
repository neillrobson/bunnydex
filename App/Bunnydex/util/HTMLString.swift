//
//  HTMLString.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/30/25.
//

import SwiftUI

extension String {
    func htmlToAttributedString(
        font: UIFont,
        underlinedLinks: Bool,
        linkColor: UIColor,
        boldLinks: Bool,
    ) -> NSAttributedString {
        guard
            let data = self.data(using: .utf8),
            let attributedString = try? NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            ) else {
            return .init()
        }

        attributedString.setFontFace(
            font: font
        )
        attributedString.decorateLinks(
            linkColor: linkColor,
            isUnderlined: underlinedLinks,
            isBold: boldLinks,
            font: font
        )
        attributedString.setLineHeightMultiple(1.1)

        return attributedString
    }
}

extension NSMutableAttributedString {
    func decorateLinks(
        linkColor: UIColor,
        isUnderlined: Bool,
        isBold: Bool,
        font: UIFont
    ) {
        enumerateAttribute(
            .link,
            in: NSRange(location: .zero, length: self.length),
            options: []
        ) { value, range, _ in
            if value != nil {
                var attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: linkColor
                ]

                if !isUnderlined {
                    attributes[.underlineStyle] = NSUnderlineStyle().rawValue
                }

                if isBold {
                    let boldFont = UIFont(
                        descriptor: font.fontDescriptor.withSymbolicTraits(.traitBold) ?? font.fontDescriptor,
                        size: font.pointSize
                    )
                    attributes[.font] = boldFont
                }

                addAttributes(attributes, range: range)
            }
        }
    }

    func setFontFace(
        font: UIFont,
        color: UIColor? = nil
    ) {
        enumerateAttribute(
            .font,
            in: NSRange(location: .zero, length: self.length)
        ) { value, range, _ in
            if let fontValue = value as? UIFont,
               let newFontDescriptor = fontValue
                .fontDescriptor
                .withFamily(font.familyName)
                .withSymbolicTraits(fontValue.fontDescriptor.symbolicTraits) {
                let newFont = UIFont(
                    descriptor: newFontDescriptor,
                    size: font.pointSize
                )
                removeAttribute(.font, range: range)
                addAttribute(.font, value: newFont, range: range)
                if let color = color {
                    removeAttribute(
                        .foregroundColor,
                        range: range
                    )
                    addAttribute(
                        .foregroundColor,
                        value: color,
                        range: range
                    )
                }
            }
        }
    }

    func setLineHeightMultiple(_ lineHeightMultiple: CGFloat) {
        enumerateAttribute(.paragraphStyle, in: NSRange(location: .zero, length: self.length)) { value, range, _ in
            if let paragraphStyle = value as? NSMutableParagraphStyle {
                paragraphStyle.lineHeightMultiple = lineHeightMultiple
                removeAttribute(.paragraphStyle, range: range)
                addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            }
        }
    }
}
