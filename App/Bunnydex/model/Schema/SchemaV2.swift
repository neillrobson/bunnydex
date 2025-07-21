//
//  SchemaV2.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/21/25.
//

import SwiftData

enum SchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version { .init(2, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [CardModel.self, RuleModel.self]
    }
}
