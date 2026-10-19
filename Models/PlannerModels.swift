import SwiftUI

struct PlanTask: Identifiable, Hashable {
    let id: UUID
    var title: String
    var time: String
    var hour: Int          // 0–23 for timeline placement
    var durationSlots: Int // how many 30-min slots it spans (min 1)
    var category: TaskCategory
    var isDone: Bool
    var aiSuggested: Bool
    var date: Date

    init(id: UUID = UUID(), title: String, time: String, hour: Int,
         durationSlots: Int = 2, category: TaskCategory,
         isDone: Bool = false, aiSuggested: Bool = false, date: Date = Date()) {
        self.id = id
        self.title = title
        self.time = time
        self.hour = hour
        self.durationSlots = durationSlots
        self.category = category
        self.isDone = isDone
        self.aiSuggested = aiSuggested
        self.date = date
    }
}

enum TaskCategory: String, CaseIterable {
    case focus   = "Focus"
    case health  = "Health"
    case mindful = "Mindful"
    case social  = "Social"
    case learn   = "Learn"

    var icon: String {
        switch self {
        case .focus:   return "target"
        case .health:  return "heart.fill"
        case .mindful: return "leaf.fill"
        case .social:  return "person.2.fill"
        case .learn:   return "book.fill"
        }
    }

    var tint: Color {
        switch self {
        case .focus:   return Theme.primary
        case .health:  return Theme.rose
        case .mindful: return Theme.mint
        case .social:  return Theme.accent
        case .learn:   return Theme.secondary
        }
    }
}

struct LifeGoal: Identifiable {
    let id = UUID()
    var title: String
    var emoji: String
    var progress: Double
    var streak: Int
    var color: Color
}

struct DailyMetric: Identifiable {
    let id = UUID()
    var label: String
    var value: String
    var icon: String
    var tint: Color
}

