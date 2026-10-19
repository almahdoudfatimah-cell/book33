import SwiftUI

struct FocusStyleSection: View {
    @ObservedObject var store: ProfileStore
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            sectionHeader(title: "Focus Style", subtitle: "How you work best", icon: "brain.head.profile")

            VStack(spacing: isIPad ? 12 : 8) {
                ForEach(FocusStyle.allCases, id: \.self) { style in
                    FocusStyleRow(style: style, isSelected: store.focusStyle == style) {
                        withAnimation(.spring(response: 0.3)) { store.focusStyle = style }
                    }
                }
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }
}

private struct FocusStyleRow: View {
    let style: FocusStyle
    let isSelected: Bool
    let onTap: () -> Void
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: isIPad ? 16 : 12) {
                Image(systemName: style.icon)
                    .font(.system(size: isIPad ? 18 : 15, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : Theme.primary)
                    .frame(width: isIPad ? 42 : 36, height: isIPad ? 42 : 36)
                    .background(
                        Circle().fill(isSelected ? Theme.primary : Theme.primary.opacity(0.1))
                    )

                VStack(alignment: .leading, spacing: isIPad ? 4 : 2) {
                    Text(style.rawValue)
                        .font(.system(size: isIPad ? 18 : 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    Text(style.description)
                        .font(.system(size: isIPad ? 14 : 12, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Theme.primary)
                        .font(.system(size: isIPad ? 20 : 18))
                }
            }
            .padding(isIPad ? 16 : 12)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 18 : 14, style: .continuous)
                    .fill(isSelected ? Theme.primary.opacity(0.08) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: isIPad ? 18 : 14, style: .continuous)
                    .strokeBorder(isSelected ? Theme.primary.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
