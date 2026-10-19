import SwiftUI

// MARK: - Diary Entry
struct DiaryEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var title: String
    var body: String
    var mood: DiaryMood
    var tags: [DiaryTag]
    var weather: DiaryWeather?
    var isFavorite: Bool = false
    var wordCount: Int { body.split(separator: " ").count }
}

// MARK: - Mood
enum DiaryMood: String, CaseIterable, Codable {
    case amazing = "Amazing"
    case happy = "Happy"
    case neutral = "Neutral"
    case sad = "Sad"
    case anxious = "Anxious"
    case angry = "Angry"

    var emoji: String {
        switch self {
        case .amazing:  return "🤩"
        case .happy:    return "😊"
        case .neutral:  return "😐"
        case .sad:      return "😢"
        case .anxious:  return "😰"
        case .angry:    return "😤"
        }
    }

    var color: Color {
        switch self {
        case .amazing:  return Color(red: 1.00, green: 0.82, blue: 0.00)  // Golden yellow
        case .happy:    return Color(red: 1.00, green: 0.58, blue: 0.05)  // Vivid orange
        case .neutral:  return Color(red: 0.70, green: 0.82, blue: 0.40)  // Muted lime
        case .sad:      return Color(red: 0.20, green: 0.60, blue: 0.30)  // Deep green
        case .anxious:  return Color(red: 1.00, green: 0.45, blue: 0.10)  // Deep orange
        case .angry:    return Color(red: 0.85, green: 0.25, blue: 0.05)  // Burnt red-orange
        }
    }

    var score: Double {
        switch self {
        case .amazing: return 1.0
        case .happy:   return 0.8
        case .neutral: return 0.5
        case .anxious: return 0.3
        case .sad:     return 0.2
        case .angry:   return 0.1
        }
    }
}

// MARK: - Tag
enum DiaryTag: String, CaseIterable, Codable {
    case work       = "Work"
    case family     = "Family"
    case health     = "Health"
    case travel     = "Travel"
    case growth     = "Growth"
    case gratitude  = "Gratitude"
    case dreams     = "Dreams"
    case social     = "Social"

    var icon: String {
        switch self {
        case .work:      return "briefcase"
        case .family:    return "house.fill"
        case .health:    return "heart.fill"
        case .travel:    return "airplane"
        case .growth:    return "leaf.fill"
        case .gratitude: return "star.fill"
        case .dreams:    return "moon.stars.fill"
        case .social:    return "person.2.fill"
        }
    }

    var color: Color {
        switch self {
        case .work:      return Color(red: 1.00, green: 0.58, blue: 0.05)  // Vivid orange
        case .family:    return Color(red: 1.00, green: 0.82, blue: 0.00)  // Golden yellow
        case .health:    return Color(red: 0.25, green: 0.75, blue: 0.35)  // Fresh green
        case .travel:    return Color(red: 0.60, green: 0.90, blue: 0.30)  // Lime green
        case .growth:    return Color(red: 0.20, green: 0.65, blue: 0.30)  // Deep green
        case .gratitude: return Color(red: 1.00, green: 0.70, blue: 0.00)  // Amber
        case .dreams:    return Color(red: 0.85, green: 0.32, blue: 0.00)  // Burnt orange
        case .social:    return Color(red: 0.75, green: 0.95, blue: 0.40)  // Yellow-lime
        }
    }
}

// MARK: - Weather
enum DiaryWeather: String, CaseIterable, Codable {
    case sunny   = "Sunny"
    case cloudy  = "Cloudy"
    case rainy   = "Rainy"
    case snowy   = "Snowy"
    case windy   = "Windy"

    var icon: String {
        switch self {
        case .sunny:  return "sun.max.fill"
        case .cloudy: return "cloud.fill"
        case .rainy:  return "cloud.rain.fill"
        case .snowy:  return "snowflake"
        case .windy:  return "wind"
        }
    }
}
