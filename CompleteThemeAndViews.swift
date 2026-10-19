//
//  CompleteThemeAndViews.swift
//  RaceTrian
//
//  ⚠️ INSTRUCTIONS:
//  1. In Xcode: File → New → File → Swift File
//  2. Name it: "CompleteThemeAndViews.swift"
//  3. Make sure "RaceTrian" is CHECKED
//  4. Delete all content and paste THIS ENTIRE FILE
//  5. Save (⌘S)
//  
//  6. THEN REMOVE THESE FILES FROM BUILD TARGET:
//     - ThemeFix.swift (uncheck "RaceTrian")
//     - ThemeAndMissingTypes.swift (uncheck "RaceTrian")
//     - UIPlaceholders 2.swift (uncheck "RaceTrian")
//     - Theme.swift (uncheck "RaceTrian")
//     - MissingViews.swift (uncheck "RaceTrian")
//  
//  7. Clean (⌘⇧K) and Build (⌘B)
//

import SwiftUI

// MARK: - Theme
public enum Theme {
    public static let primary = Color(red: 1.00, green: 0.40, blue: 0.00)
    public static let secondary = Color(red: 0.25, green: 0.75, blue: 0.35)
    public static let accent = Color(red: 1.00, green: 0.82, blue: 0.00)
    public static let mint = Color(red: 0.60, green: 0.90, blue: 0.55)
    public static let rose = Color(red: 1.00, green: 0.45, blue: 0.10)
    public static let blush = Color(red: 1.00, green: 0.96, blue: 0.80)
    public static let paper = Color(red: 1.00, green: 0.98, blue: 0.88)
    public static let stickyPink = Color(red: 1.00, green: 0.95, blue: 0.65)
    public static let stickyPeach = Color(red: 1.00, green: 0.85, blue: 0.55)
    public static let stickyYellow = Color(red: 0.85, green: 0.98, blue: 0.65)
    public static let stickyCoral = Color(red: 1.00, green: 0.78, blue: 0.55)
    public static let stickySage = Color(red: 0.75, green: 0.95, blue: 0.70)
    public static let surface = Color(red: 0.96, green: 0.95, blue: 0.92)
    public static let surfaceDark = Color(red: 0.16, green: 0.15, blue: 0.13)
    public static let pageBackground = Color(red: 0.99, green: 0.98, blue: 0.95)
    public static let pageBackgroundDark = Color(red: 0.10, green: 0.10, blue: 0.06)
    public static let textPrimary = Color.primary
    public static let textSecondary = Color.secondary
    public static let textTertiary = Color.secondary.opacity(0.6)
    
    public static func backgroundGradient(for scheme: ColorScheme) -> LinearGradient {
        if scheme == .dark {
            return LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.10, blue: 0.06),
                    Color(red: 0.14, green: 0.12, blue: 0.05),
                    Color(red: 0.10, green: 0.15, blue: 0.07)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    Color(red: 1.00, green: 0.98, blue: 0.88),
                    Color(red: 1.00, green: 0.96, blue: 0.80),
                    Color(red: 0.95, green: 0.98, blue: 0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    public static let heroGradient = LinearGradient(
        colors: [
            Color(red: 0.85, green: 0.32, blue: 0.00),
            Color(red: 1.00, green: 0.55, blue: 0.05),
            Color(red: 1.00, green: 0.82, blue: 0.00)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - PaperBackground
public struct PaperBackground: View {
    @Environment(\.colorScheme) private var scheme
    public init() {}
    public var body: some View {
        ZStack {
            (scheme == .dark ? Theme.pageBackgroundDark : Theme.pageBackground)
                .ignoresSafeArea()
        }
        .allowsHitTesting(false)
    }
}

// MARK: - TrackingData
public struct TrackingData: Identifiable {
    public let id = UUID()
    public var title: String
    public var value: String
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    public static let sample: [TrackingData] = [
        .init(title: "Sample Metric", value: "42"),
        .init(title: "Another Metric", value: "3.14")
    ]
}

// MARK: - View Modifiers
public struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat
    var tint: Color
    @Environment(\.colorScheme) private var scheme
    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(scheme == .dark ? Theme.surfaceDark : Theme.surface)
            )
            .shadow(color: Color.black.opacity(0.10), radius: 22, x: 0, y: 12)
    }
}

public extension View {
    func glassCard(cornerRadius: CGFloat = 24, tint: Color = Theme.primary) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius, tint: tint))
    }
    func appPageTheme() -> some View {
        self.tint(Theme.primary)
    }
}

// MARK: - Missing View Stubs

public struct CompetitionReadinessView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 60))
                .foregroundStyle(.yellow)
            Text("Competition Readiness")
                .font(.title.bold())
            Text("Assess your readiness for upcoming competitions")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Competition Readiness")
    }
}

public struct SwimmingTrackingView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.pool.swim")
                .font(.system(size: 60))
                .foregroundStyle(.cyan)
            Text("Swimming Tracking")
                .font(.title.bold())
            Text("Track your swimming workouts and progress")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Swimming")
    }
}

public struct CyclingMetricsView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bicycle")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            Text("Cycling Metrics")
                .font(.title.bold())
            Text("Detailed metrics for your cycling activities")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Cycling Metrics")
    }
}

public struct RunningAnalyticsView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.run")
                .font(.system(size: 60))
                .foregroundStyle(Theme.primary)
            Text("Running Analytics")
                .font(.title.bold())
            Text("Detailed analysis of your running performance")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Running Analytics")
    }
}

public struct FormAnalysisView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 60))
                .foregroundStyle(.purple)
            Text("Form Analysis")
                .font(.title.bold())
            Text("Analyze and improve your athletic form")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Form Analysis")
    }
}

public struct WeatherImpactView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            Text("Weather Impact")
                .font(.title.bold())
            Text("Understand how weather affects your performance")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Weather Impact")
    }
}

public struct TrainingLoadView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundStyle(Theme.primary)
            Text("Training Load")
                .font(.title.bold())
            Text("Monitor your training load and recovery needs")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Training Load")
    }
}

public struct SeasonalTrendsView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
            Text("Seasonal Trends")
                .font(.title.bold())
            Text("Analyze your performance trends across seasons")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Seasonal Trends")
    }
}

public struct InjuryPreventionView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 60))
                .foregroundStyle(.red)
            Text("Injury Prevention")
                .font(.title.bold())
            Text("Tips and insights to prevent training injuries")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Injury Prevention")
    }
}

public struct PerformancePredictorView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            Text("Performance Predictor")
                .font(.title.bold())
            Text("Predict future performance based on current training")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Performance Predictor")
    }
}
