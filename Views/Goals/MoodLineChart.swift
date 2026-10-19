import SwiftUI
import Charts

struct MoodLineChart: View {
    // Mock data - replace with actual data from your store
    private let data: [MoodChartEntry] = {
        let calendar = Calendar.current
        let today = Date()
        return (0..<14).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) ?? today
            let score = Double.random(in: 2.5...4.5)
            return MoodChartEntry(date: date, score: score)
        }.reversed()
    }()
    
    @State private var selectedEntry: MoodChartEntry? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Mood Trend")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Text("Last 14 days")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                moodBadge
            }

            Chart {
                ForEach(data) { entry in
                    AreaMark(
                        x: .value("Day", entry.date),
                        yStart: .value("Base", 1.0),
                        yEnd: .value("Score", entry.score)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.primary.opacity(0.35), Theme.primary.opacity(0.03)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)

                    LineMark(
                        x: .value("Day", entry.date),
                        y: .value("Score", entry.score)
                    )
                    .foregroundStyle(Theme.heroGradient)
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                    .interpolationMethod(.catmullRom)

                    PointMark(
                        x: .value("Day", entry.date),
                        y: .value("Score", entry.score)
                    )
                    .foregroundStyle(Theme.secondary)
                    .symbolSize(28)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 4)) {
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                        .font(.system(size: 10, design: .rounded))
                }
            }
            .chartYAxis {
                AxisMarks(values: [1, 2, 3, 4, 5]) {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                        .foregroundStyle(Color.primary.opacity(0.08))
                    AxisValueLabel()
                        .font(.system(size: 10, design: .rounded))
                }
            }
            .chartYScale(domain: 1...5)
            .frame(height: 160)
        }
        .padding(16)
        .glassCard(cornerRadius: 22)
    }

    private var moodBadge: some View {
        let avg = data.map(\.score).reduce(0, +) / Double(data.count)
        let emoji = avg >= 4.5 ? "😄" : avg >= 3.5 ? "🙂" : avg >= 2.5 ? "😐" : "😔"
        return HStack(spacing: 6) {
            Text(emoji)
            Text(String(format: "%.1f / 5", avg))
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .glassCard(cornerRadius: 12)
    }
}

// Helper struct for mood chart data
fileprivate struct MoodChartEntry: Identifiable {
    let id = UUID()
    let date: Date
    let score: Double
}
