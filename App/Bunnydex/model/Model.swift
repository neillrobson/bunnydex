//
//  Model.swift
//  Bunnydex
//
//  Created by Neill Robson on 8/8/25.
//

import Foundation
import SwiftData

public struct Model<T: PersistentModel>: Sendable, Hashable, Identifiable {
    public let persistentIdentifier: PersistentIdentifier
    public var id: PersistentIdentifier.ID { persistentIdentifier.id }

    public init(persistentIdentifier: PersistentIdentifier) {
        self.persistentIdentifier = persistentIdentifier
    }
}

extension Model {
    public init(_ model: T) {
        self.init(persistentIdentifier: model.persistentModelID)
    }
}
