//
//  StorageManager.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import Foundation

class StorageManager {
    private static let conversationsKey = "savedConversations"
    
    static func saveConversations(_ conversations: [Conversation]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(conversations)
            UserDefaults.standard.set(data, forKey: conversationsKey)
        } catch {
            print("Error saving conversations: \(error)")
        }
    }
    
    static func loadConversations() -> [Conversation] {
        guard let data = UserDefaults.standard.data(forKey: conversationsKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Conversation].self, from: data)
        } catch {
            print("Error loading conversations: \(error)")
            return []
        }
    }
} 
