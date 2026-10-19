import SwiftUI

struct ProjectsView: View {
    @StateObject private var store = ProjectStore.shared
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showAdd = false
    @State private var selected: AIProject? = nil
    @State private var filterCategory: ProjectCategory? = nil
    @State private var filterStatus: ProjectStatus? = nil
    @State private var showPaywall = false
    @State private var searchText = ""
    @State private var sortOption: ProjectSortOption = .pinned

    private var freeLimit: Int { ProjectStore.freeProjectLimit }

    private var filtered: [AIProject] {
        let matching = store.projects.filter { project in
            let matchesFilters =
                (filterCategory == nil || project.category == filterCategory) &&
                (filterStatus == nil || project.status == filterStatus)
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let matchesSearch =
                query.isEmpty ||
                project.title.localizedCaseInsensitiveContains(query) ||
                project.description.localizedCaseInsensitiveContains(query)
            return matchesFilters && matchesSearch
        }

        return matching.sorted { first, second in
            switch sortOption {
            case .pinned:
                if first.isPinned != second.isPinned { return first.isPinned }
                return first.createdAt > second.createdAt
            case .newest:
                return first.createdAt > second.createdAt
            case .deadline:
                return (first.targetDate ?? .distantFuture) < (second.targetDate ?? .distantFuture)
            case .progress:
                return first.progress > second.progress
            }
        }
    }

