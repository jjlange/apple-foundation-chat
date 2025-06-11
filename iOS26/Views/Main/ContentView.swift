//
//  ContentView.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @StateObject private var store = ChatStore()

    // States
    @State private var messageText = ""
    @State private var showingWarning = false
    @State private var showingSettings = false
    @State private var showingShareSheet = false

    var body: some View {
        NavigationSplitView {
            SidebarView(
                store: store,
                showingWarning: $showingWarning,
                showingSettings: $showingSettings,
                onShare: shareConversation
            )
        } detail: {
            if let conversation = store.selectedConversation {
                ChatView(
                    conversation: binding(for: conversation),
                    messageText: $messageText,
                    isLoading: $store.isLoading,
                    onSendMessage: {
                        store.sendMessage(text: messageText)
                        messageText = ""
                    },
                    onClearChat: { store.clearCurrentChat() }
                )
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 60))
                        .foregroundStyle(.tertiary)

                    Text("Select a chat or create a new one")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    Button("New Chat") {
                        store.createNewConversation()
                    }
                    .buttonStyle(.borderedProminent)
                    #if os(macOS)
                    .keyboardShortcut("n", modifiers: [.command])
                    #endif
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray))
            }
        }
        .navigationSplitViewStyle(.balanced)
        .alert("AI Usage", isPresented: $showingWarning) {
            Button("Understood") { }
        } message: {
            Text("This app uses the Apple FoundationModels framework to interact with a local large language model. \n\nRequests stay on-device and do not require an internet connection. \n\nAlways verify the accuracy of information.")
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(store: store)
        }
        .sheet(isPresented: $showingShareSheet) {
            if let conversation = store.selectedConversation {
                ShareSheet(activityItems: [formatConversationForSharing(conversation)])
                    .presentationDetents([.medium])
            }
        }
    }

    private func binding(for conversation: Conversation) -> Binding<Conversation> {
        guard let index = store.conversations.firstIndex(where: { $0.id == conversation.id }) else {
            fatalError("Conversation not found")
        }
        return $store.conversations[index]
    }
    
    private func shareConversation(_ conversation: Conversation) {
        store.selectedConversation = conversation
        showingShareSheet = true
    }

    private func formatConversationForSharing(_ conversation: Conversation) -> String {
        var text = "Chat: \(conversation.title)\n\n"
        for message in conversation.messages {
            let role = message.isUser ? "User" : "Assistant"
            let edited = message.isEdited ? " (edited)" : ""
            text += "\(role)\(edited): \(message.content)\n\n"
        }
        return text
    }
}

#Preview {
    ContentView()
}
