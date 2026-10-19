import SwiftUI

struct MoodView: View {
    @StateObject private var store = MoodStore.shared
    @Environment(\.colorScheme) private var scheme
    @State private var selectedMood: MoodLevel? = nil
    @State private var noteText: String = ""
    @State private var showConfetti = false
    @State private var showHistory = false

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        streakBanner
                        checkinCard
                        weekStrip
                        historySection
                        Color.clear.frame(height: 32)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
                }
                if showConfetti { confettiOverlay }
            }
            .navigationTitle("Mood")
            .navigationBarTitleDisplayMode(.inline)
        }.appPageTheme()
        .onAppear {
            if let today = store.todayLog {
                selectedMood = today.mood
                noteText = today.note
            }
        }
    }

    // MARK: - Streak banner
    private var streakBanner: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Check-in Streak")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(store.streak)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.primary)
                    Text("days")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.primary.opacity(0.7))
                }
            }
            Spacer()
            if let avg = store.averageThisWeek {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("This week avg")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                    HStack(spacing: 6) {
                        Text(avgEmoji(avg))
                            .font(.system(size: 28))
                        Text(String(format: "%.1f", avg))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.primary)
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Theme.heroGradient)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Theme.primary.opacity(0.3), radius: 16, x: 0, y: 8)
    }

    // MARK: - Check-in card
    private var checkinCard: some View {
        VStack(spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(store.todayLog == nil ? "How are you feeling?" : "Today's mood")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    Text(store.todayLog == nil ? "Tap to log your mood" : "Tap to update")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if store.todayLog != nil {
                    Text("✓ Logged")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Theme.primary.opacity(0.12), in: Capsule())
                }
            }

            // Emoji picker
            HStack(spacing: 8) {
                ForEach(MoodLevel.allCases, id: \.rawValue) { level in
                    MoodEmojiButton(level: level, isSelected: selectedMood == level) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedMood = level
                        }
                    }
                }
            }

            // Note field
            if selectedMood != nil {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Add a note (optional)")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                    TextField("What's on your mind?", text: $noteText, axis: .vertical)
                        .font(.system(size: 14, design: .rounded))
                        .lineLimit(3, reservesSpace: true)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(scheme == .dark ? Color.white.opacity(0.07) : Color(red: 1, green: 0.95, blue: 0.97))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.primary.opacity(0.18), lineWidth: 1)
                        )
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))

                Button(action: saveCheckin) {
                    Text(store.todayLog == nil ? "Save Check-in" : "Update Check-in")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Theme.heroGradient, in: RoundedRectangle(cornerRadius: 14))
                        .shadow(color: Theme.primary.opacity(0.35), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(.plain)
                .transition(.opacity)
            }
        }
        .padding(18)
        .glassCard(cornerRadius: 24)
    }

    // MARK: - Week strip
    private var weekStrip: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last 7 Days")
                .font(.system(size: 16, weight: .bold, design: .rounded))
            HStack(spacing: 0) {
                ForEach(Array(zip(weekDayLabels(), store.last7Days).enumerated()), id: \.offset) { idx, pair in
                    let (label, log) = pair
                    VStack(spacing: 6) {
                        Text(label)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                        ZStack {
                            Circle()
                                .fill(log != nil ? log!.mood.color.opacity(0.15) : Color.primary.opacity(0.06))
                                .frame(width: 40, height: 40)
                            if let log = log {
                                Text(log.mood.emoji)
                                    .font(.system(size: 22))
                            } else {
                                Circle()
                                    .stroke(Color.primary.opacity(0.12), style: StrokeStyle(lineWidth: 1.5, dash: [3]))
                                    .frame(width: 30, height: 30)
                            }
                        }
                        if let log = log {
                            Text(log.mood.label)
                                .font(.system(size: 9, weight: .semibold, design: .rounded))
                                .foregroundStyle(log.mood.color)
                                .lineLimit(1)
                        } else {
                            Text("—")
                                .font(.system(size: 9, design: .rounded))
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 22)
    }

    // MARK: - History list
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("History")
                .font(.system(size: 16, weight: .bold, design: .rounded))
            if store.logs.isEmpty {
                Text("No mood logs yet. Start by checking in above!")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 10) {
                    ForEach(store.logs.prefix(14)) { log in
                        MoodHistoryRow(log: log) {
                            store.delete(log)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Confetti overlay
    private var confettiOverlay: some View {
        ZStack {
            Color.clear
            VStack(spacing: 12) {
                Text("🎉")
                    .font(.system(size: 64))
                    .scaleEffect(showConfetti ? 1 : 0.1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showConfetti)
                Text("Mood logged!")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primary)
            }
            .padding(36)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28))
            .transition(.scale.combined(with: .opacity))
        }
        .allowsHitTesting(false)
    }

    // MARK: - Actions
    private func saveCheckin() {
        guard let mood = selectedMood else { return }
        store.log(mood: mood, note: noteText)
        withAnimation { showConfetti = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation { showConfetti = false }
        }
    }

    private func avgEmoji(_ avg: Double) -> String {
        switch avg {
        case 4.5...: return "😄"
        case 3.5...: return "🙂"
        case 2.5...: return "😐"
        case 1.5...: return "😕"
        default:     return "😞"
        }
    }

    private func weekDayLabels() -> [String] {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE"
        return (0..<7).reversed().compactMap { offset in
            Calendar.current.date(byAdding: .day, value: -offset, to: Date()).map { fmt.string(from: $0) }
        }
    }
}

// MARK: - Emoji Button
private struct MoodEmojiButton: View {
    let level: MoodLevel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(level.emoji)
                    .font(.system(size: isSelected ? 34 : 26))
                    .scaleEffect(isSelected ? 1.15 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                Text(level.label)
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundStyle(isSelected ? level.color : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? level.color.opacity(0.15) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? level.color : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - History Row
private struct MoodHistoryRow: View {
    let log: MoodLog
    let onDelete: () -> Void

    private var dateString: String {
        let cal = Calendar.current
        if cal.isDateInToday(log.date) { return "Today" }
        if cal.isDateInYesterday(log.date) { return "Yesterday" }
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM d"
        return fmt.string(from: log.date)
    }

    var body: some View {
        HStack(spacing: 14) {
            Text(log.mood.emoji)
                .font(.system(size: 28))
                .frame(width: 44, height: 44)
                .background(log.mood.color.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(log.mood.label)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                    Text(dateString)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                if !log.note.isEmpty {
                    Text(log.note)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary.opacity(0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .glassCard(cornerRadius: 16)
    }
}

#Preview { MoodView() }
