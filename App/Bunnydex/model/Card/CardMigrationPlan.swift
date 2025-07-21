//
//  CardMigrationPlan.swift
//  Bunnydex
//
//  Created by Neill Robson on 7/16/25.
//

import SwiftData

// This extension should not be needed in iOS 26
// See https://developer.apple.com/forums/thread/756802
extension MigrationStage: @unchecked @retroactive Sendable { }

enum CardMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [SchemaV1.self, SchemaV1_1.self] }

    static var stages: [MigrationStage] { [migrateV1ToV1_1] }

    static let migrateV1ToV1_1 = MigrationStage.custom(
        fromVersion: SchemaV1.self,
        toVersion: SchemaV1_1.self,
        willMigrate: nil,
        didMigrate: { context in
            let cards = try context.fetch(FetchDescriptor<SchemaV1_1.CardModel>())

            for card in cards {
                for rule in card.rules {
                    card.newRules.append(.init(rule))
                }
            }

            try context.save()
        }
    )
}
