import SwiftUI
import Charts

struct CategoryDonutChart: View {
    private let data = TrackingData.categoryShares
    private var total: Double { data.map { $0.hours }.reduce(0, +) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Breakdown")
                .font(.system(size: 16, weight: .bold, design: .rounded))

            HStack(spacing: 20) {
                donutChart
                    .frame(width: 140, height: 140)
                categoryList
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 22)
    }

    private var donutChart: some View {
        Chart(data) { item in
            SectorMark(
                angle: .value("Hours", item.hours),
                innerRadius: .ratio(0.55),
                angularInset: 2
            )
            .foregroundStyle(item.category.tint)
            .cornerRadius(4)
        }
        .chartBackground { _ in
            VStack(spacing: 2) {
                Text(String(format: "%.0fh", total))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                Text("total")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var categoryList: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(data) { item in
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(item.category.tint)
                        .frame(width: 10, height: 10)
                    Text(item.category.rawValue)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                    Spacer()
                    Text(String(format: "%.0fh", item.hours))
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(item.category.tint)
                }
            }
        }
    }
}
