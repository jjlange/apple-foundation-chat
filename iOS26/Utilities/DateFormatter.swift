//
//  DateFormatter.swift
//  iOS26
//
//  Created by Justin Lange on 10/06/2025.
//

import Foundation

extension Date {
    /// Formats the date into a relative time string (e.g., "1 hour ago", "Yesterday").
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()

        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: now)

        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        } else if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        } else if let days = components.day, days > 0 {
            return days == 1 ? "Yesterday" : "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return "Just now"
        }
    }
}
