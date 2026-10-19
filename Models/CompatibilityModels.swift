import SwiftUI
import Combine

extension AppTheme {
    var primary: Color { primaryColor }
    var gradient: LinearGradient {
        LinearGradient(colors: [primaryColor, primaryColor.opacity(0.55)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    var emoji: String {
        switch self { case .energetic: return "⚡️"; case .calm: return "🌊"; case .focused: return "🎯"; case .vibrant: return "🌈" }
    }
    var isPremium: Bool { self != .energetic }
}

struct WeeklyActivityBar {
    let day: String
    let focusHours: Double
    let healthHours: Double
    let mindfulHours: Double
}

struct CategoryShare: Identifiable {
    let id = UUID()
    let category: TaskCategory
    let hours: Double
}

extension HabitStreak {
    var name: String { habitName }
    var emoji: String { "🔥" }
    var streak: Int { currentStreak }
    var best: Int { longestStreak }
    var color: Color { Theme.primary }
    var completedDays: [Bool] {
        let calendar = Calendar.current
        return (0..<14).reversed().map { offset in
            guard let day = calendar.date(byAdding: .day, value: -offset, to: Date()) else { return false }
            return completionDates.contains { calendar.isDate($0, inSameDayAs: day) }
        }
    }
}

extension TrackingData {
    static let weeklyBars = [
        WeeklyActivityBar(day: "Sun", focusHours: 3, healthHours: 1, mindfulHours: 1),
        WeeklyActivityBar(day: "Mon", focusHours: 5, healthHours: 2, mindfulHours: 1),
        WeeklyActivityBar(day: "Tue", focusHours: 4, healthHours: 1, mindfulHours: 1),
        WeeklyActivityBar(day: "Wed", focusHours: 6, healthHours: 2, mindfulHours: 1),
        WeeklyActivityBar(day: "Thu", focusHours: 4, healthHours: 2, mindfulHours: 1),
        WeeklyActivityBar(day: "Fri", focusHours: 3, healthHours: 2, mindfulHours: 2),
        WeeklyActivityBar(day: "Sat", focusHours: 2, healthHours: 3, mindfulHours: 2)
    ]
    static let categoryShares = [
        CategoryShare(category: .focus, hours: 27),
        CategoryShare(category: .health, hours: 13),
        CategoryShare(category: .mindful, hours: 9)
    ]
    static let habits = [
        HabitStreak(habitName: "Exercise", currentStreak: 5, longestStreak: 12),
        HabitStreak(habitName: "Read", currentStreak: 8, longestStreak: 15),
        HabitStreak(habitName: "Meditate", currentStreak: 3, longestStreak: 9)
    ]
}

extension DaySchedule {
    static let wakeOptions = Array(4...12)
    static let sleepOptions = Array(18...23)
    static func label(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter.string(from: Calendar.current.date(from: DateComponents(hour: hour)) ?? Date())
    }
}

@MainActor
extension AuthManager {
    var isSignedIn: Bool { isAuthenticated }
    var currentDisplayName: String { currentUser?.name ?? currentEmail ?? "Guest" }
}

@MainActor
final class WeekTaskStore: ObservableObject {
    static let shared = WeekTaskStore()
    @Published private var tasksByDay: [Date: [PlanTask]] = [:]
    private let calendar = Calendar.current

    private init() {}

    func tasks(for date: Date) -> [PlanTask] {
        tasksByDay[calendar.startOfDay(for: date)] ?? SampleData.tasks(for: date)
    }

    func toggleDone(taskId: UUID, on date: Date) {
        let key = calendar.startOfDay(for: date)
        var tasks = self.tasks(for: date)
        guard let index = tasks.firstIndex(where: { $0.id == taskId }) else { return }
        tasks[index].isDone.toggle()
        tasksByDay[key] = tasks
    }

    func addTask(title: String, on date: Date) {
        let key = calendar.startOfDay(for: date)
        var tasks = self.tasks(for: date)
        tasks.append(PlanTask(title: title, time: "Any time", hour: 12, category: .focus, date: date))
        tasksByDay[key] = tasks
    }
}

struct DiaryEntryEditor: View {
    let entry: DiaryEntry?
    var body: some View { PlaceholderView(title: entry == nil ? "New Diary Entry" : "Edit Diary Entry", subtitle: "Diary editing is coming soon.", icon: "book.pages") }
}

@MainActor
final class AssessmentStore: ObservableObject {
    static let shared = AssessmentStore()
    @Published var isCompleted = false
    private init() {}
}

struct AssessmentView: View {
    var body: some View { PlaceholderView(title: "Athlete Assessment", subtitle: "Assessment is coming soon.", icon: "person.text.rectangle") }
}
