import SwiftUI

// A no-op ViewModifier for appPageTheme
struct AppPageTheme: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func appPageTheme() -> some View {
        self.modifier(AppPageTheme())
    }
}

// A plain white paper-like background
struct PaperBackground: View {
    var body: some View {
        Color.white.ignoresSafeArea()
    }
}

// Placeholder feature views
struct FeaturesView: View {
    var body: some View {
        Text("Features coming soon")
            .font(.headline)
            .foregroundColor(.gray)
    }
}

struct FeatureListView: View {
    var body: some View {
        VStack {
            Text("Feature List")
                .font(.title)
            Text("No features available yet.")
                .foregroundColor(.secondary)
        }
    }
}

// Tracking data structure
struct TrackingData {
    var eventName: String
    var parameters: [String: String]
}
