//
//  AppState.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isSidebarVisible: Bool = true
    @Published var isFullScreen: Bool = false
    @Published var recentChats: [Chat] = []
    @Published var currentChat: Chat?
    
    func toggleSidebar() {
        isSidebarVisible.toggle()
    }
    
    func toggleFullScreen() {
        isFullScreen.toggle()
    }
    
    func createNewChat() {
        let newChat = Chat(id: UUID(), title: "New Chat", messages: [], createdAt: Date())
        currentChat = newChat
        recentChats.insert(newChat, at: 0)
    }
    
    func openChat(_ chat: Chat) {
        currentChat = chat
    }
} 
