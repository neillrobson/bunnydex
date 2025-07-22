//
//  RuleSchemaV2.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/21/25.
//

import SwiftData

extension SchemaV2 {
    @Model
    final class RuleModel {
        var title: String
        var text: String
        var order: Int = 0

        var card: CardModel?

        init(_ rule: Rule) {
            self.title = rule.title
            self.text = rule.text
        }

        init(title: String = "", text: String = "") {
            self.title = title
            self.text = text
        }

        var rule: Rule {
            .init(title: title, text: text)
        }
    }
}
