import SwiftUI

struct NotesView: View {
    @StateObject private var store = NotesStore.shared
    @Environment(\.colorScheme) private var scheme

    @State private var selectedCategory: NoteCategory = .all
    @State private var searchText = ""
    @State private var showNewNote = false
    @State private var editingNote: Note? = nil

    private var filtered: [Note] {
        store.filtered(by: selectedCategory, search: searchText)
    }

    private var pinned: [Note] { filtered.filter { $0.isPinned } }
    private var unpinned: [Note] { filtered.filter { !$0.isPinned } }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                VStack(spacing: 0) {
                    categoryStrip
                    notesList
                }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search notes…")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showNewNote = true } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showNewNote) {
                NoteEditorView(note: nil, store: store)
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $editingNote) { note in
                NoteEditorView(note: note, store: store)
                    .presentationDragIndicator(.visible)
            }
        }.appPageTheme()
    }

    // MARK: - Category strip
    private var categoryStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(NoteCategory.allCases, id: \.self) { cat in
                    CategoryPill(
                        category: cat,
                        isSelected: selectedCategory == cat,
                        count: cat == .all ? store.notes.count : store.notes.filter { $0.category == cat }.count
                    ) {
                        withAnimation(.spring(response: 0.3)) { selectedCategory = cat }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
        }
    }

    // MARK: - Notes list
    private var notesList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                if filtered.isEmpty {
                    EmptyNotesView(category: selectedCategory)
                        .padding(.top, 60)
                } else {
                    if !pinned.isEmpty {
                        sectionLabel("Pinned 📌")
                        notesGrid(pinned)
                    }
                    if !unpinned.isEmpty {
                        sectionLabel(pinned.isEmpty ? "Notes" : "Others")
                        notesGrid(unpinned)
                    }
                }
                Color.clear.frame(height: 24)
            }
            .padding(.horizontal, 18)
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .foregroundStyle(.secondary)
            .padding(.top, 10)
            .padding(.bottom, 6)
    }

    private func notesGrid(_ items: [Note]) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(items) { note in
                NoteCard(note: note, store: store) { editingNote = note }
            }
        }
    }
}

private struct CategoryPill: View {
    let category: NoteCategory
    let isSelected: Bool
    let count: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 5) {
                Text(category.emoji).font(.system(size: 13))
                Text(category.rawValue)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                if count > 0 && category != .all {
                    Text("\(count)")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(isSelected ? Color.white.opacity(0.3) : category.tint.opacity(0.2)))
                        .foregroundStyle(isSelected ? .white : category.tint)
                }
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(isSelected ? category.tint : Color.primary.opacity(0.07))
            )
        }
        .buttonStyle(.plain)
    }
}

private struct EmptyNotesView: View {
    let category: NoteCategory
    var body: some View {
        VStack(spacing: 14) {
            Text(category.emoji).font(.system(size: 48))
            Text("No \(category == .all ? "" : category.rawValue) notes yet")
                .font(.system(size: 18, weight: .bold, design: .rounded))
            Text("Tap ✏️ to capture your first thought.")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview { NotesView() }
