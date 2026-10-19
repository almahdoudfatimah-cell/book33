//
//  ContentView.swift
//  Appwatch Watch App
//
//  Created by Fatimah on 24/08/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab - TESTING VERSION
            SimpleHomeView()
                .tag(0)
            
            // Today Tab
            WatchTodayView()
                .tag(1)
            
            // Plan Tab
            WatchPlanView()
                .tag(2)
            
            // More Tab
            WatchMoreView()
                .tag(3)
        }
        .tabViewStyle(.page)
    }
}

// MARK: - Simple Home View (Testing)
struct SimpleHomeView: View {
    @State private var showSheet = false
    @State private var buttonTapCount = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section("TAP COUNT") {
                    Text("Button tapped \(buttonTapCount) times")
                        .font(.headline)
                }
                
                Section("NAVIGATION TEST") {
                    NavigationLink(destination: Text("Account Works!")) {
                        Label("Account", systemImage: "person.circle.fill")
                    }
                    
                    NavigationLink(destination: Text("Settings Works!")) {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .navigationTitle("Home Test")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        buttonTapCount += 1
                        showSheet = true
                        print("🟢 TOOLBAR BUTTON TAPPED! Count: \(buttonTapCount)")
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.orange)
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                VStack(spacing: 20) {
                    Text("✅ Sheet Working!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Button has been tapped \(buttonTapCount) times")
                        .foregroundColor(.secondary)
                    
                    Button("Close") {
                        showSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }
}

// MARK: - Watch Today View
struct WatchTodayView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Today")
                        .font(.title)
                    Text("Coming Soon")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Today")
        }
    }
}

// MARK: - Watch Plan View
struct WatchPlanView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Plan")
                        .font(.title)
                    Text("Coming Soon")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Plan")
        }
    }
}

// MARK: - Watch More View
struct WatchMoreView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: Text("Settings")) {
                    Label("Settings", systemImage: "gear")
                }
                NavigationLink(destination: Text("About")) {
                    Label("About", systemImage: "info.circle")
                }
            }
            .navigationTitle("More")
        }
    }
}

// MARK: - Home Tab View
struct HomeTabView: View {
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header with Add Button
                    HStack {
                        Text("Home")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Spacer()
                        
                        Button {
                            print("🔵 Add button tapped!")
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Theme.primary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Quick Access Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("QUICK ACCESS")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            HomeNavigationRow(
                                icon: "person.circle.fill",
                                title: "Account",
                                subtitle: "Profile & settings",
                                color: Color(red: 1.00, green: 0.58, blue: 0.05),
                                destination: AnyView(SettingsView())
                            )
                            
                            HomeNavigationRow(
                                icon: "calendar.circle.fill",
                                title: "Today",
                                subtitle: "Today's activities",
                                color: .green,
                                destination: AnyView(TodayView())
                            )
                            
                            HomeNavigationRow(
                                icon: "calendar.badge.clock",
                                title: "Plan",
                                subtitle: "Your training plan",
                                color: .blue,
                                destination: AnyView(PlanView())
                            )
                            
                            HomeNavigationRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Progress",
                                subtitle: "Track achievements",
                                color: .purple,
                                destination: AnyView(ProgressTrackingView())
                            )
                        }
                    }
                    
                    // Training Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TRAINING")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            HomeNavigationRow(
                                icon: "figure.run",
                                title: "Sports Tracking",
                                subtitle: "Log activities",
                                color: .orange,
                                destination: AnyView(ComingSoonView(title: "Sports Tracking"))
                            )
                            
                            HomeNavigationRow(
                                icon: "dumbbell.fill",
                                title: "Training Log",
                                subtitle: "Workout history",
                                color: .red,
                                destination: AnyView(ComingSoonView(title: "Training Log"))
                            )
                            
                            HomeNavigationRow(
                                icon: "message.fill",
                                title: "AI Coach",
                                subtitle: "Get advice",
                                color: Color(red: 0.3, green: 0.7, blue: 0.5),
                                destination: AnyView(CoachView())
                            )
                        }
                    }
                    
                    // Health & Wellness Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("HEALTH & WELLNESS")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            HomeNavigationRow(
                                icon: "fork.knife",
                                title: "Nutrition",
                                subtitle: "Meals & macros",
                                color: .green,
                                destination: AnyView(ComingSoonView(title: "Nutrition"))
                            )
                            
                            HomeNavigationRow(
                                icon: "bed.double.fill",
                                title: "Sleep Tracker",
                                subtitle: "Monitor sleep",
                                color: Color(red: 0.4, green: 0.3, blue: 0.8),
                                destination: AnyView(ComingSoonView(title: "Sleep Tracker"))
                            )
                            
                            HomeNavigationRow(
                                icon: "heart.text.square.fill",
                                title: "Body Metrics",
                                subtitle: "Weight, HR & more",
                                color: .pink,
                                destination: AnyView(ComingSoonView(title: "Body Metrics"))
                            )
                        }
                    }
                    
                    // More Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("MORE")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            HomeNavigationRow(
                                icon: "list.bullet.rectangle.fill",
                                title: "All Features",
                                subtitle: "Browse all",
                                color: .cyan,
                                destination: AnyView(AllFeaturesView())
                            )
                            
                            HomeNavigationRow(
                                icon: "gear",
                                title: "Settings",
                                subtitle: "Preferences",
                                color: .gray,
                                destination: AnyView(SettingsView())
                            )
                        }
                    }
                }
                .padding(.bottom, 16)
            }
            .sheet(isPresented: $showingAddSheet) {
                AddItemSheet()
            }
        }
    }
}

