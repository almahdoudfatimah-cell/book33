import SwiftUI
import Charts

struct DiaryInsightsView: View {
    @StateObject private var store = DiaryStore.shared
    @Environment(\.colorScheme) private var scheme

    private var cardBg: Color {
        scheme == .dark ? Color(red: 0.18, green: 0.12, blue: 0.16) : .white
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                statsRow
                moodTrendCard
                moodBreakdownCard
                topTagsCard
                calendarHeatmap
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(value: "\(store.streakDays)", label: "Day Streak", icon: "flame.fill", color: .orange)
            statCard(value: "\(store.entries.count)", label: "Entries", icon: "book.fill", color: Theme.primary)
            statCard(value: "\(store.totalWords)", label: "Words", icon: "text.word.spacing", color: Color(red: 0.40, green: 0.55, blue: 0.95))
        }
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(.primary)
            Text(label)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(cardBg, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
    }

    // MARK: - Mood Trend
    private var moodTrendCard: some View {
        let points = store.moodScores(last: 14)
        return VStack(alignment: .leading, spacing: 12) {
            Label("Mood Trend · 14 days", systemImage: "chart.line.uptrend.xyaxis")
                .font(.system(size: 14, weight: .bold, design: .rounded))

            if points.isEmpty {
                Text("No data yet — start writing!")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                Chart(points, id: \.0) { pt in
                    LineMark(
                        x: .value("Date", pt.0, unit: .day),
                        y: .value("Mood", pt.1)
                    )
                    .foregroundStyle(Theme.heroGradient)
                    .interpolationMethod(.catmullRom)
                    AreaMark(
                        x: .value("Date", pt.0, unit: .day),
                        y: .value("Mood", pt.1)
                    )
                    .foregroundStyle(Theme.primary.opacity(0.12))
                    .interpolationMethod(.catmullRom)
                    PointMark(
                        x: .value("Date", pt.0, unit: .day),
                        y: .value("Mood", pt.1)
                    )
                    .symbolSize(40)
                    .foregroundStyle(Theme.primary)
                }
                .chartYScale(domain: 0...1)
                .chartYAxis { AxisMarks(values: [0, 0.5, 1]) }
                .frame(height: 140)
            }
        }
        .padding(18)
        .background(cardBg, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
    }

    // MARK: - Mood Breakdown
    private var moodBreakdownCard: some View {
        let counts = moodCounts()
        return VStack(alignment: .leading, spacing: 14) {
            Label("Mood Breakdown", systemImage: "face.smiling")
                .font(.system(size: 14, weight: .bold, design: .rounded))

            VStack(spacing: 10) {
                ForEach(DiaryMood.allCases, id: \.self) { mood in
                    let count = counts[mood] ?? 0
                    let total = max(store.entries.count, 1)
                    let ratio = Double(count) / Double(total)
                    moodBar(mood: mood, count: count, ratio: ratio)
                }
            }
        }
        .padding(18)
        .background(cardBg, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
    }

    private func moodBar(mood: DiaryMood, count: Int, ratio: Double) -> some View {
        HStack(spacing: 10) {
            Text(mood.emoji)
                .font(.system(size: 18))
                .frame(width: 28)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(mood.color.opacity(0.15))
                        .frame(height: 24)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(mood.color)
                        .frame(width: max(geo.size.width * ratio, ratio > 0 ? 8 : 0), height: 24)
                }
            }
            .frame(height: 24)
            Text("\(count)")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(width: 24, alignment: .trailing)
        }
    }

    private func moodCounts() -> [DiaryMood: Int] {
        var result: [DiaryMood: Int] = [:]
        for entry in store.entries {
            result[entry.mood, default: 0] += 1
        }
        return result
    }

    // MARK: - Top Tags
    private var topTagsCard: some View {
        let tagCounts = tagFrequencies()
        return VStack(alignment: .leading, spacing: 14) {
            Label("Most Written About", systemImage: "tag.fill")
                .font(.system(size: 14, weight: .bold, design: .rounded))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 10) {
                ForEach(tagCounts.prefix(6), id: \.0) { tag, count in
                    HStack(spacing: 6) {
                        Image(systemName: tag.icon)
                            .font(.system(size: 12, weight: .bold))
                        Text(tag.rawValue)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                        Spacer()
                        Text("\(count)")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(tag.color)
                    }
                    .foregroundStyle(tag.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(tag.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(18)
        .background(cardBg, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
    }

    private func tagFrequencies() -> [(DiaryTag, Int)] {
        var result: [DiaryTag: Int] = [:]
        for entry in store.entries {
            for tag in entry.tags { result[tag, default: 0] += 1 }
        }
        return result.sorted { $0.value > $1.value }
    }

    // MARK: - Calendar Heatmap
    private var calendarHeatmap: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Writing Streak", systemImage: "calendar")
                .font(.system(size: 14, weight: .bold, design: .rounded))

            let cal = Calendar.current
            let today = Date()
            let daysBack = 28
            let days: [Date] = (0..<daysBack).compactMap {
                cal.date(byAdding: .day, value: -($0), to: today)
            }.reversed()

            let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(days, id: \.self) { day in
                    let hasEntry = !store.entriesFor(date: day).isEmpty
                    let isToday = cal.isDateInToday(day)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(hasEntry ? Theme.primary.opacity(0.8) : Color(.systemFill))
                        .frame(height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isToday ? Theme.primary : Color.clear, lineWidth: 2)
                        )
                        .overlay(
                            Text("\(cal.component(.day, from: day))")
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundStyle(hasEntry ? .white : .secondary)
                        )
                }
            }
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 4).fill(Color(.systemFill)).frame(width: 16, height: 16)
                Text("No entry")
                    .font(.system(size: 11, design: .rounded)).foregroundStyle(.secondary)
                Spacer()
                RoundedRectangle(cornerRadius: 4).fill(Theme.primary.opacity(0.8)).frame(width: 16, height: 16)
                Text("Entry written")
                    .font(.system(size: 11, design: .rounded)).foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(cardBg, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
    }
}
