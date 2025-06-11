//
//  Conversation.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import Foundation

struct Conversation: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var messages: [Message]
    let createdAt: Date

    init(title: String = "New Chat") {
        self.id = UUID()
        self.title = title
        self.messages = []
        self.createdAt = Date()
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        lhs.id == rhs.id
    }

    // Example data
    static let sample: Conversation = {
        var conv = Conversation(title: "Welcome to iOS 26!")
        conv.messages = [
            Message(content: "Hello! How can I help you?", isUser: false, timestamp: Date().addingTimeInterval(-120)),
            Message(content: "What is the capital of the United Kingdom?", isUser: true, timestamp: Date().addingTimeInterval(-60)),
            Message(content: "The capital of the United Kingdom is London.", isUser: false, timestamp: Date())
        ]
        return conv
    }()
}
