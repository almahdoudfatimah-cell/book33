//
//  HomeView.swift
//  RaceTrian
//
//  Home page with quick access to all main features
//

#if !os(watchOS)

import SwiftUI

struct HomeView: View {
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                // Quick Access Section
                Section("QUICK ACCESS") {
                    NavigationLink(destination: Text("Account View")) {
                        HomeRowContent(
                            icon: "person.circle.fill",
                            title: "Account",
                            subtitle: "Profile & settings",
                            color: .orange
                        )
                    }
                    
                    NavigationLink(destination: Text("Today View - Coming Soon")) {
                        HomeRowContent(
                            icon: "calendar.circle.fill",
                            title: "Today",
                            subtitle: "Today's activities",
                            color: .green
                        )
                    }
                    
                    NavigationLink(destination: Text("Plan View - Coming Soon")) {
                        HomeRowContent(
                            icon: "calendar.badge.clock",
                            title: "Plan",
                            subtitle: "Your training plan",
                            color: .blue
                        )
                    }
                    
                    NavigationLink(destination: Text("Progress View - Coming Soon")) {
                        HomeRowContent(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Progress",
                            subtitle: "Track achievements",
                            color: .purple
                        )
                    }
                }
                
                // Training Section
                Section("TRAINING") {
                    NavigationLink(destination: Text("Sports Tracking - Coming Soon")) {
                        HomeRowContent(
                            icon: "figure.run",
                            title: "Sports Tracking",
                            subtitle: "Log activities",
                            color: .orange
                        )
                    }
                    
                    NavigationLink(destination: Text("Training Log - Coming Soon")) {
                        HomeRowContent(
                            icon: "dumbbell.fill",
                            title: "Training Log",
                            subtitle: "Workout history",
                            color: .red
                        )
                    }
                    
                    NavigationLink(destination: Text("AI Coach - Coming Soon")) {
                        HomeRowContent(
                            icon: "message.fill",
                            title: "AI Coach",
                            subtitle: "Get advice",
                            color: Color(red: 0.3, green: 0.7, blue: 0.5)
                        )
                    }
                }
                
                // Health & Wellness Section
                Section("HEALTH & WELLNESS") {
                    NavigationLink(destination: Text("Nutrition - Coming Soon")) {
                        HomeRowContent(
                            icon: "fork.knife",
                            title: "Nutrition",
                            subtitle: "Meals & macros",
                            color: .green
                        )
                    }
                    
                    NavigationLink(destination: Text("Sleep Tracker - Coming Soon")) {
                        HomeRowContent(
                            icon: "bed.double.fill",
                            title: "Sleep Tracker",
                            subtitle: "Monitor sleep",
                            color: Color(red: 0.4, green: 0.3, blue: 0.8)
                        )
                    }
                    
                    NavigationLink(destination: Text("Body Metrics - Coming Soon")) {
                        HomeRowContent(
                            icon: "heart.text.square.fill",
                            title: "Body Metrics",
                            subtitle: "Weight, HR & more",
                            color: .pink
                        )
                    }
                }
                
                // More Features
                Section("MORE") {
                    NavigationLink(destination: Text("All Features - Coming Soon")) {
                        HomeRowContent(
                            icon: "list.bullet.rectangle.fill",
                            title: "All Features",
                            subtitle: "Browse all",
                            color: .cyan
                        )
                    }
                    
                    NavigationLink(destination: Text("Settings - Coming Soon")) {
                        HomeRowContent(
                            icon: "gear",
                            title: "Settings",
                            subtitle: "Preferences",
                            color: .gray
                        )
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: Text("Account View")) {
                        Label("Account", systemImage: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.primary)
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // Search
                    Button {
                        // Search functionality
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundStyle(.secondary)
                            .labelStyle(.iconOnly)
                    }
                    
                    // Notifications
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
                    
                    // Add new item
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.primary)
                            .labelStyle(.iconOnly)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddItemSheet()
            }
        }
    }
}

// MARK: - Home Row Content
fileprivate struct HomeRowContent: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon with colored background
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Add Item Sheet
fileprivate struct AddItemSheet: View {
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
                    
                    Button {
                        print("Add Goal tapped")
                        dismiss()
                    } label: {
                        Label("Add Goal", systemImage: "target")
                    }
                }
            }
            .navigationTitle("Add New")
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

#Preview {
    HomeView()
}
#endif
