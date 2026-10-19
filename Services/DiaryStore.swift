import SwiftUI
import Combine

final class DiaryStore: ObservableObject {
    static let shared = DiaryStore()

    @Published var entries: [DiaryEntry] = []

    private let key = "diary.entries.v1"

    private init() {
        load()
        if entries.isEmpty { seedSampleData() }
    }

    // MARK: - CRUD
    func add(_ entry: DiaryEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: DiaryEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx] = entry
            save()
        }
    }

    func delete(_ entry: DiaryEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func toggleFavorite(_ entry: DiaryEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx].isFavorite.toggle()
            save()
        }
    }

    // MARK: - Insights
    var averageMoodScore: Double {
        guard !entries.isEmpty else { return 0.5 }
        return entries.map { $0.mood.score }.reduce(0, +) / Double(entries.count)
    }

    var streakDays: Int {
        let cal = Calendar.current
        var streak = 0
        var day = Date()
        let dates = Set(entries.map { cal.startOfDay(for: $0.date) })
        while dates.contains(cal.startOfDay(for: day)) {
            streak += 1
            day = cal.date(byAdding: .day, value: -1, to: day)!
        }
        return streak
    }

    var totalWords: Int { entries.map(\.wordCount).reduce(0, +) }

    func moodScores(last days: Int) -> [(Date, Double)] {
        let cal = Calendar.current
        return (0..<days).compactMap { offset -> (Date, Double)? in
            guard let d = cal.date(byAdding: .day, value: -offset, to: Date()) else { return nil }
            let start = cal.startOfDay(for: d)
            let dayEntries = entries.filter { cal.startOfDay(for: $0.date) == start }
            guard !dayEntries.isEmpty else { return nil }
            let avg = dayEntries.map { $0.mood.score }.reduce(0, +) / Double(dayEntries.count)
            return (start, avg)
        }.reversed()
    }

    func entriesFor(date: Date) -> [DiaryEntry] {
        let cal = Calendar.current
        return entries.filter { cal.isDate($0.date, inSameDayAs: date) }
    }

    // MARK: - Persistence
    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([DiaryEntry].self, from: data)
        else { return }
        entries = decoded
    }

    // MARK: - Sample Data
    private func seedSampleData() {
        let cal = Calendar.current
        func daysAgo(_ n: Int) -> Date {
            cal.date(byAdding: .day, value: -n, to: Date())!
        }

        entries = [
            DiaryEntry(date: Date(), title: "A fresh start 🌸",
                       body: "Woke up feeling surprisingly energised today. Made myself a proper breakfast instead of rushing out the door — scrambled eggs, fresh coffee, the works. There's something grounding about slowing down in the morning. I want to make this a habit.",
                       mood: .happy, tags: [.gratitude, .health], weather: .sunny, isFavorite: true),
            DiaryEntry(date: daysAgo(1), title: "Late night thoughts",
                       body: "Couldn't sleep. The project deadline is looming and my mind won't switch off. I wrote out everything that's worrying me — it helped a little. Tomorrow I'll tackle the hardest task first. Done is better than perfect.",
                       mood: .anxious, tags: [.work], weather: .cloudy),
            DiaryEntry(date: daysAgo(2), title: "Sunday with family",
                       body: "Had everyone over for lunch. Mom's lamb tagine, Dad's terrible jokes, my nephew trying to teach me TikTok dances. I laughed until my sides hurt. These moments are the whole point.",
                       mood: .amazing, tags: [.family, .social], weather: .sunny, isFavorite: true),
            DiaryEntry(date: daysAgo(3), title: "Quiet Wednesday",
                       body: "Nothing much happened today and that felt oddly nice. Read for an hour, went for a walk, listened to a podcast on habit formation. Not every day needs to be eventful to be good.",
                       mood: .neutral, tags: [.growth], weather: .cloudy),
            DiaryEntry(date: daysAgo(5), title: "Rainy day blues",
                       body: "The grey skies matched my mood. Felt a bit low without a clear reason — those days happen. I was gentle with myself. Had soup, watched a comforting film, went to bed early.",
                       mood: .sad, tags: [.health], weather: .rainy),
            DiaryEntry(date: daysAgo(7), title: "Weekend hike 🏔️",
                       body: "Drove out to the hills with a couple of friends. Three hours of climbing, incredible views, aching legs, and the best feeling of accomplishment. Nature genuinely resets something in me.",
                       mood: .amazing, tags: [.travel, .health, .social], weather: .sunny, isFavorite: true),
            DiaryEntry(date: daysAgo(9), title: "Gratitude list",
                       body: "Feeling reflective. Grateful for: good health, a job that challenges me, friends who check in, a warm flat, books that transport me, the smell of rain. Simple things, enormous things.",
                       mood: .happy, tags: [.gratitude, .growth], weather: .rainy),
            DiaryEntry(date: daysAgo(12), title: "Breakthrough moment",
                       body: "Finally cracked that problem I'd been stuck on for days. That click when everything falls into place — there's nothing quite like it. Celebrated with my favourite coffee and a long walk.",
                       mood: .amazing, tags: [.work, .growth], weather: .sunny)
        ]
        save()
    }
}
