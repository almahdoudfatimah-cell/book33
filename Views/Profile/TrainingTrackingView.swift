import SwiftUI

struct TrainingTrackingView: View {
    var body: some View {
        TrainingFeatureDashboard(
            title: "Training Tracking",
            subtitle: "Follow your weekly load, consistency, and improvement",
            icon: "chart.bar.fill",
            color: .blue,
            focusItems: [
                "Log today's training load",
                "Review weekly consistency",
                "Update the next performance goal"
            ]
        )
    }
}

#Preview {
    NavigationStack {
        TrainingTrackingView()
    }
}
