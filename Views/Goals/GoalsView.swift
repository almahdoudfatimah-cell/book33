import SwiftUI
import Charts

struct GoalsView: View {
    @Environment(\.colorScheme) private var scheme
    @State private var selectedPeriod: Period = .week

    enum Period: String, CaseIterable { case week = "Week"; case month = "Month" }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView {
                    VStack(spacing: 20) {
                        periodPicker
                        if selectedPeriod == .week {
                            weekContent
                        } else {
                            MonthTrackingView()
                        }
                        Color.clear.frame(height: 24)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Tracking")
            .navigationBarTitleDisplayMode(.inline)
        }.appPageTheme()
    }

    private var weekContent: some View {
        Group {
            SummaryStatsRow()
            
            // Quick Action Cards
            QuickActionsGrid()
            
            ActivityBarChart()
            CategoryDonutChart()
            
            // Training Progress Section
            TrainingProgressCard()
            
            // Nutrition Tracker
            NutritionTrackerCard()
            
            // Sleep Quality
            SleepQualityCard()
            
            // Steps & Activity
            StepsActivityCard()
            
            PremiumGate(
                featureTitle: "Mood Trends",
                featureSubtitle: "Track your emotional patterns with\nbeautiful AI-powered insights",
                icon: "waveform.path.ecg"
            ) { MoodLineChart() }
            
            PremiumGate(
                featureTitle: "Habit Streaks",
                featureSubtitle: "Full streak history, best streaks,\nand detailed habit analytics",
                icon: "flame.fill"
            ) { HabitStreakSection() }
            
            // Body Metrics Section
            BodyMetricsCard()
            
            // Workout Intensity
            WorkoutIntensityCard()
            
            // Recovery Score
            RecoveryScoreCard()
            
            LifeGoalsSection()
        }
    }

    private var periodPicker: some View {
        HStack(spacing: 0) {
            ForEach(Period.allCases, id: \.self) { p in
                Button { withAnimation(.spring(response: 0.3)) { selectedPeriod = p } } label: {
                    Text(p.rawValue)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(selectedPeriod == p ? .white : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            if selectedPeriod == p {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Theme.heroGradient)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .glassCard(cornerRadius: 16)
    }
}

// MARK: - New Tracking Components

enum TrackingQuickAction: String, CaseIterable {
    case workout = "Log Workout"
    case meal = "Log Meal"
    case run = "Start Run"
    case sleep = "Log Sleep"
    case water = "Water"
    case weight = "Log Weight"
    case heartRate = "Heart Rate"
    case bike = "Bike Ride"
    case swimming = "Swimming"
    case yoga = "Yoga"
    case record = "New Record"
    case recovery = "Recovery"

    var icon: String {
        switch self {
        case .workout: "plus.circle.fill"
        case .meal: "fork.knife"
        case .run: "figure.run"
        case .sleep: "moon.stars.fill"
        case .water: "drop.fill"
        case .weight: "scalemass.fill"
        case .heartRate: "heart.fill"
        case .bike: "bicycle"
        case .swimming: "figure.pool.swim"
        case .yoga: "figure.yoga"
        case .record: "trophy.fill"
        case .recovery: "figure.cooldown"
        }
    }

    var color: Color {
        switch self {
        case .workout, .heartRate: .red
        case .meal, .recovery: .green
        case .run: .orange
        case .sleep, .yoga: .purple
        case .water: .cyan
        case .weight: .pink
        case .bike: .blue
        case .swimming: .teal
        case .record: .yellow
        }
    }

    var valuePrompt: String {
        switch self {
        case .workout, .run, .bike, .swimming, .yoga: "Duration or distance"
        case .meal: "Meal and calories"
        case .sleep: "Hours slept"
        case .water: "Amount of water"
        case .weight: "Weight"
        case .heartRate: "Beats per minute"
        case .record: "Record and result"
        case .recovery: "Recovery score or activity"
        }
    }
}

struct QuickActionsGrid: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(.black)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(TrackingQuickAction.allCases, id: \.self) { action in
                    NavigationLink {
                        TrackingQuickActionDetailView(action: action)
                    } label: {
                        QuickActionCard(action: action)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .glassCard()
    }
}

struct QuickActionCard: View {
    let action: TrackingQuickAction

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: action.icon)
                .font(.system(size: 28))
                .foregroundStyle(action.color)
            Text(action.rawValue)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
    }
}

struct TrackingQuickActionDetailView: View {
    let action: TrackingQuickAction

    @Environment(\.dismiss) private var dismiss
    @State private var value = ""
    @State private var notes = ""
    @State private var date = Date()
    @State private var didSave = false

    private var canSave: Bool {
        !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            PaperBackground()

            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: action.icon)
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundStyle(action.color)
                        .frame(width: 92, height: 92)
                        .background(action.color.opacity(0.14), in: Circle())

                    Text("Add your latest activity details below.")
                        .font(.system(size: 15, design: .rounded))
                        .foregroundStyle(.black.opacity(0.65))
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 14) {
                        Text(action.valuePrompt)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)

                        TextField(action.valuePrompt, text: $value)
                            .textFieldStyle(.roundedBorder)

                        DatePicker("Date and time", selection: $date)
                            .foregroundStyle(.black)

                        Text("Notes")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)

