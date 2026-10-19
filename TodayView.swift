//
//  TodayView.swift
//  RaceTrian
//
//  Today's activities and overview with Liquid Glass design
//

import SwiftUI

public struct TodayView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedActivity: String? = nil
    @State private var showingAddActivity = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Top Navigation Bar (Backup - visible even if toolbar doesn't show)
                        HStack {
                            NavigationLink {
                                TodayPlaceholderProfileView()
                            } label: {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Theme.primary)
                            }
                            
                            Spacer()
                            
                            Text("Today")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            
                            Spacer()
                            
                            HStack(spacing: 16) {
                                NavigationLink {
                                    TodayPlaceholderPlanView()
                                } label: {
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 22))
                                        .foregroundStyle(.blue)
                                }
                                
                                NavigationLink {
                                    TodayPlaceholderFeaturesView()
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                        .font(.system(size: 22))
                                        .foregroundStyle(.secondary)
                                }
                                
                                Button {
                                    showingAddActivity = true
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(Theme.primary)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // Hero Stats Section with Liquid Glass
                        GlassEffectContainer(spacing: 12) {
                            HStack(spacing: 12) {
                                TodayStatCard(
                                    icon: "flame.fill",
                                    label: "Calories",
                                    value: "420",
                                    color: .orange
                                )
                                
                                TodayStatCard(
                                    icon: "figure.walk",
                                    label: "Steps",
                                    value: "8.2K",
                                    color: .green
                                )
                                
                                TodayStatCard(
                                    icon: "clock.fill",
                                    label: "Active",
                                    value: "45m",
                                    color: .blue
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Today's Schedule with Liquid Glass
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TODAY'S SCHEDULE")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 20)
                            
                            GlassEffectContainer(spacing: 8) {
                                VStack(spacing: 8) {
                                    TodayActivityRow(
                                        time: "08:00",
                                        activity: "Morning Run",
                                        duration: "30 min",
                                        icon: "figure.run",
                                        color: .orange,
                                        completed: true
                                    )
                                    
                                    TodayActivityRow(
                                        time: "12:00",
                                        activity: "Lunch Break",
                                        duration: "45 min",
                                        icon: "fork.knife",
                                        color: .green,
                                        completed: false
                                    )
                                    
                                    TodayActivityRow(
                                        time: "18:00",
                                        activity: "Strength Training",
                                        duration: "60 min",
                                        icon: "dumbbell.fill",
                                        color: .red,
                                        completed: false
                                    )
                                    
                                    TodayActivityRow(
                                        time: "21:00",
                                        activity: "Evening Stretch",
                                        duration: "15 min",
                                        icon: "figure.yoga",
                                        color: .purple,
                                        completed: false
                                    )
                                }
                                .padding(16)
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Quick Actions with Glass Buttons
                        VStack(alignment: .leading, spacing: 12) {
                            Text("QUICK ACTIONS")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 20)
                            
                            GlassEffectContainer(spacing: 12) {
                                HStack(spacing: 12) {
                                    TodayQuickActionButton(
                                        icon: "plus.circle.fill",
                                        title: "Log Workout",
                                        color: Theme.primary
                                    )
                                    
                                    TodayQuickActionButton(
                                        icon: "camera.fill",
                                        title: "Scan Meal",
                                        color: .green
                                    )
                                    
                                    TodayQuickActionButton(
                                        icon: "drop.fill",
                                        title: "Log Water",
                                        color: .cyan
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Weekly Progress with Liquid Glass
                        VStack(alignment: .leading, spacing: 12) {
                            Text("THIS WEEK")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 20)
                            
                            WeeklyProgressCard()
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .background(Theme.backgroundGradient(for: colorScheme).ignoresSafeArea())
                
                // Custom Bottom Toolbar (Always Visible)
                HStack(spacing: 0) {
                    // Profile Button
                    NavigationLink {
                        TodayPlaceholderProfileView()
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 24))
                            Text("Profile")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(Theme.primary)
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Plan Button
                    NavigationLink {
                        TodayPlaceholderPlanView()
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 24))
                            Text("Plan")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Add Button (Center - Prominent)
                    Button {
                        showingAddActivity = true
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                            Text("Add")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(Theme.primary)
                        .frame(maxWidth: .infinity)
                    }
                    
                    // More Button
                    NavigationLink {
                        TodayPlaceholderFeaturesView()
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 24))
                            Text("More")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        TodayPlaceholderProfileView()
                    } label: {
                        Label("Profile", systemImage: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.primary)
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // Search button
                    Button {
                        // Search functionality
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundStyle(.secondary)
                            .labelStyle(.iconOnly)
                    }
                    
                    // Notifications button
                    Button {
                        // Notifications
                    } label: {
                        Label("Notifications", systemImage: "bell.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.blue)
                            .labelStyle(.iconOnly)
                    }
                    .overlay(alignment: .topTrailing) {
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 4, y: -4)
                    }
                    
                    // Calendar/Plan button
                    NavigationLink {
                        TodayPlaceholderPlanView()
                    } label: {
                        Label("Plan", systemImage: "calendar.badge.clock")
                            .font(.system(size: 20))
                            .foregroundStyle(.purple)
                            .labelStyle(.iconOnly)
                    }
                    
                    // Add button
                    Button {
                        showingAddActivity = true
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.primary)
                            .labelStyle(.iconOnly)
                    }
                }
            }
            .sheet(isPresented: $showingAddActivity) {
                TodayQuickAddSheet()
            }
        }
    }
    
    // MARK: - Today Quick Add Sheet
    struct TodayQuickAddSheet: View {
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            NavigationStack {
                List {
                    Section("QUICK LOG") {
                        Button {
                            // Log workout
                            dismiss()
                        } label: {
                            Label("Log Workout", systemImage: "figure.run")
                                .foregroundStyle(.orange)
                        }
                        
                        Button {
                            // Log meal
                            dismiss()
                        } label: {
                            Label("Log Meal", systemImage: "fork.knife")
                                .foregroundStyle(.green)
                        }
                        
                        Button {
                            // Log water
                            dismiss()
                        } label: {
                            Label("Log Water", systemImage: "drop.fill")
                                .foregroundStyle(.cyan)
                        }
                    }
                }
                .navigationTitle("Quick Add")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Today Stat Card with Liquid Glass
    struct TodayStatCard: View {
        let icon: String
        let label: String
        let value: String
        let color: Color
        
        var body: some View {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(color.gradient)
                
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .glassEffect(.regular.tint(color.opacity(0.1)), in: .rect(cornerRadius: 16))
        }
    }
    
    // MARK: - Today Activity Row
    struct TodayActivityRow: View {
        let time: String
        let activity: String
        let duration: String
        let icon: String
        let color: Color
        let completed: Bool
        
        var body: some View {
            HStack(spacing: 14) {
                // Time
                Text(time)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(width: 50, alignment: .leading)
                
                // Icon with glass effect
                ZStack {
                    Circle()
                        .fill(completed ? Color.green.opacity(0.2) : color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: completed ? "checkmark" : icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(completed ? .green : color)
                }
                
                // Activity details
                VStack(alignment: .leading, spacing: 3) {
                    Text(activity)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                        .strikethrough(completed, color: .secondary)
                    
                    Text(duration)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Chevron
                if !completed {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.tertiary)
                }
            }
            .opacity(completed ? 0.6 : 1.0)
        }
    }
    
    // MARK: - Quick Action Button with Glass Effect (Today-specific)
    struct TodayQuickActionButton: View {
        let icon: String
        let title: String
        let color: Color
        
        var body: some View {
            Button(action: {
                // Action here
            }) {
                VStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(color.gradient)
                    
                    Text(title)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Weekly Progress Card
    struct WeeklyProgressCard: View {
        let weekData = [
            ("M", 0.7, false),
            ("T", 0.9, false),
            ("W", 0.6, false),
            ("T", 0.8, false),
            ("F", 0.5, true),
            ("S", 0.0, false),
            ("S", 0.0, false)
        ]
        
        var body: some View {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Weekly Progress")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                        
                        Text("5 of 7 days completed")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("71%")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.primary)
                }
                
                // Week bars
                HStack(spacing: 12) {
                    ForEach(weekData.indices, id: \.self) { index in
                        VStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(weekData[index].2 ? Theme.primary : Color.secondary.opacity(0.3))
                                .frame(height: 80 * weekData[index].1)
                                .frame(maxHeight: 80, alignment: .bottom)
                            
                            Text(weekData[index].0)
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(weekData[index].2 ? Theme.primary : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(20)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
        }
    }
    
    // MARK: - Placeholder Views
    // These are temporary placeholders until the main view files are added to the target
    // TODO: Replace with actual ProfileView, PlanView, and AllFeaturesView once files are in target
    
    struct TodayPlaceholderProfileView: View {
        var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Theme.primary)
                
                Text("Profile View")
                    .font(.title.bold())
                
                Text("Add ProfileView.swift to your target to enable this feature")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .navigationTitle("Profile")
        }
    }
    
    struct TodayPlaceholderPlanView: View {
        var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Text("Plan View")
                    .font(.title.bold())
                
                Text("Add PlanView.swift to your target to enable this feature")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .navigationTitle("Plan")
        }
    }
    
    struct TodayPlaceholderFeaturesView: View {
        var body: some View {
            List {
                Section("TRAINING") {
                    Label("Sports Tracking", systemImage: "figure.run")
                    Label("Training Log", systemImage: "dumbbell.fill")
                    Label("Workout Plans", systemImage: "list.clipboard.fill")
                }
                
                Section("HEALTH") {
                    Label("Nutrition", systemImage: "fork.knife")
                    Label("Sleep Tracker", systemImage: "bed.double.fill")
                    Label("Body Metrics", systemImage: "heart.text.square.fill")
                }
                
                Section {
                    Text("Add SharedNavigationViews.swift to your target to enable full features")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("All Features")
        }
    }
}

// MARK: - Preview
#Preview {
    TodayView()
}