// MARK: - Add Item Sheet
struct AddItemSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        print("Add Workout tapped")
                        dismiss()
                    } label: {
                        Label("Add Workout", systemImage: "figure.run")
                    }
                    
                    Button {
                        print("Add Meal tapped")
                        dismiss()
                    } label: {
                        Label("Add Meal", systemImage: "fork.knife")
                    }
                    
                    Button {
                        print("Add Note tapped")
                        dismiss()
                    } label: {
                        Label("Add Note", systemImage: "note.text")
                    }
                }
            }
            .navigationTitle("Add New")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Home Navigation Row (watchOS compatible)
struct HomeNavigationRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 12) {
                // Icon with colored background
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(color)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Plan View
private struct PlanView: View {
    var body: some View {
        List {
            Section("THIS WEEK") {
                PlanActivityRow(day: "Today", activity: "Morning Run", duration: "30 min", icon: "figure.run", color: .orange, completed: true)
                PlanActivityRow(day: "Today", activity: "Strength Training", duration: "45 min", icon: "dumbbell.fill", color: .red, completed: false)
                PlanActivityRow(day: "Tomorrow", activity: "Cycling", duration: "60 min", icon: "figure.outdoor.cycle", color: .blue, completed: false)
                PlanActivityRow(day: "Wed", activity: "Yoga", duration: "30 min", icon: "figure.yoga", color: .purple, completed: false)
            }
            
            Section("UPCOMING") {
                PlanActivityRow(day: "Thu", activity: "Swimming", duration: "45 min", icon: "figure.pool.swim", color: .cyan, completed: false)
                PlanActivityRow(day: "Fri", activity: "Long Run", duration: "90 min", icon: "figure.run", color: .orange, completed: false)
                PlanActivityRow(day: "Sat", activity: "Rest Day", duration: "—", icon: "bed.double.fill", color: .green, completed: false)
            }
        }
        .navigationTitle("Plan")
    }
}

struct PlanActivityRow: View {
    let day: String
    let activity: String
    let duration: String
    let icon: String
    let color: Color
    let completed: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: completed ? "checkmark.circle.fill" : icon)
                .font(.system(size: 16))
                .foregroundStyle(completed ? .green : color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(day)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                    if completed {
                        Text("✓")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.green)
                    }
                }
                
                Text(activity)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .strikethrough(completed)
                    .opacity(completed ? 0.6 : 1.0)
            }
            
            Spacer()
            
            Text(duration)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Settings View
public struct SettingsView: View {
    public init() {}
    
