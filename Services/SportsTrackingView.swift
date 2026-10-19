import SwiftUI
import Combine

// MARK: - Sports Tracking View
// 🔥 UPDATED VERSION - Aug 27, 2026 - With 10+ New Features

struct SportsTrackingView: View {
    @StateObject private var store = SportsTrackingStore.shared
    @State private var showingAddActivity = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Weekly Summary
                WeeklySportsSummary()
                
                // Quick Sport Actions
                QuickSportActions()
                
                // Sport Type Breakdown
                SportTypeBreakdown()
                
                // Monthly Progress Chart
                MonthlyProgressChart()
                
                // Recent Personal Records
                RecentPersonalRecords()
                
                // Active Challenges
                ActiveChallengesCard()
                
                // Training Zones
                TrainingZonesCard()
                
                // Weather & Conditions
                WeatherConditionsCard()
                
                // Equipment Tracker
                EquipmentTrackerCard()
                
                // Social Feed
                SocialFeedCard()
                
                // Upcoming Events
                UpcomingEventsCard()
                
                // Activities List
                ActivitiesListSection()
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Sports Tracking")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddActivity = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.orange)
                }
            }
        }
        .sheet(isPresented: $showingAddActivity) {
            AddSportActivitySheet()
        }
    }
    
    // MARK: - Activities List Section
    @ViewBuilder
    private func ActivitiesListSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activities")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.horizontal, 4)
            
            if store.activities.isEmpty {
                EmptyStateView(
                    icon: "figure.run",
                    title: "No activities logged",
                    subtitle: "Start tracking your sports activities",
                    color: .orange
                )
                .padding(.vertical, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(store.activities) { activity in
                        SportActivityCard(activity: activity)
                    }
                }
            }
        }
    }
    
    // MARK: - Weekly Summary
    @ViewBuilder
    private func WeeklySportsSummary() -> some View {
        HStack(spacing: 12) {
            SportsStatCard(
                title: "Activities",
                value: "\(store.weeklyActivities)",
                icon: "figure.run",
                color: .orange
            )
            
            SportsStatCard(
                title: "Distance",
                value: String(format: "%.1f km", store.totalDistance),
                icon: "location.fill",
                color: .blue
            )
            
            SportsStatCard(
                title: "Time",
                value: store.formattedTotalDuration,
                icon: "clock.fill",
                color: .purple
            )
        }
    }
}

// MARK: - Sport Activity Card

