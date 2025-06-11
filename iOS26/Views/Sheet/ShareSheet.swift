//
//  ShareSheet.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import SwiftUI

struct ShareSheet: View {
    let activityItems: [Any]
    
    var body: some View {
        if let text = activityItems.first as? String {
            ShareLink(item: text) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } else {
            EmptyView()
        }
    }
}
