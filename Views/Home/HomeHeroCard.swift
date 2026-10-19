import SwiftUI

struct HomeHeroCard: View {
    let completion: Double
    let doneCount: Int
    let totalCount: Int

    var body: some View {
        ZStack(alignment: .topLeading) {
            heroBackground
            content
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                .allowsHitTesting(false)
        )
        .shadow(color: Theme.primary.opacity(0.25), radius: 20, x: 0, y: 12)
    }

    private var heroBackground: some View {
        ZStack {
            Theme.heroGradient
            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 220, height: 220)
                .blur(radius: 20)
                .offset(x: 140, y: -80)
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 160, height: 160)
                .blur(radius: 14)
                .offset(x: -90, y: 90)
        }
    }

    private var content: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Label("AI Plan ready", systemImage: "sparkles")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.white.opacity(0.22)))
                    .foregroundStyle(.white)

                Text("Your day,\noptimized.")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineSpacing(2)

                Text("\(doneCount) of \(totalCount) tasks complete")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
            }
            Spacer()
            progressRing
        }
        .padding(20)
    }

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.25), lineWidth: 10)
            Circle()
                .trim(from: 0, to: completion)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.8), value: completion)
            VStack(spacing: 0) {
                Text("\(Int(completion * 100))%")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("today")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .frame(width: 96, height: 96)
    }
}
