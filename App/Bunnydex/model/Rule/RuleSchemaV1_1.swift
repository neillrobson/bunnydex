//
//  RuleSchemaV1_1.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/21/25.
//

import SwiftData

extension SchemaV1_1 {
    @Model
    final class RuleModel {
        var title: String
        var text: String

        var card: CardModel?

        init(_ rule: Rule) {
            self.title = rule.title
            self.text = rule.text
        }

        var rule: Rule {
            .init(title: title, text: text)
        }
    }
}
