import SwiftUI
import Combine

@MainActor
final class ProjectStore: ObservableObject {
    static let shared = ProjectStore()

    @Published var projects: [AIProject] = []

    private let defaultsKey = "aiProjectStore.v2"

    /// Free users may own this many projects before hitting the paywall.
    static let freeProjectLimit = 1

    private init() {
        load()
        if projects.isEmpty {
            projects = SampleProjects.all
            save()
        }
    }

    // MARK: - CRUD
    func add(_ project: AIProject) {
        projects.insert(project, at: 0)
        save()
    }

    func update(_ project: AIProject) {
        guard let idx = projects.firstIndex(where: { $0.id == project.id }) else { return }
        projects[idx] = project
        save()
    }

    func delete(id: UUID) {
        projects.removeAll { $0.id == id }
        save()
    }

    func toggleMilestone(projectId: UUID, milestoneId: UUID) {
        guard let pi = projects.firstIndex(where: { $0.id == projectId }),
              let mi = projects[pi].milestones.firstIndex(where: { $0.id == milestoneId })
        else { return }
        projects[pi].milestones[mi].isDone.toggle()
        save()
    }

    func togglePin(id: UUID) {
        guard let idx = projects.firstIndex(where: { $0.id == id }) else { return }
        projects[idx].isPinned.toggle()
        save()
    }

    // MARK: - Derived
    var pinned: [AIProject] { projects.filter { $0.isPinned } }
    var active: [AIProject] { projects.filter { $0.status == .active } }
    var totalMilestones: Int { projects.flatMap { $0.milestones }.count }
    var completedMilestones: Int { projects.flatMap { $0.milestones }.filter { $0.isDone }.count }
    var overallProgress: Double {
        guard totalMilestones > 0 else { return 0 }
        return Double(completedMilestones) / Double(totalMilestones)
    }

    // MARK: - Persistence
    private func save() {
        if let data = try? JSONEncoder().encode(projects) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let decoded = try? JSONDecoder().decode([AIProject].self, from: data)
        else { return }
        projects = decoded
    }
}
