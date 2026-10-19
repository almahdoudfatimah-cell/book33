import SwiftUI

struct LifeAreasSection: View {
    @ObservedObject var store: ProfileStore
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            sectionHeader(
                title: "Life Areas",
                subtitle: "Choose what to focus on",
                icon: "target"
            )
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: isIPad ? 14 : 10) {
                ForEach(LifeArea.allCases, id: \.self) { area in
                    LifeAreaChip(area: area, isSelected: store.selectedAreas.contains(area)) {
                        withAnimation(.spring(response: 0.3)) {
                            if store.selectedAreas.contains(area) {
                                if store.selectedAreas.count > 1 {
                                    store.selectedAreas.remove(area)
                                }
                            } else {
                                store.selectedAreas.insert(area)
                            }
                        }
                    }
                }
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }
}

private struct LifeAreaChip: View {
    let area: LifeArea
    let isSelected: Bool
    let onTap: () -> Void
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: isIPad ? 8 : 5) {
                Text(area.emoji)
                    .font(.system(size: isIPad ? 30 : 22))
                    .frame(width: isIPad ? 56 : 44, height: isIPad ? 56 : 44)
                    .background(
                        Circle().fill(isSelected ? area.tint.opacity(0.2) : Color.primary.opacity(0.06))
                    )
                    .overlay(
                        Circle().strokeBorder(isSelected ? area.tint : Color.clear, lineWidth: isIPad ? 2.5 : 2)
                    )
                Text(area.rawValue)
                    .font(.system(size: isIPad ? 13 : 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(isSelected ? area.tint : .secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

// Shared section header helper
func sectionHeader(title: String, subtitle: String, icon: String) -> some View {
    SectionHeaderView(title: title, subtitle: subtitle, icon: icon)
}

private struct SectionHeaderView: View {
    let title: String
    let subtitle: String
    let icon: String
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        HStack(spacing: isIPad ? 14 : 10) {
            Image(systemName: icon)
                .font(.system(size: isIPad ? 18 : 14, weight: .semibold))
                .foregroundStyle(Theme.primary)
                .frame(width: isIPad ? 42 : 30, height: isIPad ? 42 : 30)
                .background(Circle().fill(Theme.primary.opacity(0.12)))
            VStack(alignment: .leading, spacing: isIPad ? 3 : 1) {
                Text(title)
                    .font(.system(size: isIPad ? 24 : 16, weight: .bold, design: .rounded))
                Text(subtitle)
                    .font(.system(size: isIPad ? 18 : 12, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}
