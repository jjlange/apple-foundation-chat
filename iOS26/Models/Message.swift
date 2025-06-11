//
//  Message.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import Foundation

struct Message: Identifiable, Hashable, Codable {
    let id: UUID
    var content: String
    let isUser: Bool
    let timestamp: Date
    var isEdited: Bool

    init(content: String, isUser: Bool, timestamp: Date, isEdited: Bool = false) {
        self.id = UUID()
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
        self.isEdited = isEdited
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}
