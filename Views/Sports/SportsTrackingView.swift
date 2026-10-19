#if !os(watchOS)
import SwiftUI

// MARK: - Main View

struct SportsTrackingView: View {
    @StateObject private var store = SportsStore.shared
    @State private var showingAdd  = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    StatsCardRow(store: store)
                    WeeklyBarChart(store: store)
                    ActivityListSection(store: store)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Theme.pageBackground)
            .navigationTitle("Sports Tracking")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddSportActivitySheet(store: store)
            }
        }.appPageTheme()
    }
}

// MARK: - Stats Cards

private struct StatsCardRow: View {
    @ObservedObject var store: SportsStore

    var body: some View {
        HStack(spacing: 12) {
            StatCard(title: "Activities",
                     value: "\(store.activities.count)",
                     icon: "figure.run",
                     color: .orange)
            StatCard(title: "Distance",
                     value: store.totalDistanceKm > 0
                         ? String(format: "%.1f km", store.totalDistanceKm)
                         : "—",
                     icon: "arrow.up.right",
                     color: .blue)
            StatCard(title: "Calories",
                     value: store.totalCalories > 0
                         ? "\(store.totalCalories) kcal"
                         : "—",
                     icon: "flame.fill",
                     color: .red)
        }
        .padding(.top, 12)
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let icon:  String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Weekly Bar Chart

private struct WeeklyBarChart: View {
    @ObservedObject var store: SportsStore

    private var weekActivities: [SportActivity] { store.activitiesThisWeek() }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(.headline)

            if weekActivities.isEmpty {
                Text("No activities this week. Tap + to log one.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else {
                HStack(alignment: .bottom, spacing: 6) {
                    ForEach(weekActivities) { activity in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(activity.type.color)
                                .frame(width: 28, height: barHeight(for: activity))
                            Text(activity.type.rawValue.prefix(3))
                                .font(.system(size: 9, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 80)
            }
        }
        .padding(16)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func barHeight(for activity: SportActivity) -> CGFloat {
        let maxVal = weekActivities.map { CGFloat($0.duration) }.max() ?? 1
        guard maxVal > 0 else { return 12 }
        return Swift.max(12, CGFloat(activity.duration) / maxVal * 60)
    }
}

// MARK: - Activity List

private struct ActivityListSection: View {
    @ObservedObject var store: SportsStore
    @State private var editingActivity: SportActivity?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Activities")
                .font(.headline)

            if store.activities.isEmpty {
                Text("No activities yet. Tap + to get started.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 32)
            } else {
                ForEach(store.activities) { activity in
                    ActivityRow(activity: activity)
                        .contentShape(Rectangle())
                        .onTapGesture { editingActivity = activity }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                store.delete(activity)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .sheet(item: $editingActivity) { activity in
            AddSportActivitySheet(store: store, editing: activity)
        }
    }
}

private struct ActivityRow: View {
    let activity: SportActivity

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(activity.type.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: activity.type.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(activity.type.color)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(activity.type.rawValue)
                    .font(.system(size: 15, weight: .semibold))
                HStack(spacing: 8) {
                    Label(activity.formattedDuration, systemImage: "clock")
                    if !activity.formattedDistance.isEmpty {
                        Label(activity.formattedDistance, systemImage: "arrow.up.right")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .labelStyle(.titleAndIcon)
            }

            Spacer()

            Text(activity.date, style: .date)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Add / Edit Sheet

struct AddSportActivitySheet: View {
    @ObservedObject var store: SportsStore
    var editing: SportActivity? = nil

    @Environment(\.dismiss) private var dismiss

    @State private var sportType:  SportType  = .running
    @State private var date:       Date       = Date()
    @State private var durationHr: Int        = 0
    @State private var durationMin: Int       = 30
    @State private var distanceStr: String    = ""
    @State private var caloriesStr: String    = ""
    @State private var notes:      String     = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Sport") {
                    Picker("Type", selection: $sportType) {
                        ForEach(SportType.allCases) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Duration") {
                    HStack {
                        Picker("Hours", selection: $durationHr) {
                            ForEach(0..<24) { Text("\($0)h").tag($0) }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)

                        Picker("Minutes", selection: $durationMin) {
                            ForEach(0..<60) { Text("\($0)m").tag($0) }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 100)
                }

                Section("Optional") {
                    HStack {
                        Text("Distance (km)")
                        Spacer()
                        TextField("0.00", text: $distanceStr)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Calories (kcal)")
                        Spacer()
                        TextField("0", text: $caloriesStr)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Notes") {
                    TextField("How did it go?", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }.appPageTheme()
            .navigationTitle(editing == nil ? "Log Activity" : "Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(durationHr == 0 && durationMin == 0)
                }
            }
        }.appPageTheme()
        .onAppear { populateIfEditing() }
    }

    private func populateIfEditing() {
        guard let a = editing else { return }
        sportType   = a.type
        date        = a.date
        durationHr  = a.duration / 60
        durationMin = a.duration % 60
        distanceStr = a.distance > 0 ? String(format: "%.2f", a.distance) : ""
        caloriesStr = a.calories > 0 ? "\(a.calories)" : ""
        notes       = a.notes
    }

    private func save() {
        let mins = durationHr * 60 + durationMin
        let dist = Double(distanceStr.replacingOccurrences(of: ",", with: ".")) ?? 0
        let cals = Int(caloriesStr) ?? 0

        var activity = SportActivity(
            type:     sportType,
            date:     date,
            duration: mins,
            distance: dist,
            calories: cals,
            notes:    notes
        )

        if let existing = editing {
            activity.id = existing.id
            store.update(activity)
        } else {
            store.add(activity)
        }
        dismiss()
    }
}
#endif


