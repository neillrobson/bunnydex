//
//  SchemaV1.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/21/25.
//

import SwiftData

enum SchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { .init(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [SchemaV1.CardModel.self]
    }
}
