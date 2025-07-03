//
//  BasicHTML.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/3/25.
//

import SwiftSoup

public class BasicHTML: HTML {
    public var rawHTML: String
    public var document: Document?
    public var rawText: String = ""
    public var markdown: String = ""

    public required init() {
        rawHTML = "Document not initialized correctly."
    }

    public func convertNode(_ node: Node) throws {
        if node.nodeName() == "a" {
            markdown += "["
            for child in node.getChildNodes() {
                try convertNode(child)
            }
            markdown += "]"

            let href = try node.attr("href")
            markdown += "(\(href))"

            return
        } else if node.nodeName() == "br" {
            markdown += "\n"

            return
        } else if node.nodeName() == "ul" {
            try makeUnorderedList(node.getChildNodes())

            return
        } else if node.nodeName() == "ol" {
            try makeOrderedList(node.getChildNodes())

            return
        }

        if node.nodeName() == "#text" && node.description != " " {
            markdown += node.description
        }

        for node in node.getChildNodes() {
            try convertNode(node)
        }
    }

    private func makeUnorderedList(_ nodes: [Node]) throws {
        for node in nodes {
            if (node.nodeName() == "li") {
                markdown += "\n\n- "
            }
            try convertNode(node)
        }
    }

    private func makeOrderedList(_ nodes: [Node]) throws {
        var count = 0
        for node in nodes {
            if (node.nodeName() == "li") {
                count += 1
                markdown += "\n\n\(count). "
            }
            try convertNode(node)
        }
    }
}
