import SwiftUI

/// Shown on the Home tab for free users — a soft upgrade prompt.
struct PremiumNudgeBanner: View {
    @ObservedObject private var premium = PremiumStore.shared
    @State private var dismissed = false
    @State private var showPaywall = false

    var body: some View {
        if !premium.isActive && !dismissed {
            banner
                .transition(.move(edge: .top).combined(with: .opacity))
        }
    }

    private var banner: some View {
        HStack(spacing: 12) {
            Button { showPaywall = true } label: {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white.opacity(0.22))
                            .frame(width: 42, height: 42)
                        Image(systemName: "crown.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Unlock Premium")
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                        Text("Mood trends, habit streaks, themes & more")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.white.opacity(0.88))
                    }

                    Spacer()
                }
            }
            .buttonStyle(.plain)

            Button {
                withAnimation { dismissed = true }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white.opacity(0.75))
                    .frame(width: 24, height: 24)
                    .background(Color.white.opacity(0.15), in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(Theme.heroGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Theme.primary.opacity(0.4), radius: 14, x: 0, y: 8)
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

}

#Preview { PremiumNudgeBanner().padding() }