struct SportActivityCard: View {
    let activity: SportActivity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
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
                            Label(String(format: "%.2f km", activity.distance), systemImage: "location.fill")
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
                Text(activity.date, style: .date)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            // Stats
            if activity.avgPace > 0 || activity.calories > 0 {
                Divider()
                
                HStack(spacing: 20) {
                    if activity.avgPace > 0 {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Avg Pace")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundStyle(.secondary)
                            Text(activity.formattedPace)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        }
                    }
                    
                    if activity.calories > 0 {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Calories")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundStyle(.secondary)
                            Text("\(activity.calories) kcal")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Add Sport Activity Sheet

struct AddSportActivitySheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = SportsTrackingStore.shared
    
    @State private var type: SportType = .running
    @State private var date = Date()
    @State private var durationHours = 0
    @State private var durationMinutes = 30
    @State private var distanceStr = ""
    @State private var caloriesStr = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Activity") {
                    Picker("Type", selection: $type) {
                        ForEach(SportType.allCases) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section("Duration") {
                    HStack {
                        Picker("Hours", selection: $durationHours) {
                            ForEach(0..<24) { hour in
                                Text("\(hour) h").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        
                        Picker("Minutes", selection: $durationMinutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute) m").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 100)
                }
                
                Section("Details") {
                    HStack {
                        Text("Distance (km)")
                        Spacer()
                        TextField("Optional", text: $distanceStr)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    
                    HStack {
                        Text("Calories")
                        Spacer()
                        TextField("Optional", text: $caloriesStr)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Log Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let totalMinutes = durationHours * 60 + durationMinutes
                        let distance = Double(distanceStr.replacingOccurrences(of: ",", with: ".")) ?? 0
                        let calories = Int(caloriesStr) ?? 0
                        
                        let activity = SportActivity(
                            type: type,
                            date: date,
                            duration: totalMinutes,
                            distance: distance,
                            calories: calories,
                            notes: notes
                        )
                        store.add(activity)
                        dismiss()
                    }
                    .disabled(durationHours == 0 && durationMinutes == 0)
                }
            }
        }
    }
}

// MARK: - Supporting Types

struct SportActivity: Identifiable, Codable {
    let id: UUID
    let type: SportType
    let date: Date
    let duration: Int // minutes
    let distance: Double // km
    let calories: Int
    let notes: String
    
    init(id: UUID = UUID(), type: SportType, date: Date, duration: Int, distance: Double, calories: Int, notes: String) {
        self.id = id
        self.type = type
        self.date = date
        self.duration = duration
        self.distance = distance
        self.calories = calories
        self.notes = notes
    }
    
    var formattedDuration: String {
        let hours = duration / 60
        let minutes = duration % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
    
    var avgPace: Double {
        guard distance > 0, duration > 0 else { return 0 }
        return Double(duration) / distance // min/km
    }
    
    var formattedPace: String {
        guard avgPace > 0 else { return "N/A" }
        let minutes = Int(avgPace)
        let seconds = Int((avgPace - Double(minutes)) * 60)
        return "\(minutes):\(String(format: "%02d", seconds))/km"
    }
}

enum SportType: String, CaseIterable, Identifiable, Codable {
    case running = "Running"
    case cycling = "Cycling"
    case swimming = "Swimming"
    case walking = "Walking"
    case hiking = "Hiking"
    case yoga = "Yoga"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        case .walking: return "figure.walk"
        case .hiking: return "figure.hiking"
        case .yoga: return "figure.mind.and.body"
        case .other: return "sportscourt.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .running: return .orange
        case .cycling: return .blue
        case .swimming: return .cyan
        case .walking: return .green
        case .hiking: return .brown
        case .yoga: return .purple
        case .other: return .gray
        }
    }
}

// MARK: - Sports Tracking Store

final class SportsTrackingStore: ObservableObject {
    static let shared = SportsTrackingStore()
    
    @Published var activities: [SportActivity] = []
    
    var weeklyActivities: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return activities.filter { $0.date >= weekAgo }.count
    }
    
    var totalDistance: Double {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return activities.filter { $0.date >= weekAgo }.reduce(0) { $0 + $1.distance }
    }
    
    var totalDuration: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return activities.filter { $0.date >= weekAgo }.reduce(0) { $0 + $1.duration }
    }
    
    var formattedTotalDuration: String {
        let hours = totalDuration / 60
        let minutes = totalDuration % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
    
    private init() {
        loadSampleData()
    }
    
    func add(_ activity: SportActivity) {
        activities.insert(activity, at: 0)
        save()
    }
    
    private func save() {
        // Save to storage
    }
    
    private func loadSampleData() {
        activities = [
            SportActivity(
                type: .running,
                date: Date(),
                duration: 45,
                distance: 7.5,
                calories: 450,
                notes: "Morning run, felt great!"
            ),
            SportActivity(
                type: .cycling,
                date: Date().addingTimeInterval(-86400),
                duration: 90,
                distance: 25.0,
                calories: 650,
                notes: "Long ride on the bike trail"
            )
        ]
    }
}

// MARK: - Sports Stat Card (Reusable)

private struct SportsStatCard: View {
    let title: String
    let value: String
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
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - New Sports Tracking Features

struct QuickSportActions: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Start")
                .font(.system(size: 17, weight: .bold, design: .rounded))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                QuickSportButton(icon: "figure.run", title: "Run", color: .orange)
                QuickSportButton(icon: "figure.outdoor.cycle", title: "Ride", color: .blue)
                QuickSportButton(icon: "figure.pool.swim", title: "Swim", color: .cyan)
                QuickSportButton(icon: "figure.yoga", title: "Yoga", color: .purple)
                QuickSportButton(icon: "dumbbell.fill", title: "Gym", color: .red)
                QuickSportButton(icon: "figure.walk", title: "Walk", color: .green)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct QuickSportButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(uiColor: .tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct SportTypeBreakdown: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundStyle(.orange)
                Text("Activity Breakdown")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("This Month")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 10) {
                BreakdownRow(sport: "Running", percentage: 45, color: .orange, distance: "85.2 km")
                BreakdownRow(sport: "Cycling", percentage: 30, color: .blue, distance: "142.5 km")
                BreakdownRow(sport: "Swimming", percentage: 15, color: .cyan, distance: "12.8 km")
                BreakdownRow(sport: "Gym", percentage: 10, color: .red, distance: "8 sessions")
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct BreakdownRow: View {
    let sport: String
    let percentage: Int
    let color: Color
    let distance: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(sport)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                Spacer()
                Text(distance)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
                Text("\(percentage)%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
                    .frame(width: 45, alignment: .trailing)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geo.size.width * CGFloat(percentage) / 100)
                }
            }
            .frame(height: 6)
        }
    }
}

struct MonthlyProgressChart: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(.blue)
                Text("Monthly Progress")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("August 2026")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 20) {
                ProgressStat(value: "245.8", unit: "km", label: "Total Distance", color: .blue)
                ProgressStat(value: "18:32", unit: "hrs", label: "Total Time", color: .purple)
                ProgressStat(value: "3,240", unit: "kcal", label: "Burned", color: .orange)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ProgressStat: View {
    let value: String
    let unit: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
                Text(unit)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct RecentPersonalRecords: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(Color(red: 1.0, green: 0.8, blue: 0.0))
                Text("Personal Records")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Button("View All") {}
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.orange)
            }
            
            VStack(spacing: 8) {
                PRRow(title: "Fastest 5K", value: "22:45", date: "Aug 20", icon: "figure.run", color: .orange)
                PRRow(title: "Longest Ride", value: "85.2 km", date: "Aug 15", icon: "figure.outdoor.cycle", color: .blue)
                PRRow(title: "Most Calories", value: "1,240 kcal", date: "Aug 12", icon: "flame.fill", color: .red)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct PRRow: View {
    let title: String
    let value: String
    let date: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                Text(date)
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .padding(.vertical, 6)
    }
}

