import SwiftUI

// MARK: - Paywall Presenter

/// A helper to present the paywall modally from anywhere in the app
struct PaywallPresenter: ViewModifier {
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    
    init(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil) {
        self._isPresented = isPresented
        self.onDismiss = onDismiss
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                PaywallView(onClose: {
                    isPresented = false
                    onDismiss?()
                })
            }
    }
}

extension View {
    /// Present the paywall as a sheet
    /// - Parameters:
    ///   - isPresented: Binding to control presentation
    ///   - onDismiss: Optional closure called when the paywall is dismissed
    func paywall(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(PaywallPresenter(isPresented: isPresented, onDismiss: onDismiss))
    }
}

// MARK: - Premium Gate View

/// A view that shows a "Go Premium" button when the user is not premium
struct PremiumGateView: View {
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showPaywall = false
    
    let title: String
    let message: String
    let icon: String
    
    init(
        title: String = "Premium Feature",
        message: String = "Upgrade to Premium to unlock this feature",
        icon: String = "star.fill"
    ) {
        self.title = title
        self.message = message
        self.icon = icon
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Theme.primary.opacity(0.12))
                    .frame(width: 100, height: 100)
                
                Image(systemName: icon)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(Theme.primary)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                
                Text(message)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Button {
                showPaywall = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                    Text("Go Premium")
                }
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: 280)
                .frame(height: 54)
                .background(Theme.heroGradient, in: Capsule())
                .shadow(color: Theme.primary.opacity(0.4), radius: 14, x: 0, y: 7)
            }
            .buttonStyle(PressScaleButtonStyle())
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .paywall(isPresented: $showPaywall)
    }
}

// MARK: - Premium Badge

/// A small badge to indicate premium features
struct PremiumBadge: View {
    var size: CGFloat = 16
    var color: Color = Theme.primary
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: size + 6, height: size + 6)
            
            Image(systemName: "crown.fill")
                .font(.system(size: size, weight: .bold))
                .foregroundStyle(color)
        }
    }
}

// MARK: - Feature Lock Overlay

/// Overlay that shows when a feature is locked for non-premium users
struct FeatureLockOverlay: View {
    let isLocked: Bool
    let onUnlock: () -> Void
    
    var body: some View {
        if isLocked {
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(Theme.primary)
                    
                    Text("Premium Feature")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    
                    Text("Unlock with Premium")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Button {
                        onUnlock()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "crown.fill")
                            Text("Upgrade Now")
                        }
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Theme.heroGradient, in: Capsule())
                        .shadow(color: Theme.primary.opacity(0.4), radius: 14, x: 0, y: 7)
                    }
                    .buttonStyle(PressScaleButtonStyle())
                }
                .padding(32)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                .padding(.horizontal, 40)
            }
            .transition(.opacity)
        }
    }
}

// MARK: - View Extensions

extension View {
    /// Lock a feature behind a premium gate
    /// - Parameter action: Action to perform when user taps unlock button
    func premiumGate(isLocked: Bool, onUnlock: @escaping () -> Void) -> some View {
        self.overlay {
            FeatureLockOverlay(isLocked: isLocked, onUnlock: onUnlock)
        }
    }
}

// MARK: - Preview

#Preview("Premium Gate") {
    PremiumGateView()
}

#Preview("Premium Badge") {
    VStack(spacing: 20) {
        PremiumBadge(size: 12)
        PremiumBadge(size: 16)
        PremiumBadge(size: 24)
        PremiumBadge(size: 32, color: .orange)
    }
    .padding()
}
