import SwiftUI

struct HabitsView: View {
    @StateObject private var store = HabitStore.shared
    @State private var showAdd = false

    var body: some View {
        NavigationStack {
            Group {
                if store.habits.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddHabitSheet()
                    .presentationDetents([.medium])
            }
        }.appPageTheme()
    }

    private var list: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(store.habits) { habit in
                    HabitRow(habit: habit)
                }
            }
            .padding(16)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "checklist")
                .font(.system(size: 50))
                .foregroundStyle(Theme.primary.opacity(0.5))
            Text("Track your first habit")
                .font(.system(.title3, design: .rounded, weight: .bold))
            Text("Small daily wins compound into big changes.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
            Button { showAdd = true } label: {
                Text("Add a habit")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .frame(height: 50)
                    .background(Theme.heroGradient, in: Capsule())
                    .shadow(color: Theme.primary.opacity(0.4), radius: 14, y: 6)
            }
            .padding(.top, 6)
        }
    }
}

private struct HabitRow: View {
    let habit: Habit
    @StateObject private var store = HabitStore.shared

    var body: some View {
        HStack(spacing: 14) {
            Button { store.toggleToday(habit) } label: {
                ZStack {
                    Circle()
                        .fill(habit.isCompletedToday ? Theme.heroGradient : LinearGradient(colors: [.gray.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 44, height: 44)
                    Text(habit.emoji)
                        .font(.system(size: 20))
                    if habit.isCompletedToday {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .background(Theme.primary, in: Circle())
                            .offset(x: 16, y: 16)
                    }
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                if habit.currentStreak > 0 {
                    Text("\(habit.currentStreak) day streak 🔥")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Theme.primary)
                } else {
                    Text("Tap to complete today")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Menu {
                Button("Delete", role: .destructive) { store.delete(habit) }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.secondary)
                    .padding(8)
            }
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

private struct HabitPreset: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
}

private struct AddHabitSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = HabitStore.shared
    @State private var name = ""
    @State private var emoji = "✨"

    private let emojis = ["✨", "💪", "📚", "🧘", "💧", "🏃", "🥗", "😴", "🎨", "📝", "🔥", "🍎"]

    private let presets: [HabitPreset] = [
        HabitPreset(name: "Sports", emoji: "🏃"),
        HabitPreset(name: "Drink water", emoji: "💧"),
        HabitPreset(name: "Read a book", emoji: "📚"),
        HabitPreset(name: "Calorie tracking", emoji: "🍎"),
        HabitPreset(name: "Sleeping hours", emoji: "😴"),
        HabitPreset(name: "Working hours", emoji: "💼"),
        HabitPreset(name: "Studying hours", emoji: "📖"),
        HabitPreset(name: "Assessment", emoji: "📝")
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Quick add") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        ForEach(presets) { preset in
                            Button {
                                name = preset.name
                                emoji = preset.emoji
                            } label: {
                                HStack(spacing: 8) {
                                    Text(preset.emoji)
                                        .font(.system(size: 18))
                                    Text(preset.name)
                                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.primary)
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(name == preset.name ? Theme.primary.opacity(0.18) : Color.gray.opacity(0.08))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
                Section("Habit") {
                    TextField("e.g. Drink water", text: $name)
                }
                Section("Emoji") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                        ForEach(emojis, id: \.self) { e in
                            Text(e)
                                .font(.system(size: 26))
                                .frame(width: 44, height: 44)
                                .background(emoji == e ? Theme.primary.opacity(0.18) : Color.gray.opacity(0.08), in: Circle())
                                .onTapGesture { emoji = e }
                        }
                    }
                    .padding(.vertical, 6)
                }
            }.appPageTheme()
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        store.add(name: name, emoji: emoji)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }.appPageTheme()
    }
}

#Preview { HabitsView() }
