import SwiftUI
import Combine

struct MoodLog: Identifiable, Codable {
    let id: UUID
    let date: Date
    let mood: MoodLevel
    var note: String

    init(id: UUID = UUID(), date: Date = Date(), mood: MoodLevel, note: String = "") {
        self.id = id
        self.date = date
        self.mood = mood
        self.note = note
    }
}

enum MoodLevel: Int, CaseIterable, Codable {
    case awful = 1, bad, okay, good, great

    var emoji: String {
        switch self {
        case .awful: return "😞"
        case .bad:   return "😕"
        case .okay:  return "😐"
        case .good:  return "🙂"
        case .great: return "😄"
        }
    }

    var label: String {
        switch self {
        case .awful: return "Awful"
        case .bad:   return "Bad"
        case .okay:  return "Okay"
        case .good:  return "Good"
        case .great: return "Great"
        }
    }

    var color: Color {
        switch self {
        case .awful: return Color(red: 0.85, green: 0.25, blue: 0.05)   // Burnt red-orange
        case .bad:   return Color(red: 1.00, green: 0.45, blue: 0.10)   // Deep orange
        case .okay:  return Color(red: 1.00, green: 0.80, blue: 0.10)   // Golden yellow
        case .good:  return Color(red: 0.45, green: 0.82, blue: 0.30)   // Fresh green
        case .great: return Color(red: 0.20, green: 0.70, blue: 0.25)   // Deep green
        }
    }
}

final class MoodStore: ObservableObject {
    static let shared = MoodStore()
    private let key = "mood.logs.v1"

    @Published var logs: [MoodLog] = []

    private init() { load() }

    // MARK: - Computed
    var todayLog: MoodLog? {
        logs.first { Calendar.current.isDateInToday($0.date) }
    }

    var streak: Int {
        var count = 0
        var day = Calendar.current.startOfDay(for: Date())
        // If no log today, start from yesterday
        if todayLog == nil { day = Calendar.current.date(byAdding: .day, value: -1, to: day) ?? day }
        while true {
            if logs.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: day) }) {
                count += 1
                day = Calendar.current.date(byAdding: .day, value: -1, to: day) ?? day
            } else { break }
        }
        return count
    }

    var last7Days: [MoodLog?] {
        (0..<7).reversed().map { offset -> MoodLog? in
            let day = Calendar.current.date(byAdding: .day, value: -offset, to: Date()) ?? Date()
            return logs.first { Calendar.current.isDate($0.date, inSameDayAs: day) }
        }
    }

    var averageThisWeek: Double? {
        let week = last7Days.compactMap { $0 }
        guard !week.isEmpty else { return nil }
        return Double(week.map { $0.mood.rawValue }.reduce(0, +)) / Double(week.count)
    }

    // MARK: - Actions
    func log(mood: MoodLevel, note: String = "") {
        // Remove existing today entry if any
        logs.removeAll { Calendar.current.isDateInToday($0.date) }
        logs.insert(MoodLog(mood: mood, note: note), at: 0)
        save()
    }

    func delete(_ log: MoodLog) {
        logs.removeAll { $0.id == log.id }
        save()
    }

    // MARK: - Persistence
    private func save() {
        if let data = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([MoodLog].self, from: data) else {
            seedSampleData()
            return
        }
        logs = decoded
    }

    private func seedSampleData() {
        let moods: [MoodLevel] = [.good, .great, .okay, .good, .great, .bad, .good, .great, .okay, .great, .good, .okay, .great, .good]
        let today = Date()
        logs = moods.enumerated().compactMap { i, mood in
            guard let date = Calendar.current.date(byAdding: .day, value: -(moods.count - 1 - i), to: today) else { return nil }
            return MoodLog(date: date, mood: mood, note: "")
        }
        // Remove today's seed so user can check in
        logs.removeAll { Calendar.current.isDateInToday($0.date) }
        save()
    }
}
