import SwiftUI
import Foundation

// MARK: - Message Role

enum MessageRole: String, Codable {
    case user, assistant
}

// MARK: - Chat Message

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let role: MessageRole
    var content: String
    let timestamp: Date
    var isStreaming: Bool

    init(id: UUID = UUID(), role: MessageRole, content: String,
         timestamp: Date = Date(), isStreaming: Bool = false) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.isStreaming = isStreaming
    }
}

// MARK: - Coach Prompts

struct CoachPrompt: Identifiable {
    let id = UUID()
    let emoji: String
    let label: String
    let message: String
    let tint: Color
}

enum CoachPrompts {
    static let suggestions: [CoachPrompt] = [
        CoachPrompt(emoji: "🎯", label: "Plan my day", message: "Help me plan an optimal and balanced day. I want to be productive but also take care of my wellbeing.", tint: Theme.primary),
        CoachPrompt(emoji: "🧠", label: "Beat procrastination", message: "I'm struggling with procrastination. Give me a personalised strategy to start and stay on task today.", tint: Theme.secondary),
        CoachPrompt(emoji: "💪", label: "Build habits", message: "I want to build stronger daily habits. What's the best approach based on my current goals?", tint: Theme.rose),
        CoachPrompt(emoji: "🌙", label: "Wind down", message: "Help me design a calming evening routine that sets me up for great sleep and a strong tomorrow.", tint: Theme.mint),
        CoachPrompt(emoji: "📈", label: "Review my week", message: "I want to reflect on my week. Help me identify what went well, what didn't, and how to improve.", tint: Theme.accent),
        CoachPrompt(emoji: "🧘", label: "Reduce stress", message: "I'm feeling overwhelmed. Give me practical, immediate strategies to reduce stress and regain focus.", tint: Theme.mint)
    ]
}


