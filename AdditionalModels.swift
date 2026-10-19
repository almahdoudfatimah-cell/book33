//
//  AdditionalModels.swift
//  RaceTrian
//
//  Created to resolve missing type errors
//

import SwiftUI

// MARK: - App Theme

enum AppTheme: String, CaseIterable, Identifiable, Codable {
    case energetic = "Energetic"
    case calm = "Calm"
    case focused = "Focused"
    case vibrant = "Vibrant"
    
    var id: String { rawValue }
    
    var primaryColor: Color {
        switch self {
        case .energetic: return Theme.primary
        case .calm: return .blue
        case .focused: return .purple
        case .vibrant: return .pink
        }
    }
    
    var description: String {
        switch self {
        case .energetic: return "Bold and motivating"
        case .calm: return "Peaceful and balanced"
        case .focused: return "Minimal distractions"
        case .vibrant: return "Bright and cheerful"
        }
    }
}

// MARK: - Day Schedule

struct DaySchedule: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var tasks: [ScheduleTask] = []
    var notes: String = ""
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var progressPercentage: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(completedTasksCount) / Double(tasks.count)
    }
}

struct ScheduleTask: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var startTime: Date
    var duration: TimeInterval
    var isCompleted: Bool = false
    var category: TaskCategory = .other
    
    enum TaskCategory: String, Codable, CaseIterable {
        case training = "Training"
        case work = "Work"
        case personal = "Personal"
        case recovery = "Recovery"
        case other = "Other"
        
        var color: Color {
            switch self {
            case .training: return .blue
            case .work: return .orange
            case .personal: return .green
            case .recovery: return .purple
            case .other: return .gray
            }
        }
        
        var icon: String {
            switch self {
            case .training: return "figure.run"
            case .work: return "briefcase.fill"
            case .personal: return "person.fill"
            case .recovery: return "bed.double.fill"
            case .other: return "list.bullet"
            }
        }
    }
}

// MARK: - Mood Entry

struct MoodEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var mood: MoodLevel
    var energy: Int // 1-10
    var stress: Int // 1-10
    var notes: String = ""
    
    enum MoodLevel: String, Codable, CaseIterable {
        case excellent = "Excellent"
        case good = "Good"
        case okay = "Okay"
        case low = "Low"
        case poor = "Poor"
        
        var emoji: String {
            switch self {
            case .excellent: return "🤩"
            case .good: return "😊"
            case .okay: return "😐"
            case .low: return "😕"
            case .poor: return "😞"
            }
        }
        
        var color: Color {
            switch self {
            case .excellent: return .green
            case .good: return .blue
            case .okay: return .yellow
            case .low: return .orange
            case .poor: return .red
            }
        }
        
        var score: Double {
            switch self {
            case .excellent: return 1.0
            case .good: return 0.75
            case .okay: return 0.5
            case .low: return 0.25
            case .poor: return 0.0
            }
        }
    }
}

// MARK: - Habit Streak

struct HabitStreak: Identifiable, Codable {
    var id: UUID = UUID()
    var habitName: String
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var completionDates: [Date] = []
    var goalFrequency: Int = 7 // days per week
    
    var isActiveToday: Bool {
        guard let lastDate = completionDates.last else { return false }
        return Calendar.current.isDateInToday(lastDate)
    }
    
    mutating func markComplete(on date: Date = Date()) {
        completionDates.append(date)
        updateStreak()
    }
    
    private mutating func updateStreak() {
        // Calculate current streak
        let calendar = Calendar.current
        var streak = 0
        var checkDate = Date()
        
        let sortedDates = completionDates.sorted(by: >)
        
        for date in sortedDates {
            if calendar.isDate(date, inSameDayAs: checkDate) {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else {
                break
            }
        }
        
        currentStreak = streak
        longestStreak = max(longestStreak, currentStreak)
    }
}

// MARK: - Tracking Data

struct TrackingData: Identifiable, Codable {
    var id: UUID = UUID()
    var timestamp: Date = Date()
    var activityType: ActivityType
    var duration: TimeInterval
    var distance: Double? // in kilometers
    var heartRate: Int? // bpm
    var pace: Double? // min/km
    var calories: Int?
    var elevation: Double? // meters
    var notes: String = ""
    
    enum ActivityType: String, Codable, CaseIterable {
        case running = "Running"
        case cycling = "Cycling"
        case swimming = "Swimming"
        case strength = "Strength Training"
        case yoga = "Yoga"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .running: return "figure.run"
            case .cycling: return "bicycle"
            case .swimming: return "figure.pool.swim"
            case .strength: return "dumbbell.fill"
            case .yoga: return "figure.yoga"
            case .other: return "figure.walk"
            }
        }
        
        var color: Color {
            switch self {
            case .running: return .blue
            case .cycling: return .green
            case .swimming: return .cyan
            case .strength: return .orange
            case .yoga: return .purple
            case .other: return .gray
            }
        }
    }
}

// MARK: - Additional Helper Models

struct WorkoutSummary: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var totalDistance: Double
    var totalDuration: TimeInterval
    var totalCalories: Int
    var averageHeartRate: Int?
    var activities: [TrackingData]
}

struct WeeklySummary: Identifiable {
    var id: UUID = UUID()
    var weekStart: Date
    var totalActivities: Int
    var totalDistance: Double
    var totalDuration: TimeInterval
    var totalCalories: Int
    var activeDays: Int
}

// MARK: - Performance Metrics

struct PerformanceMetric: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var metricType: MetricType
    var value: Double
    var unit: String
    
    enum MetricType: String, Codable, CaseIterable {
        case vo2Max = "VO2 Max"
        case restingHeartRate = "Resting Heart Rate"
        case maxHeartRate = "Max Heart Rate"
        case lactateThreshold = "Lactate Threshold"
        case functionalThreshold = "Functional Threshold Power"
        case speedEndurance = "Speed Endurance"
        
        var unit: String {
            switch self {
            case .vo2Max: return "ml/kg/min"
            case .restingHeartRate, .maxHeartRate: return "bpm"
            case .lactateThreshold: return "bpm"
            case .functionalThreshold: return "watts"
            case .speedEndurance: return "min/km"
            }
        }
        
        var icon: String {
            switch self {
            case .vo2Max: return "lungs.fill"
            case .restingHeartRate: return "heart.fill"
            case .maxHeartRate: return "heart.circle.fill"
            case .lactateThreshold: return "drop.fill"
            case .functionalThreshold: return "bolt.fill"
            case .speedEndurance: return "speedometer"
            }
        }
    }
}
