import SwiftUI

struct ProjectsHomeSection: View {
    @ObservedObject private var store = ProjectStore.shared
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showingPaywall = false
    private var freeLimit: Int { ProjectStore.freeProjectLimit }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("AI Projects")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                Spacer()
                Button {
                    NotificationCenter.default.post(name: .switchTab, object: 3)
                } label: {
                    Text("See all")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.primary)
                }
                .buttonStyle(.plain)
            }

            if store.projects.isEmpty {
                emptyCard
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(store.active.prefix(4).enumerated()), id: \.element.id) { index, project in
                            let locked = !premium.isActive && index >= freeLimit
                            if locked {
                                lockedMiniCard(project: project)
                            } else {
                                Button {
                                    NotificationCenter.default.post(name: .switchTab, object: 3)
                                } label: {
                                    ProjectMiniCard(project: project)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        // Upgrade card if free user has extra projects
                        if !premium.isActive && store.active.count > freeLimit {
                            upgradeMiniCard
                        }
                    }
                }
                .scrollClipDisabled()
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }

    // MARK: - Locked mini card
    private func lockedMiniCard(project: AIProject) -> some View {
        Button { showingPaywall = true } label: {
            ZStack {
                ProjectMiniCard(project: project)
                    .blur(radius: 5)
                    .allowsHitTesting(false)
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        VStack(spacing: 6) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Theme.primary)
                            Text("Premium")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.primary)
                        }
                    )
            }
            .frame(width: 180, height: 150)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Upgrade CTA mini card
    private var upgradeMiniCard: some View {
        Button { showingPaywall = true } label: {
            VStack(spacing: 10) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(Theme.heroGradient)
                Text("Unlock All\nProjects")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                Text("Go Premium")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Theme.heroGradient, in: Capsule())
            }
            .frame(width: 150, height: 150)
            .glassCard(cornerRadius: 20, tint: Theme.primary)
        }
        .buttonStyle(.plain)
    }

    private var emptyCard: some View {
        Button {
            NotificationCenter.default.post(name: .switchTab, object: 3)
        } label: {
            HStack(spacing: 14) {
                Text("🎯").font(.system(size: 30))
                VStack(alignment: .leading, spacing: 3) {
                    Text("Start a Project")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    Text("Break big goals into clear steps")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundStyle(Theme.primary)
            }
            .padding(16)
            .glassCard(cornerRadius: 18, tint: Theme.primary)
        }
        .buttonStyle(.plain)
    }
}

struct ProjectMiniCard: View {
    let project: AIProject

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(project.emoji).font(.system(size: 26))
                Spacer()
                Text("\(Int(project.progress * 100))%")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(project.category.tint)
            }

            Text(project.title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(project.category.tint.opacity(0.15))
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [project.category.tint, project.category.tint.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * project.progress)
                        .animation(.spring(response: 0.5), value: project.progress)
                }
            }
            .frame(height: 6)

            Text("\(project.completedMilestones)/\(project.milestones.count) steps")
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(width: 180, height: 150)
        .glassCard(cornerRadius: 20, tint: project.category.tint)
    }
}
