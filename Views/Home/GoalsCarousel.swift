import SwiftUI

struct GoalsCarousel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Life Goals")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                Spacer()
                Button {
                    NotificationCenter.default.post(name: .switchTab, object: 2)
                } label: {
                    Text("See all")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.primary)
                }
                .buttonStyle(.plain)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(SampleData.goals) { goal in
                        Button {
                            NotificationCenter.default.post(name: .switchTab, object: 2)
                        } label: {
                            GoalCard(goal: goal)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollClipDisabled()
        }
    }
}

private struct GoalCard: View {
    let goal: LifeGoal

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.emoji)
                    .font(.system(size: 28))
                Spacer()
                Label("\(goal.streak)", systemImage: "flame.fill")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Theme.accent.opacity(0.15)))
            }

            Text(goal.title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 6) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(goal.color.opacity(0.18))
                        Capsule()
                            .fill(LinearGradient(colors: [goal.color, goal.color.opacity(0.7)],
                                                 startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * goal.progress)
                    }
                }
                .frame(height: 8)

                Text("\(Int(goal.progress * 100))% complete")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(width: 200, height: 170)
        .glassCard(cornerRadius: 22)
    }
}
