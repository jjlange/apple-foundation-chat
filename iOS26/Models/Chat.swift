import Foundation

struct Chat: Identifiable, Codable {
    let id: UUID
    var title: String
    var messages: [Message]
    let createdAt: Date
    
    struct Message: Identifiable, Codable {
        let id: UUID
        let content: String
        let isUser: Bool
        let timestamp: Date
        
        init(content: String, isUser: Bool) {
            self.id = UUID()
            self.content = content
            self.isUser = isUser
            self.timestamp = Date()
        }
    }
} 