import SwiftUI

struct ProjectCard: View {
    let project: AIProject
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerRow
            Divider().opacity(0.15).padding(.vertical, 12)
            progressSection
            milestonePills
        }
        .padding(16)
        .glassCard(cornerRadius: 22, tint: project.category.tint)
    }

    // MARK: - Header
    private var headerRow: some View {
        HStack(alignment: .top, spacing: 12) {
            emojiBadge
            VStack(alignment: .leading, spacing: 3) {
                Text(project.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .lineLimit(1)
                Text(project.description)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            statusBadge
        }
    }

    private var emojiBadge: some View {
        ZStack {
            Circle()
                .fill(project.category.tint.opacity(0.18))
                .frame(width: 46, height: 46)
            Text(project.emoji)
                .font(.system(size: 22))
        }
    }

    private var statusBadge: some View {
        Label(project.status.rawValue, systemImage: project.status.icon)
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .foregroundStyle(project.status.tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(project.status.tint.opacity(0.14), in: Capsule())
    }

    // MARK: - Progress
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(project.completedMilestones) of \(project.milestones.count) steps")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(project.progress * 100))%")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(project.category.tint)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(project.category.tint.opacity(0.15))
                        .frame(height: 7)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [project.category.tint, project.category.tint.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * project.progress, height: 7)
                        .animation(.spring(response: 0.6), value: project.progress)
                }
            }
            .frame(height: 7)
        }
        .padding(.bottom, 10)
    }

    // MARK: - Milestone pills (last 3)
    private var milestonePills: some View {
        let shown = Array(project.milestones.prefix(3))
        return VStack(spacing: 5) {
            ForEach(shown) { milestone in
                HStack(spacing: 8) {
                    Image(systemName: milestone.isDone ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 13))
                        .foregroundStyle(milestone.isDone ? project.category.tint : Color.secondary.opacity(0.5))
                    Text(milestone.title)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(milestone.isDone ? Color.secondary : Color.primary)
                        .strikethrough(milestone.isDone)
                        .lineLimit(1)
                    Spacer()
                }
            }
            if project.milestones.count > 3 {
                Text("+\(project.milestones.count - 3) more steps")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 2)
            }
        }
    }
}
