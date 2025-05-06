//
//  Card.swift
//  Bunnydex
//
//  Created by Neill Robson on 5/5/25.
//

import Foundation
import SwiftData

@Model
class Card: Codable {
    enum CodingKeys: CodingKey {
        case id
        case title
    }

    var id: String
    var title: String

    init(id: String, title: String) {
        self.id = id
        self.title = title
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
    }
}
