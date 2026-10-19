import SwiftUI

// MARK: - Sports Tracking View

struct SportsTrackingView: View {
    @StateObject private var store = SportsStore.shared
    @State private var showingAddActivity = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Stats Summary
                StatsRow()
                
                // Activities List
                if store.activities.isEmpty {
                    EmptyStateView(
                        icon: "figure.run",
                        title: "No activities yet",
                        subtitle: "Start tracking your runs, swims, and rides",
                        color: .orange
                    )
                    .padding(.top, 60)
                } else {
                    VStack(spacing: 12) {
                        ForEach(store.activities) { activity in
                            ActivityCard(activity: activity)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Theme.pageBackground)
        .navigationTitle("Sports Tracking")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddActivity = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Theme.primary)
                }
            }
        }
        .sheet(isPresented: $showingAddActivity) {
            AddActivitySheet()
        }
    }
    
    // MARK: - Stats Row
    @ViewBuilder
    private func StatsRow() -> some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Distance",
                value: store.totalDistanceKm > 0 
                    ? String(format: "%.1f", store.totalDistanceKm)
                    : "—",
                unit: "km",
                icon: "location.fill",
                color: .blue
            )
            
            StatCard(
                title: "Duration",
                value: store.totalDurationMin > 0
                    ? "\(store.totalDurationMin)"
                    : "—",
                unit: "min",
                icon: "clock.fill",
                color: .green
            )
            
            StatCard(
                title: "Calories",
                value: store.totalCalories > 0
                    ? "\(store.totalCalories)"
                    : "—",
                unit: "kcal",
                icon: "flame.fill",
                color: .orange
            )
        }
    }
}

// MARK: - Stat Card

private struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            
            Text(title)
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Activity Card

struct ActivityCard: View {
    let activity: SportActivity
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(activity.type.color)
                    .frame(width: 50, height: 50)
                
                Image(systemName: activity.type.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.type.rawValue)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                
                HStack(spacing: 12) {
                    if activity.distance > 0 {
                        Label(activity.formattedDistance, systemImage: "location.fill")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Label(activity.formattedDuration, systemImage: "clock.fill")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            // Date
            VStack(alignment: .trailing, spacing: 4) {
                Text(activity.date, style: .date)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                
                if activity.calories > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                        Text("\(activity.calories)")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
        .padding()
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Add Activity Sheet

struct AddActivitySheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = SportsStore.shared
    
    @State private var selectedType: SportType = .running
    @State private var date = Date()
    @State private var duration = 30
    @State private var distance: Double = 0
    @State private var calories = 0
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Activity Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(SportType.allCases) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Details") {
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                    
                    HStack {
                        Text("Duration")
                        Spacer()
                        TextField("Minutes", value: $duration, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                        Text("min")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Distance")
                        Spacer()
                        TextField("Kilometers", value: $distance, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                        Text("km")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Calories")
                        Spacer()
                        TextField("kcal", value: $calories, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                        Text("kcal")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }.appPageTheme()
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let activity = SportActivity(
                            type: selectedType,
                            date: date,
                            duration: duration,
                            distance: distance,
                            calories: calories,
                            notes: notes
                        )
                        store.add(activity)
                        dismiss()
                    }
                }
            }
        }.appPageTheme()
    }
}

#Preview {
    NavigationStack {
        SportsTrackingView()
    }.appPageTheme()
}
