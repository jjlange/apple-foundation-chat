//
//  ViewModifier.swift
//  iOS26
//
//  Created by Justin Lange on 11/06/2025.
//

import SwiftUI

extension View {    
    // Markdown modifier
    func markdownStyle() -> some View {
        self
            .textCase(nil)
            .kerning(0)
            .lineSpacing(4)
            .environment(\.layoutDirection, .leftToRight)
    }
}
