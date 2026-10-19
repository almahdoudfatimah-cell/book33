import SwiftUI
import Combine

// MARK: - Race Calendar View

struct RaceCalendarView: View {
    @StateObject private var store = RaceCalendarStore.shared
    @State private var selectedMonth = Date()
    @State private var searchText = ""
    @State private var selectedCategory: RaceCategory = .all
    
    private var filteredRaces: [DiscoverableRace] {
        var races = store.races
        
        // Filter by category
        if selectedCategory != .all {
            races = races.filter { $0.category == selectedCategory }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            races = races.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return races.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Search races...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(RaceCategory.allCases) { category in
                        CategoryChip(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedCategory = category
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Races List
            ScrollView {
                VStack(spacing: 16) {
                    if filteredRaces.isEmpty {
                        EmptyStateView(
                            icon: "calendar.badge.exclamationmark",
                            title: "No races found",
                            subtitle: "Try adjusting your search or filters",
                            color: .blue
                        )
                        .padding(.top, 60)
                    } else {
                        ForEach(filteredRaces) { race in
                            DiscoverableRaceCard(race: race)
                        }
                    }
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
        }
        .navigationTitle("Race Calendar")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let category: RaceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? category.color : Color(uiColor: .secondarySystemGroupedBackground))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }
}

// MARK: - Discoverable Race Card

struct DiscoverableRaceCard: View {
    let race: DiscoverableRace
    @State private var isRegistered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header with Image
            ZStack(alignment: .topTrailing) {
                // Race image placeholder
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [race.category.color.opacity(0.6), race.category.color],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 140)
                    .overlay {
                        Image(systemName: race.category.icon)
                            .font(.system(size: 50, weight: .light))
                            .foregroundStyle(.white.opacity(0.3))
                    }
                
                // Registration badge
                if race.isRegistrationOpen {
                    HStack(spacing: 4) {
                        Image(systemName: "ticket.fill")
                            .font(.system(size: 10))
                        Text("Open")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white)
                    .foregroundStyle(race.category.color)
                    .clipShape(Capsule())
                    .padding(12)
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10))
                        Text("Closed")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white)
                    .foregroundStyle(.secondary)
                    .clipShape(Capsule())
                    .padding(12)
                }
            }
            
            // Race Details
            VStack(alignment: .leading, spacing: 10) {
                // Title & Category
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(race.name)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                        
                        Text(race.category.rawValue)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(race.category.color)
                    }
                    
                    Spacer()
                    
                    // Price
                    if let price = race.registrationFee {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(price)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            Text("Entry Fee")
                                .font(.system(size: 10, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // Date & Location
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.system(size: 13))
                            .foregroundStyle(race.category.color)
                            .frame(width: 20)
                        
                        Text(race.date, style: .date)
                            .font(.system(size: 14, design: .rounded))
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(race.category.color)
                            .frame(width: 20)
                        
                        Text(race.location)
                            .font(.system(size: 14, design: .rounded))
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "figure.run")
                            .font(.system(size: 13))
                            .foregroundStyle(race.category.color)
                            .frame(width: 20)
                        
                        Text(race.distances.joined(separator: ", "))
                            .font(.system(size: 14, design: .rounded))
                    }
                }
                
                // Description
                if let description = race.description {
                    Text(description)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .padding(.top, 4)
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    Button {
                        isRegistered.toggle()
                    } label: {
                        HStack {
                            Image(systemName: isRegistered ? "checkmark.circle.fill" : "plus.circle.fill")
                            Text(isRegistered ? "Added" : "Add to My Races")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isRegistered ? Color.green : race.category.color)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Button {
                        // Open race website
                    } label: {
                        Image(systemName: "arrow.up.right.square.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(race.category.color)
                            .frame(width: 44, height: 44)
                            .background(Color(uiColor: .tertiarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
    }
}

// MARK: - Supporting Types

struct DiscoverableRace: Identifiable, Codable {
    let id: UUID
    let name: String
    let category: RaceCategory
    let date: Date
    let location: String
    let distances: [String]
    let description: String?
    let registrationFee: String?
    let isRegistrationOpen: Bool
    let websiteURL: String?
    
    init(id: UUID = UUID(), name: String, category: RaceCategory, date: Date, location: String, distances: [String], description: String?, registrationFee: String?, isRegistrationOpen: Bool, websiteURL: String?) {
        self.id = id
        self.name = name
        self.category = category
        self.date = date
        self.location = location
        self.distances = distances
        self.description = description
        self.registrationFee = registrationFee
        self.isRegistrationOpen = isRegistrationOpen
        self.websiteURL = websiteURL
    }
}

enum RaceCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case running = "Running"
    case cycling = "Cycling"
    case swimming = "Swimming"
    case triathlon = "Triathlon"
    case trail = "Trail"
    case virtual = "Virtual"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        case .triathlon: return "figure.open.water.swim"
        case .trail: return "figure.hiking"
        case .virtual: return "globe"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .blue
        case .running: return .orange
        case .cycling: return .blue
        case .swimming: return .cyan
        case .triathlon: return .purple
        case .trail: return .green
        case .virtual: return .pink
        }
    }
}

// MARK: - Race Calendar Store

final class RaceCalendarStore: ObservableObject {
    static let shared = RaceCalendarStore()
    
    @Published var races: [DiscoverableRace] = []
    
    private init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        races = [
            DiscoverableRace(
                name: "Spring City Marathon",
                category: .running,
                date: Date().addingTimeInterval(86400 * 60),
                location: "Downtown, NY",
                distances: ["Marathon", "Half Marathon", "10K"],
                description: "The biggest spring running event in the city with thousands of participants.",
                registrationFee: "$85",
                isRegistrationOpen: true,
                websiteURL: nil
            ),
            DiscoverableRace(
                name: "Mountain Trail Challenge",
                category: .trail,
                date: Date().addingTimeInterval(86400 * 90),
                location: "Blue Ridge Mountains",
                distances: ["50K", "25K", "10K"],
                description: "Experience breathtaking mountain views on this challenging trail race.",
                registrationFee: "$120",
                isRegistrationOpen: true,
                websiteURL: nil
            ),
            DiscoverableRace(
                name: "Summer Triathlon Series",
                category: .triathlon,
                date: Date().addingTimeInterval(86400 * 120),
                location: "Lake Shore Park",
                distances: ["Sprint", "Olympic"],
                description: "Multi-sport event featuring swim, bike, and run segments.",
                registrationFee: "$150",
                isRegistrationOpen: true,
                websiteURL: nil
            ),
            DiscoverableRace(
                name: "Charity 5K Fun Run",
                category: .running,
                date: Date().addingTimeInterval(86400 * 30),
                location: "City Park",
                distances: ["5K"],
                description: "Family-friendly race supporting local charities. All ages welcome!",
                registrationFee: "$25",
                isRegistrationOpen: true,
                websiteURL: nil
            ),
            DiscoverableRace(
                name: "Virtual Global Challenge",
                category: .virtual,
                date: Date().addingTimeInterval(86400 * 45),
                location: "Anywhere",
                distances: ["5K", "10K", "Half Marathon"],
                description: "Run anywhere, anytime during the event window. Submit your results online.",
                registrationFee: "$15",
                isRegistrationOpen: true,
                websiteURL: nil
            ),
            DiscoverableRace(
                name: "Century Bike Ride",
                category: .cycling,
                date: Date().addingTimeInterval(86400 * 75),
                location: "Coastal Highway",
                distances: ["100 miles", "50 miles", "25 miles"],
                description: "Scenic coastal bike ride with rest stops and support vehicles.",
                registrationFee: "$95",
                isRegistrationOpen: false,
                websiteURL: nil
            )
        ]
    }
}

#Preview {
    NavigationStack {
        RaceCalendarView()
    }
}
