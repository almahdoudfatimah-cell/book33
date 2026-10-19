import SwiftUI

// MARK: - Missing View Stubs
// This file contains placeholder views for features referenced in RootTabView.swift

// MARK: - Main Navigation Views (Used Throughout App)

// Note: SettingsView has been moved to SharedNavigationViews.swift with full implementation
// Note: AllFeaturesView has been moved to SharedNavigationViews.swift with full implementation

// MARK: - Main Views

// Note: PlanView has been moved to PlanView.swift with full implementation

// MARK: - Training Features

struct IntervalTrainingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "bolt.heart.fill",
                    title: "Interval Training",
                    subtitle: "Create and track interval workouts",
                    color: .orange
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Interval Training")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct RecoveryTrackerView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "figure.cooldown",
                    title: "Recovery Tracker",
                    subtitle: "Monitor your recovery and rest days",
                    color: .green
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Recovery Tracker")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct TrainingGoalsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "target",
                    title: "Training Goals",
                    subtitle: "Set and achieve your training objectives",
                    color: .blue
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Training Goals")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ExerciseLibraryView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "film.fill",
                    title: "Exercise Library",
                    subtitle: "Browse exercises with video demonstrations",
                    color: .purple
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Exercise Library")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct WorkoutPlansView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "list.clipboard.fill",
                    title: "Workout Plans",
                    subtitle: "Pre-made training plans for every goal",
                    color: .green
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Workout Plans")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct TrainingCalendarView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "calendar.badge.clock",
                    title: "Training Calendar",
                    subtitle: "Plan your workouts on a calendar",
                    color: .cyan
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Training Calendar")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct TrainingLogView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "dumbbell.fill",
                    title: "Training Log",
                    subtitle: "View your complete workout history",
                    color: .red
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Training Log")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct TrainingTrackingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "chart.bar.fill",
                    title: "Training Tracking",
                    subtitle: "Detailed analysis of your training",
                    color: .blue
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Training Tracking")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct RaceEventsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "flag.checkered",
                    title: "Race Events",
                    subtitle: "Find and register for upcoming races",
                    color: Theme.primary
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Race Events")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SportsTrackingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "figure.run",
                    title: "Sports Tracking",
                    subtitle: "Track all your sports activities",
                    color: .orange
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Sports Tracking")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Health & Wellness Features

struct NutritionView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "fork.knife",
                    title: "Nutrition",
                    subtitle: "Track your meals and macros",
                    color: .green
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Nutrition")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SleepTrackerView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "bed.double.fill",
                    title: "Sleep Tracker",
                    subtitle: "Monitor your sleep quality and patterns",
                    color: .purple
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Sleep Tracker")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct BodyMetricsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "heart.text.square.fill",
                    title: "Body Metrics",
                    subtitle: "Track weight, body fat, and measurements",
                    color: .pink
                )
                .padding(.top, 60)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Body Metrics")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Settings Features
// Note: All settings-related views (ProfileSettingsView, AppearanceSettingsView, PrivacySettingsView, 
// HelpCenterView, RateAppView) have been moved to SharedNavigationViews.swift

// MARK: - User Assessment View

struct UserAssessmentView: View {
    @State private var currentStep = 0
    @State private var fitnessLevel = 1
    @State private var goalSelection: Set<String> = []
    @State private var weeklyWorkouts = 3
    @State private var selectedSports: Set<String> = []
    @State private var showResults = false
    
