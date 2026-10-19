//
//  SharedNavigationViews.swift
//  RaceTrian
//
//  Shared navigation views used throughout the app
//

import SwiftUI

// MARK: - Settings View

public struct SettingsView: View {
    var body: some View {
        List {
            Section {
                NavigationLink {
                    ProfileSettingsView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.primary)
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Profile")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                            Text("Manage your account")
                                .font(.system(size: 13, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section("Preferences") {
                NavigationLink {
                    AppearanceSettingsView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "paintbrush.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.blue)
                            .frame(width: 32)
                        Text("Appearance")
                    }
                }
                
                NavigationLink {
                    PrivacySettingsView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.green)
                            .frame(width: 32)
                        Text("Privacy")
                    }
                }
            }
            
            Section("Support") {
                NavigationLink {
                    HelpCenterView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.purple)
                            .frame(width: 32)
                        Text("Help Center")
                    }
                }
                
                NavigationLink {
                    RateAppView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color(red: 1.0, green: 0.8, blue: 0.0))
                            .frame(width: 32)
                        Text("Rate App")
                    }
                }
            }
            
            Section {
                Button {
                    // Sign out action
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 20))
                            .foregroundStyle(.red)
                            .frame(width: 32)
                        Text("Sign Out")
                            .foregroundStyle(.red)
                    }
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("RaceTrian")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                        Text("Version 1.0.0")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundStyle(.tertiary)
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - All Features View

public struct AllFeaturesView: View {
    var body: some View {
        List {
            Section("TRAINING") {
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Sports Tracking", systemImage: "figure.run")
                }
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Training Log", systemImage: "dumbbell.fill")
                }
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Workout Plans", systemImage: "list.clipboard.fill")
                }
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Exercise Library", systemImage: "film.fill")
                }
            }
            
            Section("HEALTH") {
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Nutrition", systemImage: "fork.knife")
                }
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Sleep Tracker", systemImage: "bed.double.fill")
                }
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Body Metrics", systemImage: "heart.text.square.fill")
                }
            }
            
            Section("ANALYTICS") {
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Progress Charts", systemImage: "chart.line.uptrend.xyaxis")
                }
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Performance", systemImage: "chart.xyaxis.line")
                }
                NavigationLink(destination: Text("Coming Soon")) {
                    Label("Personal Records", systemImage: "trophy.fill")
                }
            }
        }
        .navigationTitle("All Features")
    }
}

// MARK: - Supporting Views (Stubs)
// These are referenced by SettingsView above

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

// MARK: - Preview

#Preview("Settings") {
    NavigationStack {
        SettingsView()
    }
}

#Preview("All Features") {
    NavigationStack {
        AllFeaturesView()
    }
}
