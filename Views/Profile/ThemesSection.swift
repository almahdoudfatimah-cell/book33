import SwiftUI

struct ThemesSection: View {
    @ObservedObject var store: ProfileStore
    @ObservedObject private var premium = PremiumStore.shared
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            sectionHeader(title: "App Theme", subtitle: "Personalise your look", icon: "paintbrush.fill")

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: isIPad ? 14 : 10), count: 3), spacing: isIPad ? 14 : 10) {
                ForEach(AppTheme.allCases) { theme in
                    ThemeTile(theme: theme,
                              isSelected: store.appTheme == theme,
                              isPremiumLocked: theme.isPremium && !premium.isActive) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            store.appTheme = theme
                        }
                    }
                }
            }

            if !premium.isActive {
                HStack(spacing: isIPad ? 8 : 6) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: isIPad ? 13 : 11, weight: .bold))
                        .foregroundStyle(Theme.accent)
                    Text("4 premium themes unlock with Premium")
                        .font(.system(size: isIPad ? 13 : 11, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, isIPad ? 4 : 2)
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }
}

private struct ThemeTile: View {
    let theme: AppTheme
    let isSelected: Bool
    let isPremiumLocked: Bool
    let onTap: () -> Void
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: isIPad ? 10 : 8) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: isIPad ? 20 : 16, style: .continuous)
                        .fill(theme.gradient)
                        .frame(height: isIPad ? 60 : 52)
                        .overlay(
                            RoundedRectangle(cornerRadius: isIPad ? 20 : 16, style: .continuous)
                                .stroke(isSelected ? Color.white : Color.clear, lineWidth: isIPad ? 3 : 2.5)
                        )
                        .shadow(color: theme.primary.opacity(0.35), radius: isIPad ? 10 : 8, x: 0, y: isIPad ? 5 : 4)

                    if isPremiumLocked {
                        Image(systemName: "crown.fill")
                            .font(.system(size: isIPad ? 13 : 11, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(isIPad ? 6 : 5)
                            .background(Color.black.opacity(0.3), in: Circle())
                            .padding(isIPad ? 6 : 5)
                    }

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: isIPad ? 20 : 18, weight: .bold))
                            .foregroundStyle(.white)
                            .shadow(radius: 4)
                            .padding(isIPad ? 6 : 5)
                    }
                }

                Text("\(theme.emoji) \(theme.rawValue)")
                    .font(.system(size: isIPad ? 13 : 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(isSelected ? Theme.primary : .secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .opacity(isPremiumLocked ? 0.72 : 1)
    }
}


#Preview { ThemesSection(store: .shared).padding() }
