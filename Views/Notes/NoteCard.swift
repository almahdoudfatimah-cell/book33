import SwiftUI

struct NoteCard: View {
    let note: Note
    @ObservedObject var store: NotesStore
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                cardHeader
                Text(note.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                Text(note.body)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 4)
                cardFooter
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 160, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(note.color.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(note.color.color.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: note.color.color.opacity(0.12), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .contextMenu { contextMenuItems }
    }

    // MARK: - Sub-views
    private var cardHeader: some View {
        HStack {
            Text(note.category.emoji)
                .font(.system(size: 18))
                .frame(width: 32, height: 32)
                .background(Circle().fill(note.color.color.opacity(0.18)))

            Spacer()

            if note.isPinned {
                Image(systemName: "pin.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(note.color.color)
                    .rotationEffect(.degrees(45))
            }

            Circle()
                .fill(note.color.color)
                .frame(width: 10, height: 10)
        }
    }

    private var cardFooter: some View {
        HStack {
            Text(relativeDate(note.updatedAt))
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(note.color.color.opacity(0.7))
            Spacer()
            if !note.tags.isEmpty {
                Text("#\(note.tags[0])")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(note.color.color)
            }
        }
    }

    @ViewBuilder
    private var contextMenuItems: some View {
        Button {
            withAnimation { store.togglePin(note) }
        } label: {
            Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.slash" : "pin")
        }
        Button(role: .destructive) {
            withAnimation { store.delete(note) }
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }

    private func relativeDate(_ date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "Today" }
        if cal.isDateInYesterday(date) { return "Yesterday" }
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM d"
        return fmt.string(from: date)
    }
}
