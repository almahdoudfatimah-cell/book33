import SwiftUI

// MARK: - appPageTheme no-op modifier

private struct AppPageTheme: ViewModifier {
    var background: Color?
    var tint: Color?

    func body(content: Content) -> some View {
        content
            .background(background ?? Color.clear)
            .tint(tint ?? .accentColor)
    }
}

public extension View {
    /// No-op page theming modifier to satisfy usages in the codebase.
    /// Replace with your real implementation when Theme is ready.
    func appPageTheme(background: Color? = nil, tint: Color? = nil) -> some View {
        modifier(AppPageTheme(background: background, tint: tint))
    }
}

// MARK: - PaperBackground placeholder

public struct PaperBackground: View {
    public var cornerRadius: CGFloat = 12
    public init(cornerRadius: CGFloat = 12) { self.cornerRadius = cornerRadius }
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.thinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.06))
            )
    }
}

// MARK: - TrackingData minimal model

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

// MARK: - Placeholder feature views

public struct CompetitionReadinessView: View {
    public init() {}
    public var body: some View { Text("CompetitionReadinessView placeholder") }
}

public struct SwimmingTrackingView: View {
    public init() {}
    public var body: some View { Text("SwimmingTrackingView placeholder") }
}

public struct CyclingMetricsView: View {
    public init() {}
    public var body: some View { Text("CyclingMetricsView placeholder") }
}

public struct RunningAnalyticsView: View {
    public init() {}
    public var body: some View { Text("RunningAnalyticsView placeholder") }
}

public struct InjuryPreventionView: View {
    public init() {}
    public var body: some View { Text("InjuryPreventionView placeholder") }
}

public struct FormAnalysisView: View {
    public init() {}
    public var body: some View { Text("FormAnalysisView placeholder") }
}

public struct WeatherImpactView: View {
    public init() {}
    public var body: some View { Text("WeatherImpactView placeholder") }
}

public struct TrainingLoadView: View {
    public init() {}
    public var body: some View { Text("TrainingLoadView placeholder") }
}

public struct SeasonalTrendsView: View {
    public init() {}
    public var body: some View { Text("SeasonalTrendsView placeholder") }
}

public struct PerformancePredictorView: View {
    public init() {}
    public var body: some View { Text("PerformancePredictorView placeholder") }
}
