import SwiftUI
import PhotosUI
#if canImport(UIKit)
import UIKit
#endif

struct NoteEditorView: View {
    let existingNote: Note?
    @ObservedObject var store: NotesStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    @State private var title: String = ""
    @State private var noteBody: String = ""
    @State private var selectedCategory: NoteCategory = .ideas
    @State private var selectedColor: NoteColor = .indigo
    #if canImport(UIKit)
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var attachedImage: UIImage? = nil
    #endif
    @State private var showColorPicker = false
    @FocusState private var bodyFocused: Bool

    init(note: Note?, store: NotesStore) {
        self.existingNote = note
        self.store = store
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                selectedColor.cardBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        #if canImport(UIKit)
                        // Attached image (if any)
                        if let img = attachedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .clipped()
                                .overlay(alignment: .topTrailing) {
                                    Button { withAnimation { attachedImage = nil } } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 22))
                                            .foregroundStyle(.white)
                                            .shadow(radius: 4)
                                    }
                                    .padding(10)
                                }
                        }
                        #endif

                        VStack(alignment: .leading, spacing: 16) {
                            // Category + colour bar
                            HStack(spacing: 10) {
                                categoryPicker
                                Spacer()
                                colorPaletteRow
                            }
                            .padding(.top, 16)

                            // Title
                            TextField("Title", text: $title)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.primary)

                            Divider().opacity(0.3)

                            // Body
                            ZStack(alignment: .topLeading) {
                                if noteBody.isEmpty {
                                    Text("Start writing…")
                                        .font(.system(size: 16, design: .rounded))
                                        .foregroundStyle(.secondary)
                                        .padding(.top, 2)
                                }
                                TextEditor(text: $noteBody)
                                    .font(.system(size: 16, design: .rounded))
                                    .scrollDisabled(true)
                                    .focused($bodyFocused)
                                    .frame(minHeight: 300)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .onAppear { loadExisting() }
        }.appPageTheme()
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") { dismiss() }
                .font(.system(size: 15, design: .rounded))
                .foregroundStyle(.secondary)
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            #if canImport(UIKit)
            // Photo picker
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Image(systemName: "photo")
                    .foregroundStyle(selectedColor.color)
            }
            .onChange(of: selectedPhoto) { _, item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self),
                       let ui = UIImage(data: data) {
                        attachedImage = ui
                    }
                }
            }
            #endif

            Button(action: save) {
                Text("Save")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(selectedColor.color))
            }
        }
    }

    // MARK: - Category picker
    private var categoryPicker: some View {
        Menu {
            ForEach(NoteCategory.allCases.filter { $0 != .all }, id: \.self) { cat in
                Button {
                    withAnimation { selectedCategory = cat }
                } label: {
                    Label("\(cat.emoji) \(cat.rawValue)", systemImage: "")
                }
            }
        } label: {
            HStack(spacing: 5) {
                Text(selectedCategory.emoji)
                Text(selectedCategory.rawValue)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundStyle(selectedCategory.tint)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(selectedCategory.tint.opacity(0.12)))
        }
    }

    // MARK: - Colour palette
    private var colorPaletteRow: some View {
        HStack(spacing: 7) {
            ForEach(NoteColor.allCases, id: \.self) { c in
                Button {
                    withAnimation(.spring(response: 0.25)) { selectedColor = c }
                } label: {
                    Circle()
                        .fill(c.color)
                        .frame(width: selectedColor == c ? 22 : 16,
                               height: selectedColor == c ? 22 : 16)
                        .overlay(
                            Circle().strokeBorder(Color.white.opacity(0.6),
                                                  lineWidth: selectedColor == c ? 2 : 0)
                        )
                        .shadow(color: c.color.opacity(0.4), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Helpers
    private func loadExisting() {
        guard let note = existingNote else {
            bodyFocused = true
            return
        }
        title = note.title
        noteBody = note.body
        selectedCategory = note.category
        selectedColor = note.color
    }

    private func save() {
        let trimTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimBody  = noteBody.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimTitle.isEmpty || !trimBody.isEmpty else { dismiss(); return }

        if var existing = existingNote {
            existing.title = trimTitle.isEmpty ? "Untitled" : trimTitle
            existing.body  = trimBody
            existing.category = selectedCategory
            existing.color = selectedColor
            store.update(existing)
        } else {
            let note = Note(
                title: trimTitle.isEmpty ? "Untitled" : trimTitle,
                body: trimBody,
                category: selectedCategory,
                color: selectedColor
            )
            store.add(note)
        }
        dismiss()
    }
}
