import SwiftUI

struct PromptChip: View {
    let prompt: CoachPrompt
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(prompt.emoji)
                    .font(.system(size: 20))
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(prompt.tint.opacity(0.15)))

                Text(prompt.label)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 62)
            .glassCard(cornerRadius: 18)
        }
        .buttonStyle(.plain)
    }
}
