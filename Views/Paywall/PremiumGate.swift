import SwiftUI

/// Passes content through unchanged — premium gate removed.
struct PremiumGate<Content: View>: View {
    let featureTitle: String
    let featureSubtitle: String
    let icon: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
    }
}
