//
//  Rule.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/21/25.
//

import SwiftData

typealias RuleModel = SchemaV3.RuleModel

struct Rule: Codable, Hashable {
    var title: String
    var text: String
}
