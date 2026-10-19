// TrainingTrackingView - Should be in Views/Training folder
// This is a proper implementation stub

import SwiftUI

struct TrainingTrackingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Training Tracking")
                    .font(.largeTitle.bold())
                
                Text("Track your training progress here")
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("Training Tracking")
    }
}

#Preview {
    NavigationStack {
        TrainingTrackingView()
    }
}
