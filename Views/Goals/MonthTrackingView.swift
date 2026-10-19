import SwiftUI
import Charts

// MARK: - Month Tracking
struct MonthTrackingView: View {
    @State private var displayedMonth: Date = {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
    }()

    var body: some View {
        VStack(spacing: 18) {
            MonthCalendarHeatmap(month: displayedMonth, onPrev: prevMonth, onNext: nextMonth)
            MonthStatsRow(month: displayedMonth)
            MonthCategoryBars(month: displayedMonth)
            MonthHabitSummary()
        }
    }

    private func prevMonth() {
        withAnimation(.spring(response: 0.35)) {
            displayedMonth = Calendar.current.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
        }
    }
    private func nextMonth() {
        withAnimation(.spring(response: 0.35)) {
            displayedMonth = Calendar.current.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
        }
    }
}

// MARK: - Calendar Heatmap
struct MonthCalendarHeatmap: View {
    let month: Date
    let onPrev: () -> Void
    let onNext: () -> Void

    private let cols = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
    private let weekdays = ["Su","Mo","Tu","We","Th","Fr","Sa"]

    private var days: [CalDay] { MonthData.days(for: month) }
    private var monthLabel: String {
        let f = DateFormatter(); f.dateFormat = "MMMM yyyy"; return f.string(from: month)
    }
    private var isCurrentMonth: Bool { Calendar.current.isDate(month, equalTo: Date(), toGranularity: .month) }

