import SwiftUI

struct MetricsRow: View {
    var body: some View {
        HStack(spacing: 12) {
            ForEach(SampleData.metrics) { metric in
                MetricCard(metric: metric)
            }
        }
    }
}

private struct MetricCard: View {
    let metric: DailyMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: metric.icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(metric.tint)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(metric.tint.opacity(0.15)))
                Spacer()
            }
            Text(metric.value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            Text(metric.label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 20)
    }
}
