//
//  ChatView.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//


import SwiftUI
import MarkdownUI

struct ChatView: View {
    @Binding var conversation: Conversation
    @Binding var messageText: String
    @Binding var isLoading: Bool
    
    let onSendMessage: () -> Void
    let onClearChat: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(conversation.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                Button("Clear Chat") {
                    onClearChat()
                }
                .disabled(conversation.messages.isEmpty)
                #if os(macOS)
                .keyboardShortcut(.delete, modifiers: [.command])
                #endif
            }
            .padding()
            
            Divider()
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(conversation.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                                .padding(.horizontal, 8)
                        }
                        
                        // Loading
                        if isLoading {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Generating...")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .padding(.vertical, 8)
                            .id("loading")
                        }
                    }
                    .padding(.vertical, 16)
                }
                .onChange(of: conversation.messages.count) { _, _ in
                    if let lastMessage = conversation.messages.last {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isLoading) { _, newValue in
                    if newValue {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("loading", anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Input
            HStack(spacing: 12) {
                TextField("Ask a question...", text: $messageText, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .cornerRadius(20)
                    .lineLimit(1...5)
                    .onSubmit {
                        onSendMessage()
                    }
                    #if os(macOS)
                    .keyboardShortcut(.return, modifiers: [.command])
                    #endif
                
                Button(action: onSendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : Color.accentColor)
                }
                .buttonStyle(.bordered)
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                #if os(macOS)
                .keyboardShortcut(.return, modifiers: [])
                #endif
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

// Markdown theme
extension Theme {
    static let custom = Theme()
        .text {
            FontSize(16)
        }
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
            BackgroundColor(.clear)
        }
        .link {
            ForegroundColor(.blue)
        }
        .heading1 { configuration in
            configuration.label
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.bold)
                    FontSize(.em(2))
                }
        }
        .heading2 { configuration in
            configuration.label
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.bold)
                    FontSize(.em(1.5))
                }
        }
        .heading3 { configuration in
            configuration.label
                .markdownMargin(top: 24, bottom: 16)
                .markdownTextStyle {
                    FontWeight(.bold)
                    FontSize(.em(1.25))
                }
        }
        .blockquote { configuration in
            configuration.label
                .markdownMargin(top: 8, bottom: 8)
                .padding(.leading, 16)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 4)
                }
        }
        .listItem { configuration in
            configuration.label
                .markdownMargin(top: 4, bottom: 4)
        }
        .taskListMarker { configuration in
            Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square") //
                .foregroundStyle(configuration.isCompleted ? Color.green : Color.gray) //
                .imageScale(.small)
        }
}

#Preview {
    struct ChatViewPreview: View {
        @State var conversation = Conversation.sample
        @State var messageText = ""
        @State var isLoading = false
        
        var body: some View {
            ChatView(
                conversation: $conversation,
                messageText: $messageText,
                isLoading: $isLoading,
                onSendMessage: {
                    let text = messageText
                    messageText = ""
                    let userMessage = Message(content: text, isUser: true, timestamp: Date())
                    conversation.messages.append(userMessage)
                    isLoading = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        let assistantMessage = Message(content: "This is a response for the preview.", isUser: false, timestamp: Date())
                        conversation.messages.append(assistantMessage)
                        isLoading = false
                    }
                },
                onClearChat: {
                    conversation.messages.removeAll()
                }
            )
        }
    }
    
    return ChatViewPreview()
}
