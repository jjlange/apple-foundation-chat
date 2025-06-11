//
//  ChatStore.swift
//  iOS26                                  
//
//  Created by Justin Lange on 09/06/2025.
//

import SwiftUI
import FoundationModels
import Combine

@MainActor
class ChatStore: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var selectedConversation: Conversation?
    @Published var isLoading = false
    @Published var systemPrompt: String = "You are a helpful assistant."
    
    init() {
        conversations = StorageManager.loadConversations()
        
        if conversations.isEmpty {
            createNewConversation()
        } else {
            selectedConversation = conversations.first
        }
    }
    
    func createNewConversation() {
        let newConversation = Conversation()
        conversations.insert(newConversation, at: 0)
        selectedConversation = newConversation
        saveConversations()
    }
    
    func deleteConversation(_ conversation: Conversation) {
        conversations.removeAll { $0.id == conversation.id }
        if selectedConversation?.id == conversation.id {
            selectedConversation = conversations.first
        }
        saveConversations()
    }
    
    func clearCurrentChat() {
        guard let currentConversation = selectedConversation,
              let index = conversations.firstIndex(where: { $0.id == currentConversation.id }) else { return }
        
        conversations[index].messages.removeAll()
        conversations[index].title = "New Chat"
        
        selectedConversation = conversations[index]
        saveConversations()
    }
    
    func sendMessage(text: String) {
        guard let currentConversation = selectedConversation,
              let index = conversations.firstIndex(where: { $0.id == currentConversation.id }) else { return }
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
    
        let userMessage = Message(content: trimmedText, isUser: true, timestamp: Date())
        conversations[index].messages.append(userMessage)
        
        // Update conversation title
        if conversations[index].messages.count == 1 {
            Task {
                do {
                    let session = LanguageModelSession(instructions: "Generate a concise, descriptive title (max 50 characters) for a conversation that starts with this message. Return only the title text, no additional formatting or explanation.")
                    let response = try await session.respond(to: "Generate a title for this conversation: \(trimmedText)")
                    let title = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
                    conversations[index].title = title
                    selectedConversation = conversations[index]
                    saveConversations()
                } catch {
                    // Fallback to simple title if AI generation fails
                    let title = String(trimmedText.prefix(50))
                    conversations[index].title = title.count < trimmedText.count ? title + "..." : title
                    selectedConversation = conversations[index]
                    saveConversations()
                }
            }
        }
        
        selectedConversation = conversations[index]
        isLoading = true
        saveConversations()
        
        Task {
            do {
                let response = try await processRequest(text: trimmedText)
                
                guard let freshIndex = conversations.firstIndex(where: { $0.id == currentConversation.id }) else { return }
                let assistantMessage = Message(content: response, isUser: false, timestamp: Date())
                conversations[freshIndex].messages.append(assistantMessage)
                selectedConversation = conversations[freshIndex]
                saveConversations()
                
            } catch {
                guard let freshIndex = conversations.firstIndex(where: { $0.id == currentConversation.id }) else { return }
                let errorMessage = Message(content: "Sorry, I encountered an error: \(error.localizedDescription)", isUser: false, timestamp: Date())
                conversations[freshIndex].messages.append(errorMessage)
                selectedConversation = conversations[freshIndex]
                saveConversations()
                print("Error: \(error)")
            }
            isLoading = false
        }
    }
    
    func editMessage(_ message: Message, newContent: String) {
        guard let currentConversation = selectedConversation,
              let conversationIndex = conversations.firstIndex(where: { $0.id == currentConversation.id }),
              let messageIndex = conversations[conversationIndex].messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        
        conversations[conversationIndex].messages[messageIndex].content = newContent
        conversations[conversationIndex].messages[messageIndex].isEdited = true
        
        // Remove all messages after the edited message
        conversations[conversationIndex].messages.removeSubrange((messageIndex + 1)...)
        
        // Re-send the edited message
        sendMessage(text: newContent)
        
        selectedConversation = conversations[conversationIndex]
        saveConversations()
    }
    
    func updateSystemPrompt(_ newPrompt: String) {
        systemPrompt = newPrompt
        UserDefaults.standard.set(newPrompt, forKey: "systemPrompt")
    }
    
    func resetSystemPrompt() {
        systemPrompt = "You are a helpful assistant."
        UserDefaults.standard.removeObject(forKey: "systemPrompt")
    }
    
    private func processRequest(text: String) async throws -> String {
        let session = LanguageModelSession(instructions: systemPrompt)
        let response = try await session.respond(to: text)
        var content = response.content
        
        content = content.replacingOccurrences(of: "```markdown", with: "")
        content = content.replacingOccurrences(of: "```", with: "")
        
        return content
    }
    
    private func saveConversations() {
        StorageManager.saveConversations(conversations)
    }
}
