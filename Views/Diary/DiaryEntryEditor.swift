#if !os(watchOS)
import SwiftUI

struct DiaryEntryEditor: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = DiaryStore.shared

    // If nil → new entry
    var entry: DiaryEntry?

    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var mood: DiaryMood = .happy
    @State private var tags: Set<DiaryTag> = []
    @State private var weather: DiaryWeather? = nil
    @State private var isFavorite: Bool = false
    @State private var date: Date = Date()
    @State private var showDeleteAlert = false

    private var isEditing: Bool { entry != nil }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    dateWeatherRow
                    titleField
                    moodSection
                    bodySection
                    tagsSection
                }
                .padding(20)
                .padding(.bottom, 40)
            }
            .background(Theme.pageBackground)
            .navigationTitle(isEditing ? "Edit Entry" : "New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .alert("Delete Entry?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let e = entry { store.delete(e) }
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This entry will be permanently removed.")
            }
        }.appPageTheme()
        .onAppear { populateFields() }
    }

    // MARK: - Date & Weather
    private var dateWeatherRow: some View {
        HStack {
            DatePicker("", selection: $date, displayedComponents: [.date])
                .labelsHidden()
                .font(.system(size: 14, weight: .medium, design: .rounded))
            Spacer()
            weatherPicker
            Button {
                withAnimation { isFavorite.toggle() }
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundStyle(isFavorite ? Theme.primary : .secondary)
            }
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private var weatherPicker: some View {
        Menu {
            Button("None") { weather = nil }
            ForEach(DiaryWeather.allCases, id: \.self) { w in
                Button {
                    weather = w
                } label: {
                    Label(w.rawValue, systemImage: w.icon)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: weather?.icon ?? "cloud.sun")
                    .font(.system(size: 14))
                Text(weather?.rawValue ?? "Weather")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
        }
    }

    // MARK: - Title
    private var titleField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Title", systemImage: "pencil")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            TextField("What's today about?", text: $title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .submitLabel(.next)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Mood
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("How are you feeling?", systemImage: "face.smiling")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                ForEach(DiaryMood.allCases, id: \.self) { m in
                    moodButton(m)
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private func moodButton(_ m: DiaryMood) -> some View {
        let selected = mood == m
        return Button {
            withAnimation(.spring(response: 0.3)) { mood = m }
        } label: {
            VStack(spacing: 4) {
                Text(m.emoji)
                    .font(.system(size: selected ? 26 : 20))
                Text(m.rawValue)
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundStyle(selected ? m.color : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(selected ? m.color.opacity(0.18) : Color.clear, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selected ? m.color : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Body
    private var bodySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Your thoughts", systemImage: "text.alignleft")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            TextEditor(text: $bodyText)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .frame(minHeight: 200)
                .scrollContentBackground(.hidden)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Tags
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Tags", systemImage: "tag")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                ForEach(DiaryTag.allCases, id: \.self) { tag in
                    tagToggle(tag)
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private func tagToggle(_ tag: DiaryTag) -> some View {
        let on = tags.contains(tag)
        return Button {
            withAnimation {
                if on { tags.remove(tag) } else { tags.insert(tag) }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: tag.icon)
                    .font(.system(size: 11, weight: .bold))
                Text(tag.rawValue)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(on ? tag.color : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background(on ? tag.color.opacity(0.15) : Color(.secondarySystemFill), in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(on ? tag.color : Color.clear, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") { save() }
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.primary)
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        if isEditing {
            ToolbarItem(placement: .topBarLeading) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
    }

    // MARK: - Helpers
    private func populateFields() {
        guard let e = entry else { return }
        title = e.title
        bodyText = e.body
        mood = e.mood
        tags = Set(e.tags)
        weather = e.weather
        isFavorite = e.isFavorite
        date = e.date
    }

    private func save() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        var updated = DiaryEntry(
            date: date,
            title: trimmed,
            body: bodyText.trimmingCharacters(in: .whitespacesAndNewlines),
            mood: mood,
            tags: Array(tags),
            weather: weather,
            isFavorite: isFavorite
        )
        if let e = entry {
            updated.id = e.id
            store.update(updated)
        } else {
            store.add(updated)
        }
        dismiss()
    }
}
#endif