struct ActiveChallengesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "target")
                    .foregroundStyle(.green)
                Text("Active Challenges")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
            }
            
            VStack(spacing: 10) {
                ChallengeRow(title: "August Running Challenge", current: 65, goal: 100, unit: "km", color: .orange)
                ChallengeRow(title: "Weekly Workout Streak", current: 4, goal: 7, unit: "days", color: .blue)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ChallengeRow: View {
    let title: String
    let current: Int
    let goal: Int
    let unit: String
    let color: Color
    
    var progress: Double {
        Double(current) / Double(goal)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                Spacer()
                Text("\(current)/\(goal) \(unit)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(color)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 8)
        }
    }
}

struct TrainingZonesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .foregroundStyle(.pink)
                Text("Heart Rate Zones")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Text("Last Workout")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 8) {
                ZoneBar(zone: "Zone 5 (Max)", time: "2:15", color: .red, percentage: 5)
                ZoneBar(zone: "Zone 4 (Hard)", time: "8:45", color: .orange, percentage: 18)
                ZoneBar(zone: "Zone 3 (Moderate)", time: "22:30", color: .yellow, percentage: 47)
                ZoneBar(zone: "Zone 2 (Easy)", time: "12:10", color: .green, percentage: 25)
                ZoneBar(zone: "Zone 1 (Recovery)", time: "2:20", color: .blue, percentage: 5)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ZoneBar: View {
    let zone: String
    let time: String
    let color: Color
    let percentage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text(zone)
                .font(.system(size: 12, design: .rounded))
                .frame(width: 120, alignment: .leading)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                    
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: geo.size.width * CGFloat(percentage) / 100)
                }
            }
            .frame(height: 6)
            
            Text(time)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(width: 50, alignment: .trailing)
        }
    }
}

struct WeatherConditionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cloud.sun.fill")
                    .foregroundStyle(.cyan)
                Text("Weather Conditions")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
            }
            
            HStack(spacing: 20) {
                WeatherStat(icon: "thermometer.medium", value: "24°C", label: "Temperature")
                WeatherStat(icon: "humidity.fill", value: "65%", label: "Humidity")
                WeatherStat(icon: "wind", value: "12 km/h", label: "Wind")
            }
            
            Text("Perfect conditions for outdoor running! 🏃‍♂️")
                .font(.system(size: 13, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct WeatherStat: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.cyan)
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 10, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct EquipmentTrackerCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shoeprints.fill")
                    .foregroundStyle(.purple)
                Text("Equipment")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Button("Manage") {}
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.orange)
            }
            
            VStack(spacing: 8) {
                EquipmentRow(name: "Nike Pegasus 40", type: "Running Shoes", km: 245, maxKm: 800, color: .orange)
                EquipmentRow(name: "Trek Domane SL6", type: "Road Bike", km: 1240, maxKm: 5000, color: .blue)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct EquipmentRow: View {
    let name: String
    let type: String
    let km: Int
    let maxKm: Int
    let color: Color
    
    var progress: Double {
        Double(km) / Double(maxKm)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                    Text(type)
                        .font(.system(size: 11, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(km) / \(maxKm) km")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(color)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                    
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 6)
        }
    }
}

struct SocialFeedCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundStyle(.green)
                Text("Friends Activity")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                Button("View All") {}
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.orange)
            }
            
            VStack(spacing: 10) {
                FriendActivityRow(name: "Sarah", activity: "completed a 10K run", time: "2h ago", icon: "figure.run", color: .orange)
                FriendActivityRow(name: "Mike", activity: "logged a 50km bike ride", time: "5h ago", icon: "figure.outdoor.cycle", color: .blue)
                FriendActivityRow(name: "Emma", activity: "achieved new PR in 5K", time: "1d ago", icon: "trophy.fill", color: Color(red: 1.0, green: 0.8, blue: 0.0))
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct FriendActivityRow: View {
    let name: String
    let activity: String
    let time: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(name) \(activity)")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                Text(time)
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "hand.thumbsup")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct UpcomingEventsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(.red)
                Text("Upcoming Events")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
            }
            
            VStack(spacing: 10) {
                EventRow(name: "City Marathon 2026", date: "Sep 15", distance: "42.2 km", color: .red)
                EventRow(name: "Charity 10K Run", date: "Aug 30", distance: "10 km", color: .orange)
                EventRow(name: "Triathlon Sprint", date: "Oct 5", distance: "Mixed", color: .blue)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct EventRow: View {
    let name: String
    let date: String
    let distance: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                Text(distance)
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Image(systemName: "calendar")
                    .font(.system(size: 12))
                    .foregroundStyle(color)
                Text(date)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(color)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        SportsTrackingView()
    }
}
