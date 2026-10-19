import SwiftUI

struct SummaryStatsRow: View {
    // Mock data - replace with actual data from your store
    private let stats: [(String, String, String, Color)] = [
        ("🔥", "12", "Tasks done", Theme.accent),
        ("⚡", "24h", "Focus", Theme.primary),
        ("😊", "4.2", "Avg mood", Theme.mint)
    ]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(stats, id: \.1) { emoji, value, label, color in
                VStack(spacing: 6) {
                    Text(emoji).font(.system(size: 22))
                    Text(value)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(color)
                    Text(label)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .glassCard(cornerRadius: 20)
            }
        }
    }
}
