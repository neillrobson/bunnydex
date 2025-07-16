//
//  CardMigrationPlan.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/16/25.
//

import SwiftData

enum CardMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [CardSchemaV1.self] }

    static var stages: [MigrationStage] { [] }
}
