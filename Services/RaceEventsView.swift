import SwiftUI
import Combine

// MARK: - Race Events View

struct RaceEventsView: View {
    @StateObject private var store = RaceEventsStore.shared
    @State private var showingAddRace = false
    @State private var selectedSegment = 0
    
    private var upcomingRaces: [RaceEvent] {
        store.races.filter { $0.date >= Date() }.sorted { $0.date < $1.date }
    }
    
    private var pastRaces: [RaceEvent] {
        store.races.filter { $0.date < Date() }.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Segment Control
            Picker("Race Type", selection: $selectedSegment) {
                Text("Upcoming").tag(0)
                Text("Past").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    if selectedSegment == 0 {
                        UpcomingRacesSection()
                    } else {
                        PastRacesSection()
                    }
                }
                .padding()
            }
            .background(PaperBackground())
        }
        .navigationTitle("Race Events")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddRace = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Theme.primary)
                }
            }
        }
        .sheet(isPresented: $showingAddRace) {
            AddRaceSheet()
                .appPageTheme()
        }
        .appPageTheme()
    }
    
    // MARK: - Upcoming Races Section
    @ViewBuilder
    private func UpcomingRacesSection() -> some View {
        if upcomingRaces.isEmpty {
            EmptyStateView(
                icon: "trophy.fill",
                title: "No upcoming races",
                subtitle: "Add races you're planning to participate in",
                color: Color(red: 0.8, green: 0.2, blue: 0.8)
            )
            .padding(.top, 60)
        } else {
            VStack(spacing: 12) {
                ForEach(upcomingRaces) { race in
                    RaceCard(race: race, isPast: false)
                }
            }
        }
    }
    
    // MARK: - Past Races Section
    @ViewBuilder
    private func PastRacesSection() -> some View {
        if pastRaces.isEmpty {
            EmptyStateView(
                icon: "flag.checkered",
                title: "No past races",
                subtitle: "Your completed races will appear here",
                color: .gray
            )
            .padding(.top, 60)
        } else {
            VStack(spacing: 12) {
                ForEach(pastRaces) { race in
                    RaceCard(race: race, isPast: true)
                }
            }
        }
    }
}

// MARK: - Race Card

struct RaceCard: View {
    let race: RaceEvent
    let isPast: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(race.type.color)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: race.type.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                // Title & Date
                VStack(alignment: .leading, spacing: 4) {
                    Text(race.name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    
                    HStack(spacing: 8) {
                        Label(race.distance, systemImage: "location.fill")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundStyle(.secondary)
                        
                        if isPast {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(.green)
                        }
                    }
                }
                
                Spacer()
                
                // Days remaining or date
                VStack(alignment: .trailing, spacing: 4) {
                    if isPast {
                        Text(race.date, style: .date)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    } else {
                        Text("\(race.daysUntil)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(race.type.color)
                        Text("days")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Location & Details
            Divider()
            
            HStack(spacing: 16) {
                Label(race.location, systemImage: "mappin.circle.fill")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                Spacer()
                
                if let finishTime = race.finishTime, isPast {
                    HStack(spacing: 4) {
                        Image(systemName: "timer")
                            .font(.system(size: 12))
                        Text(finishTime)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(.blue)
                }
            }
            
            // Goals or Results
            if !isPast && !race.goals.isEmpty {
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Goals")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text(race.goals)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding()
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(race.type.color.opacity(0.16))
        }
        .shadow(color: race.type.color.opacity(0.10), radius: 10, y: 5)
        .opacity(isPast ? 0.85 : 1.0)
    }
}

// MARK: - Add Race Sheet

struct AddRaceSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = RaceEventsStore.shared
    
    @State private var name = ""
    @State private var type: RaceType = .running
    @State private var date = Date().addingTimeInterval(86400 * 30) // 30 days from now
    @State private var distance = "5K"
    @State private var location = ""
    @State private var goals = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Race Information") {
                    TextField("Race Name", text: $name)
                    
                    Picker("Type", selection: $type) {
                        ForEach(RaceType.allCases) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    
                    TextField("Distance", text: $distance)
                        .placeholder("e.g., 5K, 10K, Half Marathon")
                    
                    TextField("Location", text: $location)
                }
                
                Section("Date & Time") {
                    DatePicker("Race Date", selection: $date, displayedComponents: [.date])
                }
                
                Section("Goals") {
                    TextEditor(text: $goals)
                        .frame(height: 80)
                        .placeholder("e.g., Finish under 25 minutes")
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Race")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let race = RaceEvent(
                            name: name,
                            type: type,
                            date: date,
                            distance: distance,
                            location: location,
                            goals: goals,
                            notes: notes,
                            finishTime: nil
                        )
                        store.add(race)
                        dismiss()
                    }
                    .disabled(name.isEmpty || distance.isEmpty || location.isEmpty)
                }
            }
        }
    }
}

// MARK: - Supporting Types

struct RaceEvent: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: RaceType
    let date: Date
    let distance: String
    let location: String
    let goals: String
    let notes: String
    let finishTime: String?
    
    init(id: UUID = UUID(), name: String, type: RaceType, date: Date, distance: String, location: String, goals: String, notes: String, finishTime: String?) {
        self.id = id
        self.name = name
        self.type = type
        self.date = date
        self.distance = distance
        self.location = location
        self.goals = goals
        self.notes = notes
        self.finishTime = finishTime
    }
    
    var daysUntil: Int {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let raceDay = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: now, to: raceDay)
        return max(0, components.day ?? 0)
    }
}

enum RaceType: String, CaseIterable, Identifiable, Codable {
    case running = "Running"
    case cycling = "Cycling"
    case swimming = "Swimming"
    case triathlon = "Triathlon"
    case trail = "Trail"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        case .triathlon: return "figure.open.water.swim"
        case .trail: return "figure.hiking"
        case .other: return "trophy.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .running: return .orange
        case .cycling: return .blue
        case .swimming: return .cyan
        case .triathlon: return .purple
        case .trail: return .green
        case .other: return .pink
        }
    }
}

// MARK: - Race Events Store

final class RaceEventsStore: ObservableObject {
    static let shared = RaceEventsStore()
    
    @Published var races: [RaceEvent] = []
    
    private init() {
        loadSampleData()
    }
    
    func add(_ race: RaceEvent) {
        races.append(race)
        save()
    }
    
    private func save() {
        // Save to storage
    }
    
    private func loadSampleData() {
        // Sample races
        races = [
            RaceEvent(
                name: "City Marathon",
                type: .running,
                date: Date().addingTimeInterval(86400 * 45),
                distance: "Marathon",
                location: "Downtown",
                goals: "Finish under 4 hours",
                notes: "First marathon!",
                finishTime: nil
            ),
            RaceEvent(
                name: "Spring 5K",
                type: .running,
                date: Date().addingTimeInterval(-86400 * 30),
                distance: "5K",
                location: "City Park",
                goals: "Beat 25 minutes",
                notes: "",
                finishTime: "24:32"
            )
        ]
    }
}

// MARK: - Helper Extensions

extension View {
    func placeholder(_ text: String) -> some View {
        self.overlay(
            Text(text)
                .foregroundColor(.secondary.opacity(0.5))
                .padding(.horizontal, 4)
                .allowsHitTesting(false),
            alignment: .topLeading
        )
    }
}

#Preview {
    NavigationStack {
        RaceEventsView()
    }
}
