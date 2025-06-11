//
//  SidebarView.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import SwiftUI

struct SidebarView: View {
    @ObservedObject var store: ChatStore
    
    // Bindings
    @Binding var showingWarning: Bool
    @Binding var showingSettings: Bool
    
    var onShare: (Conversation) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Chats")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack() {
                        Button(action: { showingSettings = true }) {
                            Image(systemName: "gear")
                                .font(.title2)
                                .foregroundStyle(.primary)
                        }
                        #if os(macOS)
                        .keyboardShortcut(",", modifiers: [.command])
                        #endif
                        
                        Button(action: { store.createNewConversation() }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundStyle(.primary)
                        }
                        #if os(macOS)
                        .keyboardShortcut("n", modifiers: [.command])
                        #endif
                    }
                }
            }
            
            Divider()
            
            // Conversations
            List(store.conversations, selection: $store.selectedConversation) { conversation in
                ConversationRow(conversation: binding(for: conversation))
                    .tag(conversation)
                    .modifier(ConversationRowStyle(isSelected: store.selectedConversation?.id == conversation.id))
                    .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                store.deleteConversation(conversation)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            onShare(conversation)
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up.fill")
                        }
                        .tint(.blue)
                    }
                    .contextMenu {
                        Button(action: {
                            onShare(conversation)
                        }) {
                            Label("Share Chat", systemImage: "square.and.arrow.up")
                        }
                        
                        Divider()
                        
                        Button("Delete", role: .destructive) {
                            store.deleteConversation(conversation)
                        }
                    }
                    #if os(iOS)
                    .hoverEffect(.lift)
                    #endif
                    .animation(.easeInOut(duration: 0.15), value: store.selectedConversation?.id)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(color: Color.black.opacity(0.02), radius: 1, x: 0, y: 1)
            
            Spacer()
            
            // AI Warning
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color(.systemGray))
                    .frame(height: 0.5)
                    .opacity(0.6)
                
                Button(action: {
                    showingWarning = true
                }) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.15))
                                .frame(width: 24, height: 24)
                            
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                                .font(.caption)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("AI can make mistakes")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            
                            Text("Always verify information")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                #if os(iOS)
                .hoverEffect(.lift)
                #endif
            }
        }
        .frame(minWidth: 250)
    }
    
    private func binding(for conversation: Conversation) -> Binding<Conversation> {
        guard let index = store.conversations.firstIndex(where: { $0.id == conversation.id }) else {
            fatalError("Conversation not found")
        }
        return $store.conversations[index]
    }
}

