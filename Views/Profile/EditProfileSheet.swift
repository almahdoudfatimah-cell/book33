import SwiftUI

struct EditProfileSheet: View {
    @ObservedObject var store: ProfileStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    @State private var name: String = ""
    @State private var tagline: String = ""
    @State private var selectedEmoji: String = "🧑‍💻"

    private let avatarOptions = ["🧑‍💻","🧑‍🎨","🧑‍🔬","🧑‍🏫","🧑‍⚕️","🧑‍🚀","🦸","🧙","🧑‍🎤","🧑‍🏋️","🧑‍🍳","🧑‍🌾"]

    var body: some View {
        ZStack {
            PaperBackground()
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text("Edit Profile")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.secondary)
                    }
                }

                // Avatar picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Avatar").font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(.secondary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(avatarOptions, id: \.self) { emoji in
                                Button { selectedEmoji = emoji } label: {
                                    Text(emoji)
                                        .font(.system(size: 28))
                                        .frame(width: 52, height: 52)
                                        .background(
                                            Circle().fill(selectedEmoji == emoji
                                                ? Theme.primary.opacity(0.2)
                                                : Color.primary.opacity(0.07))
                                        )
                                        .overlay(
                                            Circle().strokeBorder(selectedEmoji == emoji
                                                ? Theme.primary : Color.clear, lineWidth: 2)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }

                // Name field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name").font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(.secondary)
                    TextField("Your name", text: $name)
                        .font(.system(size: 16, design: .rounded))
                        .padding(12)
                        .glassCard(cornerRadius: 14)
                }

                // Tagline field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tagline").font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(.secondary)
                    TextField("A short motto or goal…", text: $tagline)
                        .font(.system(size: 16, design: .rounded))
                        .padding(12)
                        .glassCard(cornerRadius: 14)
                }

                Spacer()

                Button {
                    store.name = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? store.name : name
                    store.tagline = tagline.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? store.tagline : tagline
                    store.avatarEmoji = selectedEmoji
                    dismiss()
                } label: {
                    Text("Save Changes")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Theme.heroGradient)
                        )
                        .shadow(color: Theme.primary.opacity(0.3), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .onAppear {
            name = store.name
            tagline = store.tagline
            selectedEmoji = store.avatarEmoji
        }
    }
}
