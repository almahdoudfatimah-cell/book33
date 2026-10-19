import SwiftUI
import Charts

struct LifeGoalsSection: View {
    @State private var goals = SampleData.goals
    @State private var selectedFilter: GoalFilter = .all
    @State private var showingNewGoal = false

    private var filteredGoals: [LifeGoal] {
        switch selectedFilter {
        case .all:
            goals
        case .active:
            goals.filter { $0.progress < 1 }
        case .completed:
            goals.filter { $0.progress >= 1 }
        }
    }

    private var averageProgress: Int {
        guard !goals.isEmpty else { return 0 }
        return Int((goals.map(\.progress).reduce(0, +) / Double(goals.count)) * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            summary
            quickGoalIdeas
            filterPicker

            if filteredGoals.isEmpty {
                ContentUnavailableView(
                    "No \(selectedFilter.rawValue) Goals",
                    systemImage: "target",
                    description: Text("Add a goal or choose another filter.")
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .glassCard(cornerRadius: 20)
            } else {
                VStack(spacing: 10) {
                    ForEach(filteredGoals) { goal in
                        GoalDetailRow(
                            goal: goal,
                            onCheckIn: { checkIn(to: goal) },
                            onDelete: { delete(goal) }
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewGoal) {
            NewLifeGoalSheet(goals: $goals)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Life Goals")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.black)
                Text("Build progress in every part of your life")
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.62))
            }

            Spacer()

            Button {
                showingNewGoal = true
            } label: {
                Label("Add", systemImage: "plus")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 9)
                    .background(Theme.heroGradient, in: Capsule())
            }
            .buttonStyle(.plain)
        }
    }

    private var summary: some View {
        HStack(spacing: 10) {
            GoalSummaryCard(value: "\(goals.count)", label: "Total", icon: "target", color: Theme.primary)
            GoalSummaryCard(value: "\(goals.filter { $0.progress >= 1 }.count)", label: "Finished", icon: "checkmark.seal.fill", color: .green)
            GoalSummaryCard(value: "\(averageProgress)%", label: "Progress", icon: "chart.line.uptrend.xyaxis", color: .blue)
        }
    }

    private var quickGoalIdeas: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Goal Ideas")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.black)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    GoalIdeaButton(emoji: "🧘", title: "Mindfulness") {
                        addIdea(title: "Meditate 10 minutes daily", emoji: "🧘", color: .purple)
                    }
                    GoalIdeaButton(emoji: "✈️", title: "Travel") {
                        addIdea(title: "Plan my dream trip", emoji: "✈️", color: .blue)
                    }
                    GoalIdeaButton(emoji: "💼", title: "Career") {
                        addIdea(title: "Build a new career skill", emoji: "💼", color: .indigo)
                    }
                    GoalIdeaButton(emoji: "❤️", title: "Relationships") {
                        addIdea(title: "Make time for loved ones", emoji: "❤️", color: .pink)
                    }
                    GoalIdeaButton(emoji: "🌱", title: "Wellness") {
                        addIdea(title: "Create a healthy routine", emoji: "🌱", color: .green)
                    }
                }
            }
        }
        .padding(14)
        .glassCard(cornerRadius: 18)
    }

    private var filterPicker: some View {
        HStack(spacing: 6) {
            ForEach(GoalFilter.allCases, id: \.self) { filter in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = filter
                    }
                } label: {
                    Text(filter.rawValue)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(selectedFilter == filter ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            selectedFilter == filter ? AnyShapeStyle(Theme.heroGradient) : AnyShapeStyle(Color.black.opacity(0.06)),
                            in: Capsule()
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func checkIn(to goal: LifeGoal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        withAnimation(.easeInOut) {
            goals[index].progress = min(1, goals[index].progress + 0.05)
            goals[index].streak += 1
        }
    }

    private func delete(_ goal: LifeGoal) {
        withAnimation {
            goals.removeAll { $0.id == goal.id }
        }
    }

    private func addIdea(title: String, emoji: String, color: Color) {
        guard !goals.contains(where: { $0.title == title }) else { return }
        withAnimation {
            goals.append(LifeGoal(title: title, emoji: emoji, progress: 0, streak: 0, color: color))
        }
    }
}

private enum GoalFilter: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}

private struct GoalSummaryCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(.black)
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.black.opacity(0.62))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .glassCard(cornerRadius: 16, tint: color)
    }
}

