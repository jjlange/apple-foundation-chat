//
//  MessageBubble.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import SwiftUI
import MarkdownUI

struct MessageBubble: View {
    let message: Message
    @State private var isEditing = false
    @State private var editedContent: String = ""
    @EnvironmentObject private var store: ChatStore

    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if isEditing {
                    TextField("Edit message", text: $editedContent, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    #if os(iOS)
                        .background(
                            Color(uiColor: .systemBackground)
                        )
                    #else
                        .background(
                            Color(nsColor: .windowBackgroundColor)
                        )
                    #endif
                        .cornerRadius(16)
                        .onSubmit {
                            store.editMessage(message, newContent: editedContent)
                            isEditing = false
                        }
                } else {
                    Markdown(message.content)
                        .textSelection(.enabled)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        #if os(iOS)
                        .background(message.isUser ? Color.accentColor :
                            Color(uiColor: .systemGray6)
                        )
                        #else
                        .background(message.isUser ? Color.accentColor :
                            Color(nsColor: .controlBackgroundColor)
                        )
                        #endif
                        .foregroundStyle(message.isUser ? .white :
                                .black
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .markdownTheme(.custom)
                        .contextMenu {
                            if message.isUser {
                                Button(action: {
                                    editedContent = message.content
                                    isEditing = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }

                            Button(action: {
                                #if os(macOS)
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(message.content, forType: .string)
                                #else
                                UIPasteboard.general.string = message.content
                                #endif
                            }) {
                                Label("Copy", systemImage: "doc.on.doc")
                            }

                            ShareLink(item: message.content) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                }

                HStack(spacing: 4) {
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    if message.isEdited {
                        Text("(edited)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 4)
            }

            if !message.isUser {
                Spacer(minLength: 60)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        if let userMessage = Conversation.sample.messages.first(where: { $0.isUser }) {
            MessageBubble(message: userMessage)
        }
        if let assistantMessage = Conversation.sample.messages.first(where: { !$0.isUser }) {
            MessageBubble(message: assistantMessage)
        }
    }
    .padding()
    .environmentObject(ChatStore())
}