    var body: some View {
        VStack(spacing: 14) {
            // Header
            HStack {
                Button(action: onPrev) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.primary)
                        .frame(width: 32, height: 32)
                        .background(Theme.primary.opacity(0.12), in: Circle())
                }
                Spacer()
                Text(monthLabel)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Button(action: onNext) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(isCurrentMonth ? Color.secondary.opacity(0.4) : Theme.primary)
                        .frame(width: 32, height: 32)
                        .background(
                            isCurrentMonth ? Color.secondary.opacity(0.08) : Theme.primary.opacity(0.12),
                            in: Circle()
                        )
                }
                .disabled(isCurrentMonth)
            }

            // Weekday labels
            HStack(spacing: 6) {
                ForEach(weekdays, id: \.self) { d in
                    Text(d)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Day grid
            LazyVGrid(columns: cols, spacing: 6) {
                ForEach(days) { day in
                    DayCell(day: day)
                }
            }

            // Legend
            HStack(spacing: 6) {
                Text("Less")
                    .font(.system(size: 10, design: .rounded))
                    .foregroundStyle(.secondary)
                ForEach([0.1, 0.3, 0.55, 0.8, 1.0], id: \.self) { o in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Theme.primary.opacity(o))
                        .frame(width: 14, height: 14)
                }
                Text("More")
                    .font(.system(size: 10, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 22)
    }
}

// MARK: - Day Cell
private struct DayCell: View {
    let day: CalDay

    var body: some View {
        ZStack {
            if day.isEmpty {
                Color.clear
            } else {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(day.isToday
                          ? Theme.primary
                          : day.intensity > 0
                            ? Theme.primary.opacity(day.intensity * 0.85 + 0.1)
                            : Color.primary.opacity(0.06))
                    .overlay(
                        day.isToday
                        ? RoundedRectangle(cornerRadius: 7).strokeBorder(.white.opacity(0.3), lineWidth: 1.5)
                        : nil
                    )
                VStack(spacing: 1) {
                    Text("\(day.dayNum)")
                        .font(.system(size: 12, weight: day.isToday ? .bold : .medium, design: .rounded))
                        .foregroundStyle(day.isToday ? .white : day.intensity > 0.5 ? .white : .primary)
                    if day.intensity > 0 {
                        Circle()
                            .fill(day.isToday ? .white.opacity(0.7) : Theme.accent)
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .frame(height: 38)
    }
}

// MARK: - Month Stats Row
struct MonthStatsRow: View {
    let month: Date
    private let stats = MonthData.stats

    var body: some View {
        HStack(spacing: 12) {
            ForEach(stats) { s in
                VStack(spacing: 4) {
                    Text(s.value)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(s.color)
                    Text(s.label)
                        .font(.system(size: 11, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .glassCard(cornerRadius: 18)
            }
        }
    }
}

// MARK: - Month Category Bars
struct MonthCategoryBars: View {
    let month: Date
    private let items = MonthData.categoryProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Category Progress")
                .font(.system(size: 16, weight: .bold, design: .rounded))

            ForEach(items) { item in
                VStack(spacing: 6) {
                    HStack {
                        Text(item.emoji + " " + item.label)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                        Spacer()
                        Text("\(item.hours)h / \(item.goal)h")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(item.color.opacity(0.15))
                                .frame(height: 10)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(item.color)
                                .frame(width: geo.size.width * min(Double(item.hours) / Double(item.goal), 1.0), height: 10)
                                .animation(.spring(response: 0.5), value: item.hours)
                        }
                    }
                    .frame(height: 10)
                }
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 22)
    }
}

// MARK: - Month Habit Summary
struct MonthHabitSummary: View {
    private let habits = MonthData.habitSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Habit Completion")
                .font(.system(size: 16, weight: .bold, design: .rounded))

            ForEach(habits) { h in
                HStack(spacing: 12) {
                    Text(h.emoji).font(.system(size: 22))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(h.name)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                        Text("\(h.done)/\(h.total) days completed")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(h.color.opacity(0.2), lineWidth: 5)
                        Circle()
                            .trim(from: 0, to: Double(h.done) / Double(h.total))
                            .stroke(h.color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        Text("\(Int(Double(h.done)/Double(h.total)*100))%")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundStyle(h.color)
                    }
                    .frame(width: 46, height: 46)
                }
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 22)
    }
}

// MARK: - Models
struct CalDay: Identifiable {
    let id = UUID()
    let dayNum: Int
    let isEmpty: Bool
    let intensity: Double   // 0–1
    let isToday: Bool
}

struct MonthStat: Identifiable {
    let id = UUID()
    let value: String
    let label: String
    let color: Color
}

struct CategoryProgress: Identifiable {
    let id = UUID()
    let emoji: String
    let label: String
    let hours: Int
    let goal: Int
    let color: Color
}

struct HabitMonthlySummary: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let done: Int
    let total: Int
    let color: Color
}

// MARK: - Sample Data
enum MonthData {
    static let stats: [MonthStat] = [
        MonthStat(value: "68", label: "Tasks\nDone", color: Theme.primary),
        MonthStat(value: "82h", label: "Focus\nTime", color: Theme.secondary),
        MonthStat(value: "4.3", label: "Avg\nMood", color: Theme.accent)
    ]

    static let categoryProgress: [CategoryProgress] = [
        CategoryProgress(emoji: "🎯", label: "Focus Work", hours: 82, goal: 100, color: Theme.primary),
        CategoryProgress(emoji: "💪", label: "Health", hours: 24, goal: 30, color: Theme.rose),
        CategoryProgress(emoji: "🧘", label: "Mindfulness", hours: 18, goal: 20, color: Theme.mint),
        CategoryProgress(emoji: "📚", label: "Learning", hours: 12, goal: 16, color: Theme.secondary)
    ]

    static let habitSummary: [HabitMonthlySummary] = [
        HabitMonthlySummary(emoji: "🧘", name: "Morning Meditation", done: 24, total: 30, color: Theme.mint),
        HabitMonthlySummary(emoji: "🏃", name: "Daily Run", done: 20, total: 30, color: Theme.rose),
        HabitMonthlySummary(emoji: "📚", name: "Read 20 Pages", done: 28, total: 30, color: Theme.secondary),
        HabitMonthlySummary(emoji: "🇪🇸", name: "Spanish Lesson", done: 16, total: 30, color: Theme.accent)
    ]

    static func days(for month: Date) -> [CalDay] {
        let cal = Calendar.current
        guard let monthStart = cal.date(from: cal.dateComponents([.year, .month], from: month)),
              let range = cal.range(of: .day, in: .month, for: monthStart) else { return [] }

        let firstWeekday = (cal.component(.weekday, from: monthStart) - 1 + 7) % 7
        let today = cal.startOfDay(for: Date())
        let intensities: [Double] = [0,0.3,0.6,0.9,0.5,0.2,0.8,0.4,0.7,1.0,0.6,0.3,0.5,0.9,0.1,0.8,0.4,0.6,0.2,0.7,0.5,1.0,0.3,0.8,0.6,0.4,0.9,0.2,0.7,0.5,0.1]

        var result: [CalDay] = (0..<firstWeekday).map { _ in CalDay(dayNum: 0, isEmpty: true, intensity: 0, isToday: false) }
        for day in range {
            let date = cal.date(byAdding: .day, value: day - 1, to: monthStart) ?? monthStart
            let isFuture = date > today
            let intensity = isFuture ? 0.0 : intensities[min(day - 1, intensities.count - 1)]
            let isToday = cal.isDate(date, inSameDayAs: today)
            result.append(CalDay(dayNum: day, isEmpty: false, intensity: intensity, isToday: isToday))
        }
        return result
    }
}
