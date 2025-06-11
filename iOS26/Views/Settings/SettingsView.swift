//
//  SettingsView.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: ChatStore
    @State private var systemPrompt: String
    
    init(store: ChatStore) {
        self.store = store
        _systemPrompt = State(initialValue: store.systemPrompt)
    }
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            settingsContent
        }
        #else
        settingsContent
        #endif
    }
    
    private var settingsContent: some View {
        Form {
            Section("System Prompt") {
                TextEditor(text: $systemPrompt)
                    .frame(height: 100)
                
                HStack {
                    Button("Reset to Default") {
                        store.resetSystemPrompt()
                        systemPrompt = store.systemPrompt
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        store.updateSystemPrompt(systemPrompt)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    SettingsView(store: ChatStore())
}
