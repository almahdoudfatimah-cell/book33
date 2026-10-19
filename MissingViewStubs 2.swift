import SwiftUI

// MARK: - Missing View Stubs
// This file contains placeholder views for features referenced in RootTabView.swift

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

struct ProfileSettingsView: View {
    var body: some View {
        List {
            Section("Profile Information") {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Your Name")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text("you@example.com")
                        .foregroundStyle(.secondary)
                }
            }
            
            Section("Fitness Profile") {
                HStack {
                    Text("Age")
                    Spacer()
                    Text("25")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Weight")
                    Spacer()
                    Text("70 kg")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Height")
                    Spacer()
                    Text("175 cm")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Profile Settings")
    }
}

struct AppearanceSettingsView: View {
    @State private var selectedTheme = 0
    @State private var accentColor = 0
    
    var body: some View {
        List {
            Section("Theme") {
                Picker("Appearance", selection: $selectedTheme) {
                    Text("System").tag(0)
                    Text("Light").tag(1)
                    Text("Dark").tag(2)
                }
                .pickerStyle(.segmented)
            }
            
            Section("Accent Color") {
                Picker("Color", selection: $accentColor) {
                    Text("Orange").tag(0)
                    Text("Blue").tag(1)
                    Text("Purple").tag(2)
                    Text("Green").tag(3)
                }
            }
            
            Section("Display") {
                Toggle("Show Progress Badges", isOn: .constant(true))
                Toggle("Animate Transitions", isOn: .constant(true))
            }
        }
        .navigationTitle("Appearance")
    }
}

struct PrivacySettingsView: View {
    @State private var analyticsEnabled = false
    @State private var crashReportsEnabled = true
    
    var body: some View {
        List {
            Section("Data Collection") {
                Toggle("Analytics", isOn: $analyticsEnabled)
                Toggle("Crash Reports", isOn: $crashReportsEnabled)
            }
            
            Section("Privacy") {
                Toggle("Location Access", isOn: .constant(true))
                Toggle("Health Data Access", isOn: .constant(true))
                Toggle("Motion & Fitness", isOn: .constant(true))
            }
            
            Section {
                Button("View Privacy Policy") {}
                Button("View Terms of Service") {}
            }
        }
        .navigationTitle("Privacy")
    }
}

// MARK: - Support Features

struct HelpCenterView: View {
    var body: some View {
        List {
            Section("Getting Started") {
                NavigationLink("How to track workouts") {
                    Text("Help content coming soon")
                }
                NavigationLink("Setting up your profile") {
                    Text("Help content coming soon")
                }
                NavigationLink("Understanding metrics") {
                    Text("Help content coming soon")
                }
            }
            
            Section("Common Questions") {
                NavigationLink("How to sync devices?") {
                    Text("Help content coming soon")
                }
                NavigationLink("How to export data?") {
                    Text("Help content coming soon")
                }
                NavigationLink("How to cancel subscription?") {
                    Text("Help content coming soon")
                }
            }
            
            Section {
                Button("Contact Support") {}
                Button("Send Feedback") {}
            }
        }
        .navigationTitle("Help Center")
    }
}

struct RateAppView: View {
    @State private var rating = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "star.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color(red: 1.0, green: 0.8, blue: 0.0))
            
            Text("Rate Our App")
                .font(.title.bold())
            
            Text("Your feedback helps us improve")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { index in
                    Button {
                        rating = index
                    } label: {
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .font(.system(size: 32))
                            .foregroundStyle(Color(red: 1.0, green: 0.8, blue: 0.0))
                    }
                }
            }
            
            Button {
                // Submit rating
            } label: {
                Text("Submit")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .padding()
        .navigationTitle("Rate App")
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

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(message.isUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        message.isUser ?
                            AnyShapeStyle(Theme.primary.gradient) :
                            AnyShapeStyle(Color(uiColor: .secondarySystemGroupedBackground))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            
            if !message.isUser { Spacer(minLength: 40) }
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

// MARK: - Previews

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
