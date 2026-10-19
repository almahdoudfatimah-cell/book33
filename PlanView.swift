//
//  PlanView.swift
//  RaceTrian
//
//  Training plan and schedule with Liquid Glass design
//

import SwiftUI

struct PlanView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedWeek: Int = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Week Selector with Liquid Glass
                    GlassEffectContainer(spacing: 8) {
                        HStack(spacing: 12) {
                            Button(action: { selectedWeek = max(0, selectedWeek - 1) }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Theme.primary)
                                    .frame(width: 44, height: 44)
                            }
                            .glassEffect(.regular.interactive(), in: .circle)
                            
                            VStack(spacing: 4) {
                                Text("Week \(selectedWeek + 1)")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(.primary)
                                
                                Text("Oct 8 - Oct 14")
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Button(action: { selectedWeek += 1 }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Theme.primary)
                                    .frame(width: 44, height: 44)
                            }
                            .glassEffect(.regular.interactive(), in: .circle)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                    .padding(.horizontal, 16)
                    
                    // This Week's Activities
                    VStack(alignment: .leading, spacing: 12) {
                        Text("THIS WEEK")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                        
                        GlassEffectContainer(spacing: 8) {
                            VStack(spacing: 8) {
                                PlanActivityRow(
                                    day: "Today",
                                    activity: "Morning Run",
                                    duration: "30 min",
                                    icon: "figure.run",
                                    color: .orange,
                                    completed: true
                                )
                                
                                PlanActivityRow(
                                    day: "Today",
                                    activity: "Strength Training",
                                    duration: "45 min",
                                    icon: "dumbbell.fill",
                                    color: .red,
                                    completed: false
                                )
                                
                                PlanActivityRow(
                                    day: "Tomorrow",
                                    activity: "Cycling",
                                    duration: "60 min",
                                    icon: "bicycle",
                                    color: .blue,
                                    completed: false
                                )
                                
                                PlanActivityRow(
                                    day: "Wed",
                                    activity: "Yoga Session",
                                    duration: "30 min",
                                    icon: "figure.yoga",
                                    color: .purple,
                                    completed: false
                                )
                            }
                            .padding(16)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Upcoming Activities
                    VStack(alignment: .leading, spacing: 12) {
                        Text("UPCOMING")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                        
                        GlassEffectContainer(spacing: 8) {
                            VStack(spacing: 8) {
                                PlanActivityRow(
                                    day: "Thu",
                                    activity: "Swimming",
                                    duration: "45 min",
                                    icon: "figure.pool.swim",
                                    color: .cyan,
                                    completed: false
                                )
                                
                                PlanActivityRow(
                                    day: "Fri",
                                    activity: "Long Run",
                                    duration: "90 min",
                                    icon: "figure.run",
                                    color: .orange,
                                    completed: false
                                )
                                
                                PlanActivityRow(
                                    day: "Sat",
                                    activity: "Rest Day",
                                    duration: "—",
                                    icon: "bed.double.fill",
                                    color: .green,
                                    completed: false
                                )
                            }
                            .padding(16)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Weekly Goals Card
                    WeeklyGoalsCard()
                        .padding(.horizontal, 16)
                }
                .padding(.vertical, 20)
            }
            .background(Theme.backgroundGradient(for: colorScheme).ignoresSafeArea())
            .navigationTitle("Plan")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            // Show weekly view
                        } label: {
                            Label("Weekly View", systemImage: "calendar")
                        }
                        
                        Button {
                            // Show monthly view
                        } label: {
                            Label("Monthly View", systemImage: "calendar.circle")
                        }
                        
                        Divider()
                        
                        Button {
                            // Filter activities
                        } label: {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    } label: {
                        Label("View Options", systemImage: "slider.horizontal.3")
                            .font(.system(size: 20))
                            .foregroundStyle(.secondary)
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // Calendar view toggle
                    Button {
                        // Toggle calendar view
                    } label: {
                        Label("Calendar", systemImage: "calendar")
                            .font(.system(size: 20))
                            .foregroundStyle(.purple)
                            .labelStyle(.iconOnly)
                    }
                    
                    // Share plan
                    Button {
                        // Share functionality
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundStyle(.blue)
                            .labelStyle(.iconOnly)
                    }
                    
                    // Add activity
                    Button {
                        // Add new activity
                    } label: {
                        Label("Add Activity", systemImage: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.primary)
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
    }
}

// MARK: - Plan Activity Row
struct PlanActivityRow: View {
    let day: String
    let activity: String
    let duration: String
    let icon: String
    let color: Color
    let completed: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            // Day label
            Text(day)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(width: 60, alignment: .leading)
            
            // Icon with status
            ZStack {
                Circle()
                    .fill(completed ? Color.green.opacity(0.2) : color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: completed ? "checkmark.circle.fill" : icon)
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
            
            // Status indicator
            if completed {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .opacity(completed ? 0.6 : 1.0)
    }
}

// MARK: - Weekly Goals Card
struct WeeklyGoalsCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Weekly Goals")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "target")
                    .font(.system(size: 20))
                    .foregroundStyle(Theme.primary)
            }
            
            VStack(spacing: 14) {
                GoalProgressRow(
                    icon: "figure.run",
                    title: "Running Distance",
                    current: 18.5,
                    goal: 25.0,
                    unit: "km",
                    color: .orange
                )
                
                GoalProgressRow(
                    icon: "dumbbell.fill",
                    title: "Strength Sessions",
                    current: 3,
                    goal: 4,
                    unit: "workouts",
                    color: .red
                )
                
                GoalProgressRow(
                    icon: "flame.fill",
                    title: "Calories Burned",
                    current: 2840,
                    goal: 3500,
                    unit: "kcal",
                    color: .orange
                )
            }
        }
        .padding(20)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

// MARK: - Goal Progress Row
struct GoalProgressRow: View {
    let icon: String
    let title: String
    let current: Double
    let goal: Double
    let unit: String
    let color: Color
    
    var progress: Double {
        min(current / goal, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(color)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text("\(Int(current))/\(Int(goal)) \(unit)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(color.gradient)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Preview
#Preview {
    PlanView()
}
