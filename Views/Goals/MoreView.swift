import SwiftUI

struct MoreTabView: View {
    @ObservedObject private var auth = AuthManager.shared
    @Environment(\.colorScheme) private var scheme
    
    public var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Section
                        profileCard
                        
                        // Settings Section
                        settingsCard
                        
                        // Sign Out
                        if auth.isSignedIn {
                            signOutButton
                        }
                        
                        Color.clear.frame(height: 24)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
        }.appPageTheme()
    }
    
    // MARK: - Profile Card
    
    private var profileCard: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Theme.heroGradient)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 4) {
                Text(auth.currentDisplayName)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                
                if let email = auth.currentEmail {
                    Text(email)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                }
                
                if auth.isGuest {
                    Text("Guest Account")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(Theme.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Theme.secondary.opacity(0.15), in: Capsule())
                        .padding(.top, 4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
    
    // MARK: - Settings Card
    
    private var settingsCard: some View {
        VStack(spacing: 0) {
            settingRow(icon: "bell.fill", title: "Notifications", color: Theme.primary)
            Divider().padding(.leading, 50)
            settingRow(icon: "lock.fill", title: "Privacy", color: Theme.secondary)
            Divider().padding(.leading, 50)
            settingRow(icon: "info.circle.fill", title: "About", color: Theme.accent)
        }
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
    
    private func settingRow(icon: String, title: String, color: Color) -> some View {
        Button {
            // Handle settings navigation
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(color.opacity(0.12))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(color)
                }
                
                Text(title)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Sign Out Button
    
    private var signOutButton: some View {
        Button {
            withAnimation {
                auth.signOut()
            }
        } label: {
            Text("Sign Out")
                .font(.system(.body, design: .rounded, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.red, in: Capsule())
        }
        .buttonStyle(PressScaleButtonStyle())
        .shadow(color: Color.red.opacity(0.3), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    MoreTabView()
}
