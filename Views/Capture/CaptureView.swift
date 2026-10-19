import SwiftUI

struct CaptureView: View {
    @StateObject private var store = CaptureStore.shared
    @State private var input: String = ""
    @FocusState private var inputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                inputCard
                    .padding(16)

                if store.items.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("Inbox")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(store.inboxCount)")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Theme.primary, in: Capsule())
                }
            }
        }.appPageTheme()
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Capture a thought…", text: $input, axis: .vertical)
                .focused($inputFocused)
                .font(.system(.body, design: .rounded))
                .lineLimit(2...6)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(red: 0.96, green: 0.96, blue: 0.96))
                )

            Button(action: submit) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Theme.heroGradient, in: Capsule())
                .opacity(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
            }
            .buttonStyle(.plain)
            .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
        )
    }

    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(store.items) { item in
                    CaptureRow(item: item)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Spacer(minLength: 40)
            Image(systemName: "tray")
                .font(.system(size: 44))
                .foregroundStyle(Theme.primary.opacity(0.5))
            Text("Your inbox is empty")
                .font(.system(.headline, design: .rounded, weight: .bold))
            Text("Capture any thought, idea, or task here. Process them later.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
            Spacer()
        }
    }

    private func submit() {
        store.add(input)
        input = ""
        inputFocused = false
    }
}

private struct CaptureRow: View {
    let item: CaptureItem
    @StateObject private var store = CaptureStore.shared

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button { store.markProcessed(item) } label: {
                Image(systemName: item.isProcessed ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(item.isProcessed ? Theme.primary : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.text)
                    .font(.system(.subheadline, design: .rounded))
                    .strikethrough(item.isProcessed)
                    .foregroundStyle(item.isProcessed ? .secondary : .primary)
                Text(item.createdDate, style: .relative)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
        )
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) { store.delete(item) } label: { Label("Delete", systemImage: "trash") }
        }
    }
}

#Preview { CaptureView() }
