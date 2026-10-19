import SwiftUI
import Combine

final class ProfileStore: ObservableObject {
    // Identity
    @AppStorage("profile.name") var name: String = "Alex" {
        willSet { objectWillChange.send() }
    }
    @AppStorage("profile.tagline") var tagline: String = "Building my best life 🚀" {
        willSet { objectWillChange.send() }
    }
    @AppStorage("profile.avatar") var avatarEmoji: String = "🧑‍💻" {
        willSet { objectWillChange.send() }
    }

    // Focus style
    @AppStorage("profile.focusStyle") var focusStyleRaw: String = FocusStyle.deepWork.rawValue {
        willSet { objectWillChange.send() }
    }
    var focusStyle: FocusStyle {
        get { FocusStyle(rawValue: focusStyleRaw) ?? .deepWork }
        set { focusStyleRaw = newValue.rawValue }
    }

    // Schedule
    @AppStorage("profile.wakeHour") var wakeHour: Int = 7 {
        willSet { objectWillChange.send() }
    }
    @AppStorage("profile.sleepHour") var sleepHour: Int = 23 {
        willSet { objectWillChange.send() }
    }

    // Life areas (stored as comma-separated)
    @AppStorage("profile.lifeAreas") private var lifeAreasRaw: String = "Career,Health,Mindset,Learning" {
        willSet { objectWillChange.send() }
    }
    var selectedAreas: Set<LifeArea> {
        get {
            let parts = lifeAreasRaw.split(separator: ",").compactMap { LifeArea(rawValue: String($0)) }
            return Set(parts)
        }
        set {
            lifeAreasRaw = newValue.map { $0.rawValue }.joined(separator: ",")
        }
    }

    // Notifications
    @AppStorage("notif.morningBriefing") var morningBriefing: Bool = true {
        willSet { objectWillChange.send() }
    }
    @AppStorage("notif.morningTime") var morningNotifHour: Int = 8 {
        willSet { objectWillChange.send() }
    }
    @AppStorage("notif.eveningReview") var eveningReview: Bool = true {
        willSet { objectWillChange.send() }
    }
    @AppStorage("notif.eveningTime") var eveningNotifHour: Int = 21 {
        willSet { objectWillChange.send() }
    }
    @AppStorage("notif.habitReminders") var habitReminders: Bool = true {
        willSet { objectWillChange.send() }
    }
    @AppStorage("notif.focusAlerts") var focusAlerts: Bool = true {
        willSet { objectWillChange.send() }
    }
    @AppStorage("notif.aiInsights") var aiInsights: Bool = true {
        willSet { objectWillChange.send() }
    }
    @AppStorage("notif.weeklyReport") var weeklyReport: Bool = true {
        willSet { objectWillChange.send() }
    }

    // Appearance
    @AppStorage("pref.haptics") var haptics: Bool = true {
        willSet { objectWillChange.send() }
    }
    @AppStorage("pref.compactMode") var compactMode: Bool = false {
        willSet { objectWillChange.send() }
    }
    @AppStorage("pref.appTheme") var appThemeRaw: String = AppTheme.energetic.rawValue {
        willSet { objectWillChange.send() }
    }

    var appTheme: AppTheme {
        get { AppTheme(rawValue: appThemeRaw) ?? .energetic }
        set { appThemeRaw = newValue.rawValue }
    }

    static let shared = ProfileStore()
    private init() {}
}