    public var body: some View {
        List {
            Section("ACCOUNT") {
                Label("Profile", systemImage: "person.circle.fill")
                Label("Preferences", systemImage: "slider.horizontal.3")
                Label("Notifications", systemImage: "bell.fill")
            }
            
            Section("APP") {
                Label("About", systemImage: "info.circle")
                Label("Privacy", systemImage: "lock.shield")
                Label("Help", systemImage: "questionmark.circle")
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - All Features View
public struct AllFeaturesView: View {
    public init() {}
    
    public var body: some View {
        List {
            Section("TRAINING") {
                Label("Sports Tracking", systemImage: "figure.run")
                Label("Training Log", systemImage: "dumbbell.fill")
                Label("Workout Plans", systemImage: "list.clipboard.fill")
                Label("Exercise Library", systemImage: "film.fill")
            }
            
            Section("HEALTH") {
                Label("Nutrition", systemImage: "fork.knife")
                Label("Sleep Tracker", systemImage: "bed.double.fill")
                Label("Body Metrics", systemImage: "heart.text.square.fill")
                Label("Hydration", systemImage: "drop.fill")
            }
            
            Section("ANALYTICS") {
                Label("Progress Charts", systemImage: "chart.line.uptrend.xyaxis")
                Label("Performance", systemImage: "chart.xyaxis.line")
                Label("Personal Records", systemImage: "trophy.fill")
                Label("Activity Rings", systemImage: "figure.walk.motion")
            }
        }
        .navigationTitle("All Features")
    }
}

// MARK: - Progress Tracking View
struct ProgressTrackingView: View {
    var body: some View {
        List {
            Section("OVERVIEW") {
                VStack(spacing: 12) {
                    ProgressStatRow(icon: "chart.line.uptrend.xyaxis", label: "This Week", value: "+12%", color: .purple)
                    ProgressStatRow(icon: "flame.fill", label: "Total Workouts", value: "47", color: .orange)
                    ProgressStatRow(icon: "trophy.fill", label: "Achievements", value: "15", color: .yellow)
                }
            }
            
            Section("RECENT IMPROVEMENTS") {
                ProgressItemRow(title: "5K Time", previous: "28:30", current: "26:45", improvement: "-6.1%", color: .green)
                ProgressItemRow(title: "Max Distance", previous: "15 km", current: "21 km", improvement: "+40%", color: .blue)
                ProgressItemRow(title: "Avg Pace", previous: "5:42", current: "5:21", improvement: "+6.5%", color: .purple)
            }
            
            Section("GOALS") {
                ProgressGoalRow(title: "Weekly Distance", current: 28, target: 40, unit: "km", color: .blue)
                ProgressGoalRow(title: "Workouts/Week", current: 4, target: 5, unit: "times", color: .orange)
            }
        }
        .navigationTitle("Progress")
    }
}

struct ProgressStatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
                .frame(width: 24)
            
            Text(label)
                .font(.system(size: 14, design: .rounded))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
    }
}

struct ProgressItemRow: View {
    let title: String
    let previous: String
    let current: String
    let improvement: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
            
            HStack {
                Text(previous)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(.secondary)
                    .strikethrough()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                
                Text(current)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(color)
                
                Text(improvement)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.green.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
    }
}

struct ProgressGoalRow: View {
    let title: String
    let current: Int
    let target: Int
    let unit: String
    let color: Color
    
    var progress: Double {
        Double(current) / Double(target)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                Spacer()
                Text("\(current)/\(target) \(unit)")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * min(progress, 1.0), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

// MARK: - Coach View (Watch)
struct CoachView: View {
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "message.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color(red: 0.3, green: 0.7, blue: 0.5))
            
            Text("AI Coach")
                .font(.headline)
            
            Text("Get personalized advice and guidance for your training")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                showAlert = true
            } label: {
                Label("Start Conversation", systemImage: "sparkles")
                    .font(.footnote)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.3, green: 0.7, blue: 0.5))
        }
        .navigationTitle("AI Coach")
        .alert("Coming Soon", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Full AI Coach features are coming to Apple Watch soon!")
        }
    }
}

// MARK: - Coming Soon View
struct ComingSoonView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(Theme.primary)
            
            Text(title)
                .font(.headline)
            
            Text("Coming Soon")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .navigationTitle(title)
    }
}

#Preview {
    ContentView()
}