                        TextField("How did it feel?", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(18)
                    .glassCard()

                    Button {
                        didSave = true
                    } label: {
                        Label(didSave ? "Saved" : "Save Entry",
                              systemImage: didSave ? "checkmark.circle.fill" : "square.and.arrow.down.fill")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(didSave ? Color.green : action.color)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!canSave)
                    .opacity(canSave ? 1 : 0.5)
                }
                .padding(20)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationTitle(action.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .appPageTheme()
    }
}

struct TrainingProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 20))
                    .foregroundStyle(Theme.primary)
                Text("Training Progress")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("This Week")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                StatBubble(value: "5", label: "Workouts", color: .red)
                StatBubble(value: "320", label: "Minutes", color: .blue)
                StatBubble(value: "1,240", label: "Calories", color: .orange)
            }
        }
        .padding(16)
        .glassCard()
    }
}

struct NutritionTrackerCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "fork.knife")
                    .font(.system(size: 20))
                    .foregroundStyle(.green)
                Text("Nutrition")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("Today")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                StatBubble(value: "1,820", label: "Calories", color: .green)
                StatBubble(value: "150g", label: "Protein", color: .red)
                StatBubble(value: "2.1L", label: "Water", color: .cyan)
            }
        }
        .padding(16)
        .glassCard()
    }
}

struct SleepQualityCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bed.double.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.purple)
                Text("Sleep Quality")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("Last Night")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                StatBubble(value: "7.5h", label: "Duration", color: .purple)
                StatBubble(value: "85%", label: "Quality", color: .blue)
                StatBubble(value: "23:00", label: "Bedtime", color: .indigo)
            }
        }
        .padding(16)
        .glassCard()
    }
}

struct StepsActivityCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.walk")
                    .font(.system(size: 20))
                    .foregroundStyle(.green)
                Text("Steps & Activity")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("Today")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                StatBubble(value: "8,432", label: "Steps", color: .green)
                StatBubble(value: "6.2km", label: "Distance", color: .orange)
                StatBubble(value: "124", label: "Floors", color: .blue)
            }
        }
        .padding(16)
        .glassCard()
    }
}

struct BodyMetricsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.pink)
                Text("Body Metrics")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("Latest")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                StatBubble(value: "75.2kg", label: "Weight", color: .pink)
                StatBubble(value: "18%", label: "Body Fat", color: .orange)
                StatBubble(value: "BMI 23", label: "Healthy", color: .green)
            }
        }
        .padding(16)
        .glassCard()
    }
}

struct WorkoutIntensityCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bolt.heart.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.orange)
                Text("Workout Intensity")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("This Week")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                StatBubble(value: "142", label: "Avg HR", color: .pink)
                StatBubble(value: "178", label: "Max HR", color: .red)
                StatBubble(value: "Zone 3", label: "Most Time", color: .orange)
            }
        }
        .padding(16)
        .glassCard()
    }
}

struct RecoveryScoreCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 20))
                    .foregroundStyle(.cyan)
                Text("Recovery Score")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("Today")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                StatBubble(value: "87/100", label: "Score", color: .green)
                StatBubble(value: "Good", label: "Status", color: .cyan)
                StatBubble(value: "Train", label: "Ready", color: .blue)
            }
        }
        .padding(16)
        .glassCard()
    }
}

struct StatBubble: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview { GoalsView() }
