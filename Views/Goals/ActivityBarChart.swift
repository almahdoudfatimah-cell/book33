import SwiftUI
import Charts

struct ActivityBarChart: View {
    // Flatten into (day, category, hours) for stacked bars
    private var chartData: [(day: String, category: String, hours: Double, color: Color)] {
        TrackingData.weeklyBars.flatMap { bar in [
            (bar.day, "Focus",   bar.focusHours,   Theme.primary),
            (bar.day, "Health",  bar.healthHours,  Theme.rose),
            (bar.day, "Mindful", bar.mindfulHours, Theme.mint)
        ]}
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader
            Chart {
                ForEach(chartData, id: \.category) { item in
                    BarMark(
                        x: .value("Day", item.day),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(item.color)
                    .cornerRadius(4)
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) {
                    AxisValueLabel()
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                }
            }
            .chartYAxis {
                AxisMarks(values: [0, 2, 4, 6, 8]) {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                        .foregroundStyle(Color.primary.opacity(0.1))
                    AxisValueLabel()
                        .font(.system(size: 10, design: .rounded))
                }
            }
            .frame(height: 180)

            legend
        }
        .padding(16)
        .glassCard(cornerRadius: 22)
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Weekly Activity")
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text("Hours per category this week")
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }

    private var legend: some View {
        HStack(spacing: 16) {
            ForEach([("Focus", Theme.primary), ("Health", Theme.rose), ("Mindful", Theme.mint)], id: \.0) { label, color in
                HStack(spacing: 5) {
                    Circle().fill(color).frame(width: 8, height: 8)
                    Text(label)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
