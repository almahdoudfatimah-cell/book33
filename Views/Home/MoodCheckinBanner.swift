import SwiftUI

/// Quick mood check-in card shown on the Home tab.
struct MoodCheckinBanner: View {
    @ObservedObject private var store = MoodStore.shared
    @State private var tapped: MoodLevel? = nil
    @State private var saved = false

    var body: some View {
        if saved || store.todayLog != nil {
            loggedView
        } else {
            promptView
        }
    }

    // Already logged
    private var loggedView: some View {
        HStack(spacing: 14) {
            Text(store.todayLog?.mood.emoji ?? tapped?.emoji ?? "🙂")
                .font(.system(size: 32))
            VStack(alignment: .leading, spacing: 2) {
                Text("Mood logged for today")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                Text("Feeling \(store.todayLog?.mood.label.lowercased() ?? "good") · \(store.streak) day streak 🔥")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                NotificationCenter.default.post(name: .switchTab, object: 2)
            } label: {
                Text("Edit")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Theme.primary.opacity(0.12), in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .glassCard(cornerRadius: 20)
    }

    // Not yet logged
    private var promptView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("How are you feeling today?")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                Spacer()
                Text("Daily check-in")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.primary)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Theme.primary.opacity(0.12), in: Capsule())
            }

            HStack(spacing: 6) {
                ForEach(MoodLevel.allCases, id: \.rawValue) { level in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                            tapped = level
                        }
                        store.log(mood: level)
                        withAnimation(.easeInOut(duration: 0.3).delay(0.15)) {
                            saved = true
                        }
                    } label: {
                        VStack(spacing: 3) {
                            Text(level.emoji)
                                .font(.system(size: tapped == level ? 30 : 24))
                                .scaleEffect(tapped == level ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: tapped)
                            Text(level.label)
                                .font(.system(size: 9, weight: .semibold, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(tapped == level ? level.color.opacity(0.15) : Color.clear)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(14)
        .glassCard(cornerRadius: 20)
    }
}