    // Projects the free user can see fully (first N)
    private var visibleFree: [AIProject] { Array(filtered.prefix(freeLimit)) }
    // Projects that need premium to see
    private var lockedProjects: [AIProject] { premium.isActive ? [] : Array(filtered.dropFirst(freeLimit)) }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        summaryHero
                        projectInsights
                        searchAndSort
                        filterRow
                        if filtered.isEmpty {
                            emptyState
                        } else {
                            projectsContent
                        }
                        Color.clear.frame(height: 32)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 12)
                }
            }
            .navigationTitle("AI Projects")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .sheet(isPresented: $showAdd) {
                AddProjectSheet(store: store)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $selected) { project in
                ProjectDetailView(store: store, project: project)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }.appPageTheme()
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAdd = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Theme.primary)
            }
        }
    }

    private var projectInsights: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("AI Project Focus", systemImage: "sparkles")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.black)
                Spacer()
                Text("Today")
                    .font(.caption.bold())
                    .foregroundStyle(Theme.primary)
            }

            Text(focusMessage)
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(.black.opacity(0.72))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 10) {
                insightPill(value: "\(dueSoonCount)", label: "Due Soon", icon: "calendar.badge.exclamationmark", color: .orange)
                insightPill(value: "\(store.pinned.count)", label: "Pinned", icon: "pin.fill", color: .blue)
                insightPill(value: "\(store.totalMilestones - store.completedMilestones)", label: "Steps Left", icon: "list.bullet", color: .purple)
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 20, tint: Theme.primary)
    }

    private var searchAndSort: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.black.opacity(0.55))
                TextField("Search projects", text: $searchText)
                    .foregroundStyle(.black)
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.black.opacity(0.45))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 15))

            HStack {
                Label("Sort projects", systemImage: "arrow.up.arrow.down")
                    .font(.caption.bold())
                    .foregroundStyle(.black.opacity(0.65))
                Spacer()
                Picker("Sort projects", selection: $sortOption) {
                    ForEach(ProjectSortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .labelsHidden()
            }
            .padding(.horizontal, 4)
        }
    }

    private var dueSoonCount: Int {
        store.projects.filter { project in
            guard let days = project.daysUntilTarget else { return false }
            return project.status == .active && days <= 14
        }.count
    }

    private var focusMessage: String {
        if let next = store.projects
            .filter({ $0.status == .active && $0.targetDate != nil })
            .sorted(by: { ($0.targetDate ?? .distantFuture) < ($1.targetDate ?? .distantFuture) })
            .first {
            return "Focus on “\(next.title)” next. It has \(next.milestones.count - next.completedMilestones) steps remaining and the closest target date."
        }
        return "Choose one active project, complete its next milestone, and keep your momentum moving."
    }

    private func insightPill(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(.black)
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.black.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.09), in: RoundedRectangle(cornerRadius: 13))
    }

    // MARK: - Projects content (free + locked)
    private var projectsContent: some View {
        VStack(spacing: 14) {
            // Free / all-premium cards
            let shownFully = premium.isActive ? filtered : visibleFree
            ForEach(shownFully) { project in
                projectRow(project)
            }

            // Premium upsell divider + locked cards
            if !premium.isActive && !lockedProjects.isEmpty {
                premiumUpsellBanner
                ForEach(lockedProjects) { project in
                    lockedProjectCard(project)
                }
            }
        }
    }

    private func projectRow(_ project: AIProject) -> some View {
        Button { selected = project } label: {
            ProjectCard(project: project)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                store.togglePin(id: project.id)
            } label: {
                Label(project.isPinned ? "Unpin" : "Pin", systemImage: project.isPinned ? "pin.slash" : "pin.fill")
            }
            Button(role: .destructive) {
                withAnimation { store.delete(id: project.id) }
            } label: {
                Label("Delete Project", systemImage: "trash")
            }
        }
    }

    // MARK: - Premium upsell banner
    private var premiumUpsellBanner: some View {
        Button { showPaywall = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Theme.heroGradient)
                        .frame(width: 46, height: 46)
                    Image(systemName: "lock.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(lockedProjects.count) project\(lockedProjects.count == 1 ? "" : "s") locked")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    Text("Go Premium for unlimited projects")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("Upgrade")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Theme.heroGradient, in: Capsule())
            }
            .padding(14)
            .glassCard(cornerRadius: 18, tint: Theme.primary)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Locked project card (blurred preview)
    private func lockedProjectCard(_ project: AIProject) -> some View {
        Button { showPaywall = true } label: {
            ZStack {
                ProjectCard(project: project)
                    .blur(radius: 6)
                    .allowsHitTesting(false)

                // Lock overlay
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        HStack(spacing: 10) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Theme.accent)
                            Text("Premium Project")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                            Spacer()
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 18)
                    )
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Summary Hero
    private var summaryHero: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Theme.heroGradient)
                .frame(height: 130)
                .shadow(color: Theme.primary.opacity(0.45), radius: 20, y: 10)

            Circle().fill(.white.opacity(0.08)).frame(width: 130).offset(x: 110, y: -25)
            Circle().fill(.white.opacity(0.05)).frame(width: 80).offset(x: 140, y: 35)

            HStack(spacing: 0) {
                statPill(value: "\(store.active.count)", label: "Active", icon: "bolt.fill")
                Divider().frame(height: 40).opacity(0.25)
                statPill(value: "\(store.completedMilestones)", label: "Done", icon: "checkmark.circle.fill")
                Divider().frame(height: 40).opacity(0.25)
                let progressLabel = premium.isActive ? "\(Int(store.overallProgress * 100))%" : "PRO"
                statPill(value: progressLabel, label: "Overall", icon: "chart.pie.fill")
            }
            .padding(.horizontal, 10)
        }
    }

    private func statPill(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(.white.opacity(0.8))
            Text(value).font(.system(size: 22, weight: .heavy, design: .rounded)).foregroundStyle(.white)
            Text(label).font(.system(size: 11, design: .rounded)).foregroundStyle(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Filter Row
    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(label: "All", icon: "square.grid.2x2.fill",
                           isActive: filterCategory == nil && filterStatus == nil) {
                    filterCategory = nil; filterStatus = nil
                }
                ForEach(ProjectStatus.allCases, id: \.self) { status in
                    filterChip(label: status.rawValue, icon: status.icon,
                               tint: status.tint, isActive: filterStatus == status) {
                        filterStatus = filterStatus == status ? nil : status
                        filterCategory = nil
                    }
                }
                ForEach(ProjectCategory.allCases, id: \.self) { cat in
                    filterChip(label: cat.rawValue, icon: cat.icon,
                               tint: cat.tint, isActive: filterCategory == cat) {
                        filterCategory = filterCategory == cat ? nil : cat
                        filterStatus = nil
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }

    private func filterChip(label: String, icon: String, tint: Color = Theme.primary,
                             isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(label, systemImage: icon)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(isActive ? .white : tint)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(isActive ? tint : tint.opacity(0.12), in: Capsule())
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3), value: isActive)
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("🎯")
                .font(.system(size: 60))
                .padding(.top, 40)
            Text("No projects yet")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text("Create your first AI project to break big goals into clear steps.")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Button { showAdd = true } label: {
                Label("Create Project", systemImage: "plus")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Theme.heroGradient, in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 40)
    }
}

private enum ProjectSortOption: String, CaseIterable {
    case pinned = "Pinned First"
    case newest = "Newest"
    case deadline = "Deadline"
    case progress = "Progress"
}

#Preview { ProjectsView() }