    let goals = ["Lose Weight", "Build Muscle", "Run Faster", "Get Stronger", "Stay Active", "Race Prep"]
    let sports = ["Running", "Cycling", "Swimming", "Gym", "Yoga", "Team Sports"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Bar
                ProgressView(value: Double(currentStep + 1), total: 5)
                    .tint(Theme.primary)
                    .padding()
                
                if !showResults {
                    // Assessment Steps
                    TabView(selection: $currentStep) {
                        welcomeStep.tag(0)
                        fitnessLevelStep.tag(1)
                        goalsStep.tag(2)
                        sportsStep.tag(3)
                        scheduleStep.tag(4)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    // Navigation Buttons
                    HStack(spacing: 16) {
                        if currentStep > 0 {
                            Button {
                                withAnimation {
                                    currentStep -= 1
                                }
                            } label: {
                                Text("Back")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        
                        Button {
                            withAnimation {
                                if currentStep < 4 {
                                    currentStep += 1
                                } else {
                                    showResults = true
                                }
                            }
                        } label: {
                            Text(currentStep < 4 ? "Next" : "Get Results")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.heroGradient)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(currentStep == 2 && goalSelection.isEmpty)
                        .disabled(currentStep == 3 && selectedSports.isEmpty)
                    }
                    .padding()
                } else {
                    // Results View
                    assessmentResults
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Fitness Assessment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        // Navigate to Home or root
                    } label: {
                        Label("Home", systemImage: "house")
                    }
                    Spacer()
                    Button {
                        // Navigate to Today view
                    } label: {
                        Label("Today", systemImage: "calendar")
                    }
                    Spacer()
                    Button {
                        // Open Settings
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
        }
    }
    
    // MARK: - Assessment Steps
    
    var welcomeStep: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(Theme.primary)
            
            Text("Let's Get Started!")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text("Answer a few quick questions so we can personalize your training experience")
                .font(.system(size: 17, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding()
    }
    
    var fitnessLevelStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("What's your fitness level?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Text("Be honest - we'll adjust your plan accordingly")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                FitnessLevelOption(
                    icon: "tortoise.fill",
                    title: "Beginner",
                    description: "New to fitness or returning after a break",
                    isSelected: fitnessLevel == 1,
                    color: .green
                ) {
                    fitnessLevel = 1
                }
                
                FitnessLevelOption(
                    icon: "hare.fill",
                    title: "Intermediate",
                    description: "Regular workouts, comfortable with basics",
                    isSelected: fitnessLevel == 2,
                    color: .orange
                ) {
                    fitnessLevel = 2
                }
                
                FitnessLevelOption(
                    icon: "bolt.fill",
                    title: "Advanced",
                    description: "Experienced athlete with solid foundation",
                    isSelected: fitnessLevel == 3,
                    color: .red
                ) {
                    fitnessLevel = 3
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
    
    var goalsStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("What are your goals?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Text("Select all that apply")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(goals, id: \.self) { goal in
                    GoalCard(
                        title: goal,
                        icon: iconForGoal(goal),
                        color: colorForGoal(goal),
                        isSelected: goalSelection.contains(goal)
                    ) {
                        if goalSelection.contains(goal) {
                            goalSelection.remove(goal)
                        } else {
                            goalSelection.insert(goal)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
    
    var sportsStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("What activities do you enjoy?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Text("Choose your favorites")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(sports, id: \.self) { sport in
                    SportCard(
                        title: sport,
                        icon: iconForSport(sport),
                        color: colorForSport(sport),
                        isSelected: selectedSports.contains(sport)
                    ) {
                        if selectedSports.contains(sport) {
                            selectedSports.remove(sport)
                        } else {
                            selectedSports.insert(sport)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
    
    var scheduleStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("How often can you train?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Text("Be realistic - consistency beats intensity")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 24))
                        .foregroundStyle(Theme.primary)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(weeklyWorkouts) workouts per week")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        Text(scheduleRecommendation)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                
                VStack(spacing: 16) {
                    Slider(value: Binding(
                        get: { Double(weeklyWorkouts) },
                        set: { weeklyWorkouts = Int($0) }
                    ), in: 1...7, step: 1)
                    .tint(Theme.primary)
                    
                    HStack {
                        Text("1 day")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("7 days")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
    
    var assessmentResults: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Success Header
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)
                    
                    Text("Your Plan is Ready!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    
                    Text("Based on your assessment, here's what we recommend")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                // Results Cards
                VStack(spacing: 16) {
                    ResultCard(
                        icon: "target",
                        title: "Your Goals",
                        items: Array(goalSelection),
                        color: .blue
                    )
                    
                    ResultCard(
                        icon: "figure.run",
                        title: "Recommended Activities",
                        items: Array(selectedSports),
                        color: .orange
                    )
                    
                    ResultCard(
                        icon: "calendar.badge.clock",
                        title: "Weekly Schedule",
                        items: ["\(weeklyWorkouts) workouts per week", scheduleRecommendation],
                        color: .purple
                    )
                    
                    ResultCard(
                        icon: fitnessLevel == 1 ? "tortoise.fill" : (fitnessLevel == 2 ? "hare.fill" : "bolt.fill"),
                        title: "Fitness Level",
                        items: [fitnessLevel == 1 ? "Beginner" : (fitnessLevel == 2 ? "Intermediate" : "Advanced")],
                        color: fitnessLevel == 1 ? .green : (fitnessLevel == 2 ? .orange : .red)
                    )
                }
                .padding(.horizontal)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        // Start training
                    } label: {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 20))
                            Text("Start Training")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.heroGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button {
                        withAnimation {
                            currentStep = 0
                            showResults = false
                            goalSelection.removeAll()
                            selectedSports.removeAll()
                        }
                    } label: {
                        Text("Retake Assessment")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Helper Functions
    
    var scheduleRecommendation: String {
        switch weeklyWorkouts {
        case 1...2: return "Light activity - Perfect for beginners"
        case 3...4: return "Balanced routine - Great for consistency"
        case 5...6: return "Serious training - You're committed!"
        default: return "Elite schedule - Maximum dedication!"
        }
    }
    
    func iconForGoal(_ goal: String) -> String {
        switch goal {
        case "Lose Weight": return "flame.fill"
        case "Build Muscle": return "figure.strengthtraining.traditional"
        case "Run Faster": return "bolt.fill"
        case "Get Stronger": return "dumbbell.fill"
        case "Stay Active": return "figure.walk"
        case "Race Prep": return "flag.checkered"
        default: return "star.fill"
        }
    }
    
    func colorForGoal(_ goal: String) -> Color {
        switch goal {
        case "Lose Weight": return .orange
        case "Build Muscle": return .red
        case "Run Faster": return .blue
        case "Get Stronger": return .purple
        case "Stay Active": return .green
        case "Race Prep": return .yellow
        default: return .cyan
        }
    }
    
    func iconForSport(_ sport: String) -> String {
        switch sport {
        case "Running": return "figure.run"
        case "Cycling": return "bicycle"
        case "Swimming": return "figure.pool.swim"
        case "Gym": return "dumbbell.fill"
        case "Yoga": return "figure.yoga"
        case "Team Sports": return "sportscourt.fill"
        default: return "figure.walk"
        }
    }
    
    func colorForSport(_ sport: String) -> Color {
        switch sport {
        case "Running": return .orange
        case "Cycling": return .blue
        case "Swimming": return .cyan
        case "Gym": return .red
        case "Yoga": return .purple
        case "Team Sports": return .green
        default: return .gray
        }
    }
}

// MARK: - Assessment Supporting Views

struct FitnessLevelOption: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(isSelected ? .white : color)
                    .frame(width: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(isSelected ? .white : .primary)
                    
                    Text(description)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundStyle(isSelected ? .white.opacity(0.9) : .secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .background(isSelected ? color.gradient : Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct GoalCard: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(isSelected ? .white : color)
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(isSelected ? color.gradient : Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct SportCard: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(isSelected ? .white : color)
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(isSelected ? color.gradient : Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ResultCard: View {
    let icon: String
    let title: String
    let items: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                    .frame(width: 40)
                
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(color)
                        
                        Text(item)
                            .font(.system(size: 16, design: .rounded))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - AI Assistant View

struct AIAssistantView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hello! I'm your AI training assistant. How can I help you today?", isUser: false)
    ]
    @State private var inputText = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _, _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input Bar
            HStack(spacing: 12) {
                TextField("Ask me anything...", text: $inputText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .focused($isInputFocused)
                    .lineLimit(1...4)
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(inputText.isEmpty ? .gray : Theme.primary)
                }
                .disabled(inputText.isEmpty)
            }
            .padding()
            .background(Color(uiColor: .systemGroupedBackground))
        }
        .navigationTitle("AI Assistant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Clear conversation
                    messages = [ChatMessage(text: "Hello! I'm your AI training assistant. How can I help you today?", isUser: false)]
                } label: {
                    Image(systemName: "trash")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    // New chat action
                    messages = [ChatMessage(text: "Hello! I'm your AI training assistant. How can I help you today?", isUser: false)]
                } label: {
                    Label("New Chat", systemImage: "plus.bubble")
                }
                Spacer()
                Button {
                    // Help action
                } label: {
                    Label("Help", systemImage: "questionmark.circle")
                }
                Spacer()
                Button {
                    // Settings action
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        // Add user message
        messages.append(ChatMessage(text: inputText, isUser: true))
        let userInput = inputText
        inputText = ""
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let response = generateResponse(for: userInput)
            messages.append(ChatMessage(text: response, isUser: false))
        }
    }
    
    private func generateResponse(for input: String) -> String {
        let lowerInput = input.lowercased()
        
        if lowerInput.contains("workout") || lowerInput.contains("exercise") {
            return "I can help you plan your workout! What type of exercise are you interested in? Running, strength training, cycling, or something else?"
        } else if lowerInput.contains("running") || lowerInput.contains("run") {
            return "Running is great! I recommend starting with a 5-minute warm-up, then do intervals or steady state depending on your goals. Don't forget to cool down and stretch!"
        } else if lowerInput.contains("nutrition") || lowerInput.contains("diet") || lowerInput.contains("food") {
            return "For optimal performance, focus on balanced nutrition: proteins for recovery, carbs for energy, and healthy fats. Stay hydrated and eat within 30 minutes after training!"
        } else if lowerInput.contains("goal") || lowerInput.contains("target") {
            return "Setting clear goals is key! Use SMART goals: Specific, Measurable, Achievable, Relevant, and Time-bound. What would you like to achieve?"
        } else if lowerInput.contains("rest") || lowerInput.contains("recovery") {
            return "Recovery is just as important as training! Make sure you get 7-9 hours of sleep, stay hydrated, and take rest days. Active recovery like light walking or yoga can help too."
        } else if lowerInput.contains("injury") || lowerInput.contains("pain") || lowerInput.contains("hurt") {
            return "If you're experiencing pain, it's important to listen to your body. Consider taking a rest day, applying ice, and if pain persists, consult a healthcare professional."
        } else {
            return "That's a great question! I'm here to help with workout planning, nutrition advice, goal setting, recovery tips, and general fitness guidance. What specific area would you like to explore?"
        }
    }
}

// MARK: - EmptyStateView (Shared Component)

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundStyle(color.gradient)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Text(subtitle)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Text("Coming Soon")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(color.gradient)
                .clipShape(Capsule())
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Additional Health & Fitness Tracking Views

struct StepsCounterView: View {
    var body: some View {
        EmptyStateView(
            icon: "figure.walk",
            title: "Steps Counter",
            subtitle: "Track your daily step count and activity",
            color: .green
        )
        .navigationTitle("Steps Counter")
    }
}

struct CalorieTrackerView: View {
    var body: some View {
        EmptyStateView(
            icon: "flame.fill",
            title: "Calorie Tracker",
            subtitle: "Monitor calories burned during workouts",
            color: .orange
        )
        .navigationTitle("Calorie Tracker")
    }
}

struct HeartRateMonitorView: View {
    var body: some View {
        EmptyStateView(
            icon: "heart.fill",
            title: "Heart Rate Monitor",
            subtitle: "Track heart rate zones and cardiovascular health",
            color: .red
        )
        .navigationTitle("Heart Rate Monitor")
    }
}

struct VO2MaxTrackerView: View {
    var body: some View {
        EmptyStateView(
            icon: "wind",
            title: "VO2 Max Tracker",
            subtitle: "Monitor your aerobic fitness level",
            color: .blue
        )
        .navigationTitle("VO2 Max")
    }
}

struct BodyFatTrackerView: View {
    var body: some View {
        EmptyStateView(
            icon: "percent",
            title: "Body Fat Tracker",
            subtitle: "Track body composition over time",
            color: .purple
        )
        .navigationTitle("Body Fat")
    }
}

struct WeightTrackingView: View {
    var body: some View {
        EmptyStateView(
            icon: "scalemass.fill",
            title: "Weight Tracking",
            subtitle: "Log and monitor weight changes",
            color: .cyan
        )
        .navigationTitle("Weight Tracking")
    }
}

struct MeasurementsView: View {
    var body: some View {
        EmptyStateView(
            icon: "ruler.fill",
            title: "Measurements",
            subtitle: "Track body measurements and progress photos",
            color: .indigo
        )
        .navigationTitle("Measurements")
    }
}

struct MeditationView: View {
    var body: some View {
        EmptyStateView(
            icon: "sparkles",
            title: "Meditation",
            subtitle: "Guided meditation and mindfulness exercises",
            color: .purple
        )
        .navigationTitle("Meditation")
    }
}

struct MentalHealthView: View {
    var body: some View {
        EmptyStateView(
            icon: "brain.head.profile",
            title: "Mental Health",
            subtitle: "Track mood, stress levels, and mental wellbeing",
            color: .pink
        )
        .navigationTitle("Mental Health")
    }
}

struct ProgressChartsView: View {
    var body: some View {
        EmptyStateView(
            icon: "chart.line.uptrend.xyaxis",
            title: "Progress Charts",
            subtitle: "Visualize your fitness progress over time",
            color: .blue
        )
        .navigationTitle("Progress Charts")
    }
}

struct PerformanceTrackingView: View {
    var body: some View {
        EmptyStateView(
            icon: "chart.bar.xaxis",
            title: "Performance Tracking",
            subtitle: "Detailed performance metrics and analysis",
            color: .green
        )
        .navigationTitle("Performance Tracking")
    }
}

struct PersonalRecordsView: View {
    var body: some View {
        EmptyStateView(
            icon: "trophy.fill",
            title: "Personal Records",
            subtitle: "Track your PRs and achievements",
            color: .yellow
        )
        .navigationTitle("Personal Records")
    }
}

struct StrengthProgressView: View {
    var body: some View {
        EmptyStateView(
            icon: "dumbbell.fill",
            title: "Strength Progress",
            subtitle: "Track lifting stats and strength gains",
            color: .red
        )
        .navigationTitle("Strength Progress")
    }
}

struct WorkoutDurationView: View {
    var body: some View {
        EmptyStateView(
            icon: "timer",
            title: "Workout Duration",
            subtitle: "Analyze workout length and time trends",
            color: .orange
        )
        .navigationTitle("Workout Duration")
    }
}

struct DistanceTrackerView: View {
    var body: some View {
        EmptyStateView(
            icon: "map.fill",
            title: "Distance Tracker",
            subtitle: "Track total distance across all activities",
            color: .teal
        )
        .navigationTitle("Distance Tracker")
    }
}

struct ActivityBreakdownView: View {
    var body: some View {
        EmptyStateView(
            icon: "chart.pie.fill",
            title: "Activity Breakdown",
            subtitle: "See how you split time across different sports",
            color: .purple
        )
        .navigationTitle("Activity Breakdown")
    }
}

struct WorkoutLoggerView: View {
    var body: some View {
        EmptyStateView(
            icon: "note.text",
            title: "Workout Logger",
            subtitle: "Log exercises, sets, reps, and weights",
            color: .blue
        )
        .navigationTitle("Workout Logger")
    }
}

struct FriendsView: View {
    var body: some View {
        EmptyStateView(
            icon: "person.2.fill",
            title: "Friends",
            subtitle: "Connect with friends and training partners",
            color: .green
        )
        .navigationTitle("Friends")
    }
}

struct LeaderboardsView: View {
    var body: some View {
        EmptyStateView(
            icon: "list.number",
            title: "Leaderboards",
            subtitle: "Compete with friends and the community",
            color: .yellow
        )
        .navigationTitle("Leaderboards")
    }
}

struct ShoeTrackerView: View {
    var body: some View {
        EmptyStateView(
            icon: "shoe.fill",
            title: "Shoe Tracker",
            subtitle: "Track running shoe mileage and lifespan",
            color: .orange
        )
        .navigationTitle("Shoe Tracker")
    }
}

struct BikeMaintenanceView: View {
    var body: some View {
        EmptyStateView(
            icon: "bicycle",
            title: "Bike Maintenance",
            subtitle: "Log bike service and maintenance schedules",
            color: .blue
        )
        .navigationTitle("Bike Maintenance")
    }
}

struct GearInventoryView: View {
    var body: some View {
        EmptyStateView(
            icon: "backpack.fill",
            title: "Gear Inventory",
            subtitle: "Manage your training equipment and gear",
            color: .brown
        )
        .navigationTitle("Gear Inventory")
    }
}

struct DeviceSyncView: View {
    var body: some View {
        EmptyStateView(
            icon: "applewatch",
            title: "Device Sync",
            subtitle: "Connect watches, heart rate monitors & sensors",
            color: .gray
        )
        .navigationTitle("Device Sync")
    }
}

struct PremiumMembershipView: View {
    var body: some View {
        EmptyStateView(
            icon: "crown.fill",
            title: "Premium Membership",
            subtitle: "Unlock all features with premium",
            color: .yellow
        )
        .navigationTitle("Premium")
    }
}

struct AdvancedAnalyticsView: View {
    var body: some View {
        EmptyStateView(
            icon: "chart.bar.doc.horizontal.fill",
            title: "Advanced Analytics",
            subtitle: "Deep dive into your training data",
            color: .blue
        )
        .navigationTitle("Advanced Analytics")
    }
}

// AppearanceSettingsView - removed to avoid duplicate definition (defined in ProfileView.swift with full implementation)

// ProfileSettingsView - removed to avoid duplicate definition (defined in ProfileView.swift with full implementation)

// NotificationSettingsView - removed to avoid duplicate definition (defined in ProfileView.swift with full implementation)

struct TrainingTrackingView: View {
    var body: some View {
        EmptyStateView(
            icon: "chart.bar.fill",
            title: "Training Tracking",
            subtitle: "Detailed analysis of your training",
            color: .blue
        )
        .navigationTitle("Training Tracking")
    }
}

// MARK: - Previews

#Preview("User Assessment") {
    NavigationStack {
        UserAssessmentView()
    }
}

#Preview("AI Assistant") {
    NavigationStack {
        AIAssistantView()
    }
}

#Preview("Empty State") {
    EmptyStateView(
        icon: "sparkles",
        title: "Coming Soon",
        subtitle: "This feature is under development",
        color: .blue
    )
}
