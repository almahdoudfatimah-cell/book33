import SwiftUI

// MARK: - Project Status
enum ProjectStatus: String, CaseIterable, Codable {
    case active    = "Active"
    case paused    = "Paused"
    case completed = "Completed"

    var tint: Color {
        switch self {
        case .active:    return Theme.primary
        case .paused:    return Theme.secondary
        case .completed: return Color(red: 0.27, green: 0.76, blue: 0.57)
        }
    }
    var icon: String {
        switch self {
        case .active:    return "bolt.fill"
        case .paused:    return "pause.fill"
        case .completed: return "checkmark.seal.fill"
        }
    }
}

// MARK: - Project Category
enum ProjectCategory: String, CaseIterable, Codable {
    case career   = "Career"
    case health   = "Health"
    case learn    = "Learning"
    case creative = "Creative"
    case finance  = "Finance"
    case personal = "Personal"

    var icon: String {
        switch self {
        case .career:   return "briefcase.fill"
        case .health:   return "heart.fill"
        case .learn:    return "graduationcap.fill"
        case .creative: return "paintpalette.fill"
        case .finance:  return "chart.line.uptrend.xyaxis"
        case .personal: return "star.fill"
        }
    }
    var tint: Color {
        switch self {
        case .career:   return Theme.primary
        case .health:   return Color(red: 0.96, green: 0.45, blue: 0.65)
        case .learn:    return Theme.secondary
        case .creative: return Color(red: 0.88, green: 0.50, blue: 0.98)
        case .finance:  return Color(red: 0.27, green: 0.76, blue: 0.57)
        case .personal: return Theme.accent
        }
    }
}

// MARK: - Milestone
struct Milestone: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var isDone: Bool = false
    var dueDate: Date?
    var note: String = ""
}

// MARK: - AIProject
struct AIProject: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var emoji: String
    var category: ProjectCategory
    var status: ProjectStatus
    var milestones: [Milestone]
    var createdAt: Date = Date()
    var targetDate: Date?
    var isPinned: Bool = false

    var progress: Double {
        guard !milestones.isEmpty else { return 0 }
        return Double(milestones.filter { $0.isDone }.count) / Double(milestones.count)
    }
    var completedMilestones: Int { milestones.filter { $0.isDone }.count }
    var daysUntilTarget: Int? {
        guard let target = targetDate else { return nil }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: target).day ?? 0
        return max(0, days)
    }
}

// MARK: - Sample Projects
enum SampleProjects {
    static let all: [AIProject] = [
        AIProject(
            title: "Build My Brand Online",
            description: "Grow a personal brand from zero to 10k followers and land brand deals within 6 months.",
            emoji: "✨",
            category: .career,
            status: .active,
            milestones: [
                Milestone(title: "Choose content niche & audience", isDone: true),
                Milestone(title: "Design brand identity & bio", isDone: true),
                Milestone(title: "Publish first 10 posts", isDone: true),
                Milestone(title: "Reach 1k followers", isDone: false),
                Milestone(title: "Collaborate with 3 creators", isDone: false),
                Milestone(title: "Land first brand partnership", isDone: false)
            ],
            targetDate: Calendar.current.date(byAdding: .month, value: 4, to: Date()),
            isPinned: true
        ),
        AIProject(
            title: "Run a Half Marathon",
            description: "Complete a half marathon in under 2 hours by training 4x per week.",
            emoji: "🏃",
            category: .health,
            status: .active,
            milestones: [
                Milestone(title: "Complete week 1 training plan", isDone: true),
                Milestone(title: "Run 5k without stopping", isDone: true),
                Milestone(title: "Run 10k race", isDone: true),
                Milestone(title: "Long run: 16km", isDone: false),
                Milestone(title: "Register for half marathon", isDone: false),
                Milestone(title: "Race day — finish line! 🏅", isDone: false)
            ],
            targetDate: Calendar.current.date(byAdding: .month, value: 2, to: Date())
        ),
        AIProject(
            title: "Learn Spanish B2",
            description: "Reach conversational fluency in Spanish using daily lessons and immersion.",
            emoji: "🇪🇸",
            category: .learn,
            status: .active,
            milestones: [
                Milestone(title: "Complete A1 Duolingo course", isDone: true),
                Milestone(title: "Learn 500 most common words", isDone: true),
                Milestone(title: "Finish A2 grammar workbook", isDone: false),
                Milestone(title: "Hold 10-min conversation", isDone: false),
                Milestone(title: "Pass B1 mock test", isDone: false),
                Milestone(title: "Watch a movie with no subtitles", isDone: false)
            ],
            targetDate: Calendar.current.date(byAdding: .month, value: 6, to: Date())
        ),
        AIProject(
            title: "Creative Photography Project",
            description: "Shoot and publish a 52-photo series — one theme per week for a year.",
            emoji: "📸",
            category: .creative,
            status: .paused,
            milestones: [
                Milestone(title: "Buy prime lens", isDone: true),
                Milestone(title: "Shoot first 4 themes", isDone: true),
                Milestone(title: "Create Instagram portfolio", isDone: false),
                Milestone(title: "Complete 26 weeks", isDone: false),
                Milestone(title: "Print & frame best 12 shots", isDone: false)
            ]
        )
    ]
}