private struct GoalIdeaButton: View {
    let emoji: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(emoji)
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.black)
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 9)
            .background(Theme.surface, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct GoalDetailRow: View {
    let goal: LifeGoal
    let onCheckIn: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Text(goal.emoji)
                    .font(.system(size: 28))
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(goal.color.opacity(0.12)))

                VStack(alignment: .leading, spacing: 3) {
                    Text(goal.title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                    Label("\(goal.streak) day streak", systemImage: "flame.fill")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(Theme.accent)
                }
                Spacer()

                ZStack {
                    Circle()
                        .stroke(goal.color.opacity(0.18), lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: goal.progress)
                        .stroke(goal.color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(goal.progress * 100))%")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(goal.color)
                }
                .frame(width: 52, height: 52)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(goal.color.opacity(0.15))
                        .frame(height: 10)
                    Capsule()
                        .fill(LinearGradient(colors: [goal.color, goal.color.opacity(0.65)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * goal.progress, height: 10)

                    ForEach([0.25, 0.5, 0.75], id: \.self) { tick in
                        Rectangle()
                            .fill(Theme.pageBackground.opacity(0.7))
                            .frame(width: 2, height: 14)
                            .offset(x: geo.size.width * tick - 1, y: -2)
                    }
                }
            }
            .frame(height: 14)

            HStack {
                Button(action: onCheckIn) {
                    Label(goal.progress >= 1 ? "Completed" : "Daily Check-in", systemImage: goal.progress >= 1 ? "checkmark.seal.fill" : "plus.circle.fill")
                        .font(.caption.bold())
                        .foregroundStyle(goal.progress >= 1 ? .green : goal.color)
                }
                .buttonStyle(.plain)
                .disabled(goal.progress >= 1)

                Spacer()

                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .font(.caption.bold())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .glassCard(cornerRadius: 20)
    }
}

private struct NewLifeGoalSheet: View {
    @Binding var goals: [LifeGoal]
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var emoji = "🎯"
    @State private var selectedColorIndex = 0

    private let colors: [Color] = [Theme.primary, .blue, .green, .purple, .pink, .orange]
    private let emojis = ["🎯", "🏃", "📚", "💰", "✈️", "🧘", "❤️", "🌱"]

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("What would you like to achieve?")
                            .font(.title2.bold())
                            .foregroundStyle(.black)

                        TextField("Goal title", text: $title)
                            .textFieldStyle(.roundedBorder)

                        Text("Choose an icon")
                            .font(.headline)
                            .foregroundStyle(.black)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                            ForEach(emojis, id: \.self) { item in
                                Button {
                                    emoji = item
                                } label: {
                                    Text(item)
                                        .font(.system(size: 28))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(emoji == item ? Theme.primary.opacity(0.2) : Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 14))
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        Text("Choose a color")
                            .font(.headline)
                            .foregroundStyle(.black)

                        HStack {
                            ForEach(colors.indices, id: \.self) { index in
                                Button {
                                    selectedColorIndex = index
                                } label: {
                                    Circle()
                                        .fill(colors[index])
                                        .frame(width: 38, height: 38)
                                        .overlay {
                                            if selectedColorIndex == index {
                                                Image(systemName: "checkmark")
                                                    .font(.caption.bold())
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Life Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        goals.append(
                            LifeGoal(
                                title: trimmedTitle,
                                emoji: emoji,
                                progress: 0,
                                streak: 0,
                                color: colors[selectedColorIndex]
                            )
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .appPageTheme()
    }
}
