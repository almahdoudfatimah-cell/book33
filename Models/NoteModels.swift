import SwiftUI

// MARK: - Note Category
enum NoteCategory: String, CaseIterable, Codable {
    case all        = "All"
    case ideas      = "Ideas"
    case journal    = "Journal"
    case goals      = "Goals"
    case learning   = "Learning"
    case gratitude  = "Gratitude"

    var emoji: String {
        switch self {
        case .all:       return "📋"
        case .ideas:     return "💡"
        case .journal:   return "📓"
        case .goals:     return "🎯"
        case .learning:  return "📚"
        case .gratitude: return "🙏"
        }
    }

    var tint: Color {
        switch self {
        case .all:       return Theme.primary
        case .ideas:     return Theme.accent
        case .journal:   return Theme.secondary
        case .goals:     return Theme.primary
        case .learning:  return Theme.mint
        case .gratitude: return Theme.rose
        }
    }
}

// MARK: - Note card color palette
enum NoteColor: String, CaseIterable, Codable {
    case indigo   = "Pink"
    case lavender = "Blush"
    case peach    = "Peach"
    case mint     = "Mint"
    case rose     = "Rose"
    case sky      = "Sky"
    case butter   = "Butter"
    case sage     = "Sage"

    var color: Color {
        switch self {
        case .indigo:   return Color(red: 1.00, green: 0.58, blue: 0.05)  // Vivid orange
        case .lavender: return Color(red: 1.00, green: 0.82, blue: 0.00)  // Golden yellow
        case .peach:    return Color(red: 1.00, green: 0.68, blue: 0.25)  // Warm amber
        case .mint:     return Color(red: 0.25, green: 0.78, blue: 0.40)  // Fresh green
        case .rose:     return Color(red: 0.85, green: 0.32, blue: 0.00)  // Burnt orange
        case .sky:      return Color(red: 0.55, green: 0.88, blue: 0.30)  // Lime green
        case .butter:   return Color(red: 1.00, green: 0.95, blue: 0.60)  // Pale yellow
        case .sage:     return Color(red: 0.30, green: 0.65, blue: 0.35)  // Deep sage
        }
    }

    var cardBackground: Color {
        color.opacity(0.13)
    }
}

// MARK: - Note model
struct Note: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var body: String
    var category: NoteCategory
    var color: NoteColor
    var isPinned: Bool
    var createdAt: Date
    var updatedAt: Date
    // Stored as comma-separated hex strings placeholder — we use emoji tags instead
    var tags: [String]

    init(id: UUID = UUID(), title: String, body: String,
         category: NoteCategory = .ideas, color: NoteColor = .indigo,
         isPinned: Bool = false, tags: [String] = [],
         createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id; self.title = title; self.body = body
        self.category = category; self.color = color
        self.isPinned = isPinned; self.tags = tags
        self.createdAt = createdAt; self.updatedAt = updatedAt
    }
}

// MARK: - Sample notes
enum SampleNotes {
    static let all: [Note] = [
        Note(title: "Q3 Vision Board", body: "🚀 Launch the new product feature by July\n📈 Grow team to 8 people\n💰 Hit $50k MRR\n🌍 Attend one international conference\n\nThe key this quarter is staying focused on what moves the needle, not just staying busy.", category: .goals, color: .indigo, isPinned: true, tags: ["work", "strategy"]),

        Note(title: "Morning Pages · May 5", body: "Woke up feeling surprisingly clear today. The early run really does something to my mind — it's like it burns off the mental fog before the day even starts.\n\nI want to be more intentional about how I start meetings. Less reacting, more leading.", category: .journal, color: .lavender, isPinned: false, tags: ["morning", "reflection"]),

        Note(title: "App Idea: Habit Streaks 2.0", body: "💡 What if streaks had a social layer? Share milestones with a small accountability group.\n\n- Push notification when a friend breaks their streak\n- Weekly leaderboard (opt-in)\n- Celebration animations at 7, 14, 30 days\n\nNeeds: backend, notifications, friend graph", category: .ideas, color: .peach, isPinned: true, tags: ["product", "idea"]),

        Note(title: "Atomic Habits — Key Notes", body: "📖 Chapter 5: The Best Way to Start a New Habit\n\n• Implementation intention: I will [BEHAVIOUR] at [TIME] in [LOCATION]\n• Habit stacking: After [CURRENT HABIT], I will [NEW HABIT]\n• Environment design beats motivation every time\n\n'You don't rise to the level of your goals, you fall to the level of your systems.'", category: .learning, color: .mint, isPinned: false, tags: ["books", "habits"]),

        Note(title: "Gratitude · This Week", body: "🙏 Three things I'm genuinely grateful for:\n\n1. The long phone call with Dad on Sunday — we haven't talked like that in months\n2. Finding that quiet coffee shop to work from on Wednesday\n3. My team stepping up without being asked during the crunch\n\nGratitude reframes everything.", category: .gratitude, color: .rose, isPinned: false, tags: ["daily", "wellbeing"]),

        Note(title: "Spanish Vocab · Week 4", body: "🇪🇸 New words this week:\n\n• Madrugada — the small hours (2–6am)\n• Sobremesa — the time spent talking after a meal\n• Estrenar — to use or wear something for the first time\n• Trasnochar — to stay up all night\n\nPhrases: '¿Qué tal llevas el día?' / 'Estoy en ello'", category: .learning, color: .sky, isPinned: false, tags: ["spanish", "language"]),

        Note(title: "Evening Reflection · May 4", body: "What went well: Stayed off social media until noon. Finished the design spec. Great deep work session.\n\nWhat could be better: Skipped the afternoon walk. Got pulled into two unplanned calls.\n\nTomorrow's one thing: Ship the onboarding flow mockup.", category: .journal, color: .sage, isPinned: false, tags: ["evening", "review"]),

        Note(title: "Gift Ideas for June", body: "🎁 Birthday ideas:\n• Mum — spa day voucher or the cookbook she mentioned\n• Tom — noise-cancelling headphones (Sony WH-1000XM5)\n• Sara — personalised star map from that night in Lisbon\n\nBudget: ~£80 each", category: .ideas, color: .butter, isPinned: false, tags: ["personal", "gifts"])
    ]
}
