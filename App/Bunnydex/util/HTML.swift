//
//  HTML.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/3/25.
//
//  Inspiration: https://github.com/ActuallyTaylor/SwiftHTMLToMarkdown
//

import Foundation
import SwiftSoup

public enum ConversionError: LocalizedError {
    case documentNotInitialized
    case bodyNotPresent

    public var errorDescription: String? {
        switch self {
        case .documentNotInitialized:
            return "The document was not properly initialized."
        case .bodyNotPresent:
            return "The document body could not be found."
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .documentNotInitialized:
            return "Make sure you are properly calling .parse() after initializing the HTML object."
        case .bodyNotPresent:
            return "Make sure your HTML contains a <body> tag."
        }
    }
}

public protocol HTML {
    var rawHTML: String { get set }
    var document: Document? { get set }
    var rawText: String { get set }
    var markdown: String { get set }

    init()

    init(rawHTML: String)

    mutating func parse() throws

    mutating func asMarkdown() throws -> String

    mutating func convertNode(_ node: Node) throws
}

public extension HTML {
    init(rawHTML: String) {
        self.init()
        self.rawHTML = rawHTML
    }

    mutating func parse() throws {
        let doc = try SwiftSoup.parse(rawHTML)
        document = doc
        rawText = try doc.text()
    }

    mutating func asMarkdown() throws -> String {
        guard let document else {
            throw ConversionError.documentNotInitialized
        }

        markdown = ""

        guard let body: Node = document.body() else {
            throw ConversionError.bodyNotPresent
        }

        try convertNode(body)

        return markdown
    }
}
