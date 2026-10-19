import SwiftUI

struct DiaryEntryCard: View {
    let entry: DiaryEntry
    @StateObject private var store = DiaryStore.shared
    @Environment(\.colorScheme) private var scheme

    private var cardBg: Color {
        scheme == .dark
            ? Color(red: 0.18, green: 0.12, blue: 0.16)
            : .white
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            topRow
            bodyPreview
            bottomRow
        }
        .padding(16)
        .background(cardBg, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(scheme == .dark ? 0.3 : 0.07), radius: 8, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(entry.mood.color.opacity(0.25), lineWidth: 1)
        )
    }

    // MARK: - Top Row
    private var topRow: some View {
        HStack(alignment: .top) {
            moodBadge
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .lineLimit(1)
                Text(entry.date, style: .date)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 8) {
                if let w = entry.weather {
                    Image(systemName: w.icon)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        store.toggleFavorite(entry)
                    }
                } label: {
                    Image(systemName: entry.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundStyle(entry.isFavorite ? Theme.primary : .secondary)
                }
            }
        }
    }

    // MARK: - Mood Badge
    private var moodBadge: some View {
        Text(entry.mood.emoji)
            .font(.system(size: 28))
            .frame(width: 48, height: 48)
            .background(entry.mood.color.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Body Preview
    private var bodyPreview: some View {
        Text(entry.body)
            .font(.system(size: 14, weight: .regular, design: .rounded))
            .foregroundStyle(.secondary)
            .lineLimit(3)
    }

    // MARK: - Bottom Row
    private var bottomRow: some View {
        HStack(spacing: 6) {
            ForEach(entry.tags.prefix(3), id: \.self) { tag in
                tagChip(tag)
            }
            Spacer()
            Text("\(entry.wordCount) words")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.tertiary)
        }
    }

    private func tagChip(_ tag: DiaryTag) -> some View {
        HStack(spacing: 4) {
            Image(systemName: tag.icon)
                .font(.system(size: 9, weight: .bold))
            Text(tag.rawValue)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(tag.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(tag.color.opacity(0.12), in: Capsule())
    }
}
