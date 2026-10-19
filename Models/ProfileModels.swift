import SwiftUI

// MARK: - Focus Style

enum FocusStyle: String, CaseIterable, Identifiable {
    case deepWork = "Deep Work"
    case balanced = "Balanced"
    case flexible = "Flexible"
    case sprint = "Sprint"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .deepWork:
            return "Long, uninterrupted focus sessions"
        case .balanced:
            return "Mix of focused work and breaks"
        case .flexible:
            return "Adapt to your energy throughout the day"
        case .sprint:
            return "Short, intense bursts of productivity"
        }
    }
    
    var icon: String {
        switch self {
        case .deepWork: return "brain.head.profile"
        case .balanced: return "scale.3d"
        case .flexible: return "leaf"
        case .sprint: return "bolt.fill"
        }
    }
}

// MARK: - Life Area

enum LifeArea: String, CaseIterable, Identifiable {
    case career = "Career"
    case health = "Health"
    case mindset = "Mindset"
    case learning = "Learning"
    case relationships = "Relationships"
    case finance = "Finance"
    case creativity = "Creativity"
    case adventure = "Adventure"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .career: return "briefcase.fill"
        case .health: return "heart.fill"
        case .mindset: return "brain"
        case .learning: return "book.fill"
        case .relationships: return "person.2.fill"
        case .finance: return "dollarsign.circle.fill"
        case .creativity: return "paintbrush.fill"
        case .adventure: return "location.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .career: return .blue
        case .health: return .red
        case .mindset: return .purple
        case .learning: return .green
        case .relationships: return .pink
        case .finance: return .yellow
        case .creativity: return .orange
        case .adventure: return .teal
        }
    }

    var tint: Color { color }

    var emoji: String {
        switch self {
        case .career: return "💼"
        case .health: return "❤️"
        case .mindset: return "🧠"
        case .learning: return "📚"
        case .relationships: return "🤝"
        case .finance: return "💰"
        case .creativity: return "🎨"
        case .adventure: return "🧭"
        }
    }
}
