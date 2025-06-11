//
//  iOS26App.swift
//  iOS26
//
//  Created by Justin Lange on 09/06/2025.
//

import SwiftUI

@main
struct iOS26App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
                #endif
        }
        #if os(iPadOS)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(replacing: .newItem) { }
            
            CommandMenu("Chat") {
                Button("New Chat") {
                    // Handle new chat action
                }
                .keyboardShortcut("n", modifiers: [.command])
                
                Button("Open Recent") {
                    // Handle open recent action
                }
                .keyboardShortcut("o", modifiers: [.command])
                
                Divider()
                
                Button("Settings") {
                    // Handle settings action
                }
                .keyboardShortcut(",", modifiers: [.command])
            }
            
            CommandMenu("View") {
                Button("Toggle Sidebar") {
                    // Handle sidebar toggle
                }
                .keyboardShortcut("s", modifiers: [.command, .shift])
                
                Button("Toggle Full Screen") {
                    // Handle full screen toggle
                }
                .keyboardShortcut("f", modifiers: [.command, .control])
            }
        }
        #endif
    }
}
