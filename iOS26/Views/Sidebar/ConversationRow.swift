//
//  ConversationRow.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import SwiftUI

struct ConversationRow: View {
    @Binding var conversation: Conversation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(conversation.title)
                .font(.headline)
                .fontWeight(.medium)
                .lineLimit(2)
                .foregroundStyle(.primary)
            
            Text(conversation.createdAt.timeAgoDisplay())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
    }
}

#Preview {
    ConversationRow(conversation: .constant(Conversation.sample))
        .padding()
}
