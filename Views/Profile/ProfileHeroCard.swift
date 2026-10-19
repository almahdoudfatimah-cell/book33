import SwiftUI

struct ProfileHeroCard: View {
    @ObservedObject var store: ProfileStore
    let onEdit: () -> Void
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    // Streak & stats (sample)
    private let joinedDays = 47
    private let totalTasks = 214
    private let currentStreak = 22

    var body: some View {
        ZStack(alignment: .topTrailing) {
            backgroundBlobs
            VStack(spacing: isIPad ? 24 : 16) {
                // Avatar + name
                HStack(spacing: isIPad ? 24 : 16) {
                    avatarView
                    VStack(alignment: .leading, spacing: isIPad ? 6 : 4) {
                        Text(store.name)
                            .font(.system(size: isIPad ? 26 : 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text(store.tagline)
                            .font(.system(size: isIPad ? 17 : 13, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))
                            .lineLimit(2)
                    }
                    Spacer()
                }

                Divider().background(Color.white.opacity(0.3))

                // Stats row
                HStack(spacing: 0) {
                    statItem(value: "\(joinedDays)", label: "Days active")
                    statDivider
                    statItem(value: "\(totalTasks)", label: "Tasks done")
                    statDivider
                    statItem(value: "🔥 \(currentStreak)", label: "Streak")
                }
            }
            .padding(isIPad ? 32 : 20)

            // Edit button
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .font(.system(size: isIPad ? 16 : 13, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: isIPad ? 36 : 30, height: isIPad ? 36 : 30)
                    .background(Circle().fill(Color.white.opacity(0.25)))
            }
            .padding(isIPad ? 18 : 16)
        }
        .background(
            RoundedRectangle(cornerRadius: isIPad ? 36 : 28, style: .continuous)
                .fill(Theme.heroGradient)
        )
        .overlay(
            RoundedRectangle(cornerRadius: isIPad ? 36 : 28, style: .continuous)
                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Theme.primary.opacity(0.3), radius: isIPad ? 28 : 20, x: 0, y: isIPad ? 14 : 10)
    }

    private var avatarView: some View {
        Text(store.avatarEmoji)
            .font(.system(size: isIPad ? 44 : 38))
            .frame(width: isIPad ? 72 : 66, height: isIPad ? 72 : 66)
            .background(Circle().fill(Color.white.opacity(0.2)))
    }

    private var backgroundBlobs: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: isIPad ? 260 : 200)
                .blur(radius: isIPad ? 26 : 20)
                .offset(x: isIPad ? 130 : 100, y: isIPad ? -80 : -60)
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: isIPad ? 180 : 140)
                .blur(radius: isIPad ? 18 : 14)
                .offset(x: isIPad ? -100 : -80, y: isIPad ? 80 : 60)
        }
        .clipShape(RoundedRectangle(cornerRadius: isIPad ? 32 : 28, style: .continuous))
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: isIPad ? 5 : 3) {
            Text(value)
                .font(.system(size: isIPad ? 22 : 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: isIPad ? 14 : 11, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity)
    }

    private var statDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.25))
            .frame(width: 1, height: isIPad ? 42 : 36)
    }
}
