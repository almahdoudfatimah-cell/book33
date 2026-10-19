import SwiftUI

struct ProjectDetailView: View {
    @ObservedObject var store: ProjectStore
    @ObservedObject private var premium = PremiumStore.shared
    @State var project: AIProject
    @Environment(\.dismiss) private var dismiss
    @State private var showEdit = false
    @State private var showPaywall = false
    @State private var newMilestone = ""
    @State private var isAddingMilestone = false
    @FocusState private var milestoneFieldFocused: Bool

    private let freeMilestoneLimit = 5

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        heroCard
                        milestonesSection
                        infoSection
                        Color.clear.frame(height: 32)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 12)
                }
            }
            .navigationTitle(project.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.primary)
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showEdit = true } label: {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundStyle(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showEdit) {
                AddProjectSheet(store: store, editing: project) { updated in
                    project = updated
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }.appPageTheme()
        .onReceive(store.$projects) { updated in
            if let fresh = updated.first(where: { $0.id == project.id }) {
                project = fresh
            }
        }
    }

    // MARK: - Hero
    private var heroCard: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [project.category.tint, project.category.tint.opacity(0.65)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 140)
                    .shadow(color: project.category.tint.opacity(0.45), radius: 20, y: 10)

                Circle().fill(.white.opacity(0.08)).frame(width: 120).offset(x: 120, y: -20)
                Circle().fill(.white.opacity(0.05)).frame(width: 80).offset(x: 140, y: 30)

                HStack(spacing: 16) {
                    Text(project.emoji).font(.system(size: 52))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        if let days = project.daysUntilTarget {
                            Label("\(days) days left", systemImage: "calendar")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.85))
                        }
                    }
                    Spacer()
                }
                .padding(20)
            }

            // Progress bar row
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Progress")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(project.category.tint.opacity(0.15)).frame(height: 8)
                            Capsule()
                                .fill(LinearGradient(colors: [project.category.tint, project.category.tint.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: geo.size.width * project.progress, height: 8)
                                .animation(.spring(response: 0.5), value: project.progress)
                        }
                    }.frame(height: 8)
                }
                Text("\(Int(project.progress * 100))%")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(project.category.tint)
            }
            .padding(16)
            .glassCard(cornerRadius: 18, tint: project.category.tint)
        }
    }

    // MARK: - Milestones
    private var milestonesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Steps")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                Spacer()
                // Free users capped at freeMilestoneLimit milestones per project
                let canAdd = premium.isActive || project.milestones.count < freeMilestoneLimit
                Button {
                    if canAdd {
                        withAnimation { isAddingMilestone = true }
                        milestoneFieldFocused = true
                    } else {
                        showPaywall = true
                    }
                } label: {
                    Label(canAdd ? "Add" : "Upgrade", systemImage: canAdd ? "plus" : "crown.fill")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(canAdd ? Theme.primary : Theme.accent)
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 8) {
                ForEach(project.milestones) { milestone in
                    MilestoneRow(milestone: milestone) {
                        store.toggleMilestone(projectId: project.id, milestoneId: milestone.id)
                    }
                }

                if isAddingMilestone {
                    addMilestoneRow
                }

                // Locked milestone slot hint for free users
                if !premium.isActive && project.milestones.count >= freeMilestoneLimit {
                    lockedMilestoneHint
                }
            }
        }
    }

    private var lockedMilestoneHint: some View {
        Button { showPaywall = true } label: {
            HStack(spacing: 10) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.accent)
                Text("Unlock unlimited steps with Premium")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "lock.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.secondary.opacity(0.5))
            }
            .padding(12)
            .background(Theme.accent.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Theme.accent.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var addMilestoneRow: some View {
        HStack(spacing: 10) {
            Image(systemName: "circle").foregroundStyle(.secondary).font(.system(size: 16))
            TextField("New step…", text: $newMilestone)
                .font(.system(size: 15, design: .rounded))
                .focused($milestoneFieldFocused)
                .onSubmit { commitNewMilestone() }
            Button { commitNewMilestone() } label: {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Theme.primary)
                    .font(.system(size: 20))
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .glassCard(cornerRadius: 14, tint: Theme.primary)
    }

    private func commitNewMilestone() {
        let trimmed = newMilestone.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            withAnimation { isAddingMilestone = false }
            return
        }
        // Enforce free milestone limit
        var updated = project
        updated.milestones.append(Milestone(title: trimmed))
        store.update(updated)
        newMilestone = ""
        withAnimation { isAddingMilestone = false }
    }

    // MARK: - Info
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Details")
                .font(.system(size: 17, weight: .bold, design: .rounded))

            VStack(spacing: 0) {
                infoRow(label: "Category", value: project.category.rawValue, icon: project.category.icon, tint: project.category.tint)
                Divider().padding(.leading, 40)
                infoRow(label: "Status", value: project.status.rawValue, icon: project.status.icon, tint: project.status.tint)
                if let target = project.targetDate {
                    Divider().padding(.leading, 40)
                    infoRow(label: "Target Date", value: target.formatted(date: .abbreviated, time: .omitted), icon: "calendar", tint: Theme.accent)
                }
                Divider().padding(.leading, 40)
                infoRow(label: "Created", value: project.createdAt.formatted(date: .abbreviated, time: .omitted), icon: "clock", tint: .secondary)
            }
            .glassCard(cornerRadius: 16, tint: Theme.primary)
        }
    }

    private func infoRow(label: String, value: String, icon: String, tint: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 24)
            Text(label)
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

struct MilestoneRow: View {
    let milestone: Milestone
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 10) {
                Image(systemName: milestone.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18))
                    .foregroundStyle(milestone.isDone ? Theme.primary : Color.secondary.opacity(0.4))
                    .animation(.spring(response: 0.3), value: milestone.isDone)
                Text(milestone.title)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundStyle(milestone.isDone ? Color.secondary : Color.primary)
                    .strikethrough(milestone.isDone, color: .secondary)
                    .animation(.easeInOut(duration: 0.2), value: milestone.isDone)
                Spacer()
            }
            .padding(12)
            .glassCard(cornerRadius: 14, tint: milestone.isDone ? Theme.primary : .clear)
        }
        .buttonStyle(.plain)
    }
}
