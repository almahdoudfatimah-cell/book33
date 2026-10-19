import SwiftUI

struct PremiumCard: View {
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showPaywall = false
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        content
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
    }

    @ViewBuilder
    private var content: some View {
        if premium.isActive {
            activeCard
        } else {
            upgradeCard
        }
    }

    private var upgradeCard: some View {
        Button { showPaywall = true } label: {
        HStack(spacing: isIPad ? 18 : 14) {
            ZStack {
                RoundedRectangle(cornerRadius: isIPad ? 18 : 16, style: .continuous)
                    .fill(.white.opacity(0.22))
                    .frame(width: isIPad ? 64 : 56, height: isIPad ? 64 : 56)
                Image(systemName: "crown.fill")
                    .font(.system(size: isIPad ? 30 : 26, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: isIPad ? 6 : 4) {
                Text("Go Premium")
                    .font(.system(size: isIPad ? 20 : 17, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Unlimited AI Coach + advanced tracking")
                    .font(.system(size: isIPad ? 16 : 13, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: isIPad ? 18 : 16, weight: .bold))
                .foregroundStyle(.white.opacity(0.85))
        }
        .padding(isIPad ? 20 : 16)
        .background(Theme.heroGradient, in: RoundedRectangle(cornerRadius: isIPad ? 26 : 22, style: .continuous))
        .shadow(color: Theme.primary.opacity(0.4), radius: isIPad ? 22 : 18, x: 0, y: isIPad ? 12 : 10)
        }
        .buttonStyle(.plain)
    }

    private var activeCard: some View {
        HStack(spacing: isIPad ? 18 : 14) {
            ZStack {
                RoundedRectangle(cornerRadius: isIPad ? 18 : 16, style: .continuous)
                    .fill(Theme.primary.opacity(0.18))
                    .frame(width: isIPad ? 64 : 56, height: isIPad ? 64 : 56)
                Image(systemName: "crown.fill")
                    .font(.system(size: isIPad ? 30 : 26, weight: .bold))
                    .foregroundStyle(Theme.primary)
            }

            VStack(alignment: .leading, spacing: isIPad ? 6 : 4) {
                HStack(spacing: isIPad ? 8 : 6) {
                    Text("Premium")
                        .font(.system(size: isIPad ? 20 : 17, weight: .bold, design: .rounded))
                    Text("✓")
                        .font(.system(size: isIPad ? 20 : 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.mint)
                }
                Text("\(premium.currentPlan?.title ?? "Active") • Thanks for supporting us 💜")
                    .font(.system(size: isIPad ? 16 : 13, design: .rounded))
            }
            .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(isIPad ? 20 : 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: isIPad ? 26 : 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: isIPad ? 26 : 22, style: .continuous)
                .stroke(Theme.primary.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview { PremiumCard().padding() }
