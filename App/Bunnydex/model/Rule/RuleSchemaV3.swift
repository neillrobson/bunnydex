//
//  RuleSchemaV3.swift
//  Bunnydex
//
//  Created by Neill Robson on 8/2/25.
//

import SwiftData

extension SchemaV3 {
    @Model
    final class RuleModel {
        var id: ObjectIdentifier {
            ObjectIdentifier(self)
        }

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
