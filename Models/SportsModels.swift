import SwiftUI
import Foundation

// MARK: - Sport Type

enum SportType: String, Codable, CaseIterable, Identifiable {
    case running    = "Running"
    case cycling    = "Cycling"
    case swimming   = "Swimming"
    case triathlon  = "Triathlon"
    case gym        = "Gym"
    case yoga       = "Yoga"
    case basketball = "Basketball"
    case soccer     = "Soccer"
    case tennis     = "Tennis"
    case hiking     = "Hiking"
    case other      = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .running:    return "figure.run"
        case .cycling:    return "figure.outdoor.cycle"
        case .swimming:   return "figure.pool.swim"
        case .triathlon:  return "figure.mixed.cardio"
        case .gym:        return "dumbbell.fill"
        case .yoga:       return "figure.yoga"
        case .basketball: return "basketball.fill"
        case .soccer:     return "soccerball"
        case .tennis:     return "tennisball.fill"
        case .hiking:     return "mountain.2.fill"
        case .other:      return "figure.walk"
        }
    }

    var color: Color {
        switch self {
        case .running:    return Color(red: 1.00, green: 0.40, blue: 0.00)
        case .cycling:    return Color(red: 0.20, green: 0.70, blue: 0.30)
        case .swimming:   return Color(red: 0.00, green: 0.50, blue: 0.90)
        case .triathlon:  return Color(red: 0.55, green: 0.10, blue: 0.85)
        case .gym:        return Color(red: 0.90, green: 0.30, blue: 0.10)
        case .yoga:       return Color(red: 0.90, green: 0.60, blue: 0.00)
        case .basketball: return Color(red: 1.00, green: 0.55, blue: 0.00)
        case .soccer:     return Color(red: 0.20, green: 0.62, blue: 0.20)
        case .tennis:     return Color(red: 0.80, green: 0.80, blue: 0.00)
        case .hiking:     return Color(red: 0.45, green: 0.65, blue: 0.30)
        case .other:      return Color.gray
        }
    }
}

// MARK: - Sport Activity

struct SportActivity: Identifiable, Codable {
    var id: UUID
    var type: SportType
    var date: Date
    var duration: Int     // minutes
    var distance: Double  // km  (0 = not tracked)
    var calories: Int     // kcal (0 = not tracked)
    var notes: String
    
    // Memberwise initializer with default UUID
    init(id: UUID = UUID(), 
         type: SportType, 
         date: Date, 
         duration: Int, 
         distance: Double = 0, 
         calories: Int = 0, 
         notes: String = "") {
        self.id = id
        self.type = type
        self.date = date
        self.duration = duration
        self.distance = distance
        self.calories = calories
        self.notes = notes
    }

    var formattedDuration: String {
        let h = duration / 60
        let m = duration % 60
        return h > 0 ? "\(h)h \(m)m" : "\(m) min"
    }

    var formattedDistance: String {
        guard distance > 0 else { return "" }
        return distance < 1
            ? String(format: "%.0f m", distance * 1000)
            : String(format: "%.2f km", distance)
    }
}
