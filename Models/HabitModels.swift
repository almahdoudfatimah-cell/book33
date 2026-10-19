import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var emoji: String
    var createdDate: Date
    var completedDays: [String]

    init(id: UUID = UUID(), name: String, emoji: String,
         createdDate: Date = Date(), completedDays: [String] = []) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.createdDate = createdDate
        self.completedDays = completedDays
    }

    static func dayKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    var isCompletedToday: Bool {
        completedDays.contains(Self.dayKey(Date()))
    }

    /// Current consecutive-day streak ending today (or yesterday if today not completed yet).
    var currentStreak: Int {
        let cal = Calendar.current
        let set = Set(completedDays)
        var streak = 0
        var cursor = Date()
        if !set.contains(Self.dayKey(cursor)) {
            // Allow streak to roll over if user hasn't checked in today yet
            cursor = cal.date(byAdding: .day, value: -1, to: cursor) ?? cursor
        }
        while set.contains(Self.dayKey(cursor)) {
            streak += 1
            cursor = cal.date(byAdding: .day, value: -1, to: cursor) ?? cursor
        }
        return streak
    }
}
