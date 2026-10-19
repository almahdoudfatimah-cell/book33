import Foundation
import Combine

final class SportsStore: ObservableObject {
    static let shared = SportsStore()

    @Published var activities: [SportActivity] = []
    private let key = "sports.activities.v1"

    private init() { load() }

    // MARK: - CRUD

    func add(_ activity: SportActivity) {
        activities.insert(activity, at: 0)
        save()
    }

    func update(_ activity: SportActivity) {
        guard let idx = activities.firstIndex(where: { $0.id == activity.id }) else { return }
        activities[idx] = activity
        save()
    }

    func delete(_ activity: SportActivity) {
        activities.removeAll { $0.id == activity.id }
        save()
    }

    // MARK: - Stats

    var totalDistanceKm: Double { activities.reduce(0) { $0 + $1.distance } }
    var totalDurationMin: Int  { activities.reduce(0) { $0 + $1.duration } }
    var totalCalories: Int     { activities.reduce(0) { $0 + $1.calories } }

    func activitiesForType(_ type: SportType) -> [SportActivity] {
        activities.filter { $0.type == type }
    }

    func activitiesThisWeek() -> [SportActivity] {
        let start = Calendar.current.startOfWeek()
        return activities.filter { $0.date >= start }
    }

    // MARK: - Persistence

    private func save() {
        guard let data = try? JSONEncoder().encode(activities) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([SportActivity].self, from: data) else { return }
        activities = decoded
    }
}

// MARK: - Calendar helper

private extension Calendar {
    func startOfWeek() -> Date {
        let comps = dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return date(from: comps) ?? Date()
    }
}
