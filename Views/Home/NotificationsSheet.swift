import SwiftUI

struct AppNotification: Identifiable {
    let id = UUID()
    let icon: String
    let tint: Color
    let title: String
    let message: String
    let time: String
}

struct NotificationsSheet: View {
    @Environment(\.dismiss) private var dismiss

    private let items: [AppNotification] = [
        .init(icon: "sparkles", tint: Theme.primary,
              title: "AI Coach is ready",
              message: "Your morning plan is prepared. Tap to review.",
              time: "Just now"),
        .init(icon: "flame.fill", tint: Theme.accent,
              title: "7-day streak 🔥",
              message: "You completed your meditation 7 days in a row!",
              time: "2h ago"),
        .init(icon: "checkmark.circle.fill", tint: .green,
              title: "Task completed",
              message: "Deep work session — Project planning.",
              time: "Today, 9:42"),
        .init(icon: "bell.badge.fill", tint: Theme.secondary,
              title: "Reminder",
              message: "Evening review in 30 minutes.",
              time: "Today, 19:30"),
        .init(icon: "star.fill", tint: .yellow,
              title: "Weekly insight",
              message: "Your most productive day was Tuesday.",
              time: "Yesterday")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(items) { n in row(n) }
                        Color.clear.frame(height: 24)
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.primary)
                }
            }
        }.appPageTheme()
    }

    @ViewBuilder
    private func row(_ n: AppNotification) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle().fill(n.tint.opacity(0.18)).frame(width: 40, height: 40)
                Image(systemName: n.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(n.tint)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(n.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                Text(n.message)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text(n.time)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(.tertiary)
            }
            Spacer()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 18)
    }
}

#Preview { NotificationsSheet() }