enum SampleData {
    static func tasks(for date: Date) -> [PlanTask] {
        let cal = Calendar.current
        let isToday = cal.isDateInToday(date)
        let isTomorrow = cal.isDateInTomorrow(date)

        if isToday {
            return [
                PlanTask(title: "Morning meditation", time: "6:30 AM", hour: 6, durationSlots: 1, category: .mindful, isDone: true, aiSuggested: false, date: date),
                PlanTask(title: "Breakfast & stretch", time: "7:30 AM", hour: 7, durationSlots: 1, category: .health, isDone: true, aiSuggested: false, date: date),
                PlanTask(title: "Review daily priorities", time: "8:30 AM", hour: 8, durationSlots: 1, category: .focus, isDone: true, aiSuggested: true, date: date),
                PlanTask(title: "Deep work: Q3 strategy doc", time: "9:30 AM", hour: 9, durationSlots: 3, category: .focus, isDone: true, aiSuggested: true, date: date),
                PlanTask(title: "Lunch walk in the park", time: "12:30 PM", hour: 12, durationSlots: 2, category: .health, isDone: false, aiSuggested: true, date: date),
                PlanTask(title: "Team sync standup", time: "2:00 PM", hour: 14, durationSlots: 1, category: .social, isDone: false, aiSuggested: false, date: date),
                PlanTask(title: "Read 20 pages of Atomic Habits", time: "3:00 PM", hour: 15, durationSlots: 2, category: .learn, isDone: false, aiSuggested: false, date: date),
                PlanTask(title: "Spanish vocabulary review", time: "4:30 PM", hour: 16, durationSlots: 1, category: .learn, isDone: false, aiSuggested: true, date: date),
                PlanTask(title: "Quick yoga & breath break", time: "5:30 PM", hour: 17, durationSlots: 1, category: .mindful, isDone: false, aiSuggested: true, date: date),
                PlanTask(title: "Call Mom", time: "6:00 PM", hour: 18, durationSlots: 1, category: .social, isDone: false, aiSuggested: false, date: date),
                PlanTask(title: "Dinner with friends", time: "7:00 PM", hour: 19, durationSlots: 2, category: .social, isDone: false, aiSuggested: false, date: date),
                PlanTask(title: "Plan tomorrow's day", time: "9:00 PM", hour: 21, durationSlots: 1, category: .focus, isDone: false, aiSuggested: true, date: date),
                PlanTask(title: "Evening journal & gratitude", time: "9:30 PM", hour: 21, durationSlots: 1, category: .mindful, isDone: false, aiSuggested: true, date: date)
            ]
        } else if isTomorrow {
            return [
                PlanTask(title: "Morning run", time: "6:30 AM", hour: 6, durationSlots: 2, category: .health, date: date),
                PlanTask(title: "Cold shower & breakfast", time: "7:30 AM", hour: 7, durationSlots: 1, category: .health, date: date),
                PlanTask(title: "Daily intentions journal", time: "8:30 AM", hour: 8, durationSlots: 1, category: .mindful, aiSuggested: true, date: date),
                PlanTask(title: "Team standup", time: "9:00 AM", hour: 9, durationSlots: 1, category: .social, aiSuggested: false, date: date),
                PlanTask(title: "Deep work: design review", time: "10:00 AM", hour: 10, durationSlots: 3, category: .focus, aiSuggested: true, date: date),
                PlanTask(title: "Mindful lunch", time: "12:30 PM", hour: 12, durationSlots: 1, category: .mindful, date: date),
                PlanTask(title: "Spanish lesson", time: "1:00 PM", hour: 13, durationSlots: 2, category: .learn, aiSuggested: true, date: date),
                PlanTask(title: "Focus: product roadmap", time: "3:00 PM", hour: 15, durationSlots: 3, category: .focus, aiSuggested: true, date: date),
                PlanTask(title: "Coffee chat with mentor", time: "5:00 PM", hour: 17, durationSlots: 1, category: .social, date: date),
                PlanTask(title: "Gym session", time: "6:00 PM", hour: 18, durationSlots: 2, category: .health, date: date),
                PlanTask(title: "Read fiction before bed", time: "9:30 PM", hour: 21, durationSlots: 1, category: .learn, aiSuggested: true, date: date)
            ]
        } else {
            let weekday = cal.component(.weekday, from: date)
            if weekday == 1 || weekday == 7 { // weekend
                return [
                    PlanTask(title: "Slow morning yoga", time: "8:00 AM", hour: 8, durationSlots: 2, category: .mindful, date: date),
                    PlanTask(title: "Farmers market trip", time: "10:00 AM", hour: 10, durationSlots: 1, category: .social, date: date),
                    PlanTask(title: "Explore a new café", time: "11:00 AM", hour: 11, durationSlots: 2, category: .social, date: date),
                    PlanTask(title: "Lunch & journal", time: "1:00 PM", hour: 13, durationSlots: 1, category: .mindful, aiSuggested: true, date: date),
                    PlanTask(title: "Read", time: "2:00 PM", hour: 14, durationSlots: 2, category: .learn, date: date),
                    PlanTask(title: "Long walk outdoors", time: "4:00 PM", hour: 16, durationSlots: 2, category: .health, aiSuggested: true, date: date),
                    PlanTask(title: "Cook a new recipe", time: "6:30 PM", hour: 18, durationSlots: 2, category: .health, date: date),
                    PlanTask(title: "Movie night", time: "8:30 PM", hour: 20, durationSlots: 2, category: .social, date: date),
                    PlanTask(title: "Weekly reflection", time: "10:30 PM", hour: 22, durationSlots: 1, category: .mindful, aiSuggested: true, date: date)
                ]
            } else {
                return [
                    PlanTask(title: "Morning workout", time: "7:00 AM", hour: 7, durationSlots: 2, category: .health, date: date),
                    PlanTask(title: "Breakfast & podcast", time: "8:30 AM", hour: 8, durationSlots: 1, category: .learn, date: date),
                    PlanTask(title: "Team standup", time: "9:30 AM", hour: 9, durationSlots: 1, category: .social, date: date),
                    PlanTask(title: "Deep focus block", time: "10:00 AM", hour: 10, durationSlots: 4, category: .focus, aiSuggested: true, date: date),
                    PlanTask(title: "Mindful lunch break", time: "12:00 PM", hour: 12, durationSlots: 1, category: .mindful, date: date),
                    PlanTask(title: "1:1 with manager", time: "1:30 PM", hour: 13, durationSlots: 1, category: .social, date: date),
                    PlanTask(title: "Afternoon focus sprint", time: "2:30 PM", hour: 14, durationSlots: 2, category: .focus, aiSuggested: true, date: date),
                    PlanTask(title: "Learning session", time: "4:00 PM", hour: 16, durationSlots: 2, category: .learn, aiSuggested: true, date: date),
                    PlanTask(title: "Evening walk", time: "6:00 PM", hour: 18, durationSlots: 1, category: .health, date: date),
                    PlanTask(title: "Dinner & wind down", time: "7:30 PM", hour: 19, durationSlots: 2, category: .mindful, date: date),
                    PlanTask(title: "Plan tomorrow", time: "9:30 PM", hour: 21, durationSlots: 1, category: .focus, aiSuggested: true, date: date)
                ]
            }
        }
    }

    static var tasks: [PlanTask] { tasks(for: Date()) }

    static let goals: [LifeGoal] = [
        LifeGoal(title: "Run a half marathon", emoji: "🏃", progress: 0.62, streak: 14, color: Theme.rose),
        LifeGoal(title: "Learn Spanish", emoji: "🇪🇸", progress: 0.41, streak: 22, color: Theme.accent),
        LifeGoal(title: "Save $10k", emoji: "💰", progress: 0.78, streak: 9, color: Theme.mint),
        LifeGoal(title: "Read 24 books", emoji: "📚", progress: 0.5, streak: 33, color: Theme.secondary)
    ]

    static let metrics: [DailyMetric] = [
        DailyMetric(label: "Focus", value: "4h 12m", icon: "brain.head.profile", tint: Theme.primary),
        DailyMetric(label: "Steps", value: "7,842", icon: "figure.walk", tint: Theme.mint),
        DailyMetric(label: "Mood", value: "Calm", icon: "face.smiling.fill", tint: Theme.accent)
    ]
}
