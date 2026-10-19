import SwiftUI

struct HabitStreakSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Habit Streaks")
                .font(.system(size: 20, weight: .bold, design: .rounded))

            VStack(spacing: 10) {
                ForEach(TrackingData.habits) { habit in
                    HabitRow(habit: habit)
                }
            }
        }
    }
}

private struct HabitRow: View {
    let habit: HabitStreak

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Text(habit.emoji)
                    .font(.system(size: 24))
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.name)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(Theme.accent)
                            .font(.system(size: 11))
                        Text("\(habit.streak) day streak")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundStyle(.secondary)
                        Text("· best \(habit.best)")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Text("\(habit.streak)")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(habit.color)
            }

            // 14-day dot grid
            HStack(spacing: 5) {
                ForEach(Array(habit.completedDays.enumerated()), id: \.offset) { _, done in
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(done ? habit.color : habit.color.opacity(0.18))
                        .frame(height: 20)
                }
            }
        }
        .padding(14)
        .glassCard(cornerRadius: 20)
    }
}
