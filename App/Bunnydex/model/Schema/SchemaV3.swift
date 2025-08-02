//
//  SchemaV3.swift
//  Bunnydex
//
//  Created by Neill Robson on 8/2/25.
//

import SwiftData

enum SchemaV3 : VersionedSchema {
    static var versionIdentifier: Schema.Version { .init(3, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [CardModel.self, RuleModel.self]
    }
}
