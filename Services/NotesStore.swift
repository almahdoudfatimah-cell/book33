import SwiftUI
import Combine

final class NotesStore: ObservableObject {
    @Published var notes: [Note] = []

    static let shared = NotesStore()
    private let storageKey = "ai_planner_notes"

    private init() {
        load()
        if notes.isEmpty { notes = SampleNotes.all }
    }

    // MARK: - CRUD
    func add(_ note: Note) {
        notes.insert(note, at: 0)
        save()
    }

    func update(_ note: Note) {
        guard let idx = notes.firstIndex(where: { $0.id == note.id }) else { return }
        var updated = note
        updated.updatedAt = Date()
        notes[idx] = updated
        save()
    }

    func delete(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        save()
    }

    func togglePin(_ note: Note) {
        guard let idx = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[idx].isPinned.toggle()
        // Bring pinned to front
        notes.sort { $0.isPinned && !$1.isPinned }
        save()
    }

    // MARK: - Filtered views
    func filtered(by category: NoteCategory, search: String) -> [Note] {
        var result = notes
        if category != .all {
            result = result.filter { $0.category == category }
        }
        if !search.isEmpty {
            let q = search.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(q) || $0.body.lowercased().contains(q)
            }
        }
        return result
    }

    // MARK: - Persistence
    private func save() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Note].self, from: data) else { return }
        notes = decoded
    }
}
