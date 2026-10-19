import SwiftUI

struct AddProjectSheet: View {
    @Environment(\.dismiss) private var dismiss
    let store: ProjectStore
    let editing: AIProject?
    let onSaved: (AIProject) -> Void

    @State private var title: String
    @State private var projectDescription: String
    @State private var emoji: String
    @State private var category: ProjectCategory
    @State private var status: ProjectStatus
    @State private var hasTargetDate: Bool
    @State private var targetDate: Date
    @State private var milestoneText: String

    private let emojis = ["🚀", "✨", "🎯", "💪", "📚", "💡", "💰", "🌱"]

    init(store: ProjectStore, editing: AIProject? = nil, onSaved: @escaping (AIProject) -> Void = { _ in }) {
        self.store = store
        self.editing = editing
        self.onSaved = onSaved
        _title = State(initialValue: editing?.title ?? "")
        _projectDescription = State(initialValue: editing?.description ?? "")
        _emoji = State(initialValue: editing?.emoji ?? "🚀")
        _category = State(initialValue: editing?.category ?? .personal)
        _status = State(initialValue: editing?.status ?? .active)
        _hasTargetDate = State(initialValue: editing?.targetDate != nil)
        _targetDate = State(initialValue: editing?.targetDate ?? Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date())
        _milestoneText = State(initialValue: editing?.milestones.map(\.title).joined(separator: "\n") ?? "")
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !projectDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        projectIdentity
                        projectDetails
                        timeline
                        milestones
                    }
                    .padding(20)
                    .padding(.bottom, 30)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle(editing == nil ? "New AI Project" : "Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveProject() }
                        .fontWeight(.bold)
                        .disabled(!canSave)
                }
            }
        }
        .appPageTheme()
    }

    private var projectIdentity: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Project")
                .font(.headline)
                .foregroundStyle(.black)

            TextField("Project title", text: $title)
                .textFieldStyle(.roundedBorder)

            TextField("Describe the result you want to achieve", text: $projectDescription, axis: .vertical)
                .lineLimit(3...6)
                .textFieldStyle(.roundedBorder)

            Text("Choose an icon")
                .font(.subheadline.bold())
                .foregroundStyle(.black)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                ForEach(emojis, id: \.self) { item in
                    Button {
                        emoji = item
                    } label: {
                        Text(item)
                            .font(.system(size: 28))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(emoji == item ? Theme.primary.opacity(0.18) : Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 13))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .glassCard()
    }

    private var projectDetails: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Organization")
                .font(.headline)
                .foregroundStyle(.black)

            Picker("Category", selection: $category) {
                ForEach(ProjectCategory.allCases, id: \.self) { item in
                    Label(item.rawValue, systemImage: item.icon).tag(item)
                }
            }

            Picker("Status", selection: $status) {
                ForEach(ProjectStatus.allCases, id: \.self) { item in
                    Label(item.rawValue, systemImage: item.icon).tag(item)
                }
            }
        }
        .padding(16)
        .glassCard()
    }

    private var timeline: some View {
        VStack(alignment: .leading, spacing: 14) {
            Toggle("Set a target date", isOn: $hasTargetDate)
                .font(.headline)
                .foregroundStyle(.black)

            if hasTargetDate {
                DatePicker("Target", selection: $targetDate, in: Date()..., displayedComponents: .date)
                    .foregroundStyle(.black)
            }
        }
        .padding(16)
        .glassCard()
    }

    private var milestones: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Milestones")
                .font(.headline)
                .foregroundStyle(.black)
            Text("Add one step per line. AI Projects will turn them into a progress checklist.")
                .font(.caption)
                .foregroundStyle(.black.opacity(0.62))
            TextField("Research ideas\nCreate the first draft\nReview and publish", text: $milestoneText, axis: .vertical)
                .lineLimit(5...10)
                .textFieldStyle(.roundedBorder)
        }
        .padding(16)
        .glassCard()
    }

    private func saveProject() {
        let milestoneTitles = milestoneText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let previousMilestones = editing?.milestones ?? []
        let updatedMilestones = milestoneTitles.map { milestoneTitle in
            previousMilestones.first(where: { $0.title == milestoneTitle }) ??
            Milestone(title: milestoneTitle)
        }

        let project = AIProject(
            id: editing?.id ?? UUID(),
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: projectDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            emoji: emoji,
            category: category,
            status: status,
            milestones: updatedMilestones,
            createdAt: editing?.createdAt ?? Date(),
            targetDate: hasTargetDate ? targetDate : nil,
            isPinned: editing?.isPinned ?? false
        )

        if editing == nil {
            store.add(project)
        } else {
            store.update(project)
        }
        onSaved(project)
        dismiss()
    }
}
