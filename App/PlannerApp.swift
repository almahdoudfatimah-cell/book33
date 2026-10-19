import SwiftUI
#if canImport(RevenueCat)
import RevenueCat
#endif
#if canImport(RevenueCatUI)
import RevenueCatUI
#endif

@main
struct RaceTrianApp: App {
    @State private var authenticationErrorMessage: String?

    init() {
        PremiumStore.configureRevenueCat()

        // Set app-wide accent color
        let accentColor = Color(red: 1.00, green: 0.82, blue: 0.00)
        UIView.appearance().tintColor = UIColor(accentColor)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .appPageTheme()
                .tint(Color(red: 1.00, green: 0.82, blue: 0.00))
                .alert("Authentication Required", isPresented: Binding(
                    get: { authenticationErrorMessage != nil },
                    set: { if !$0 { authenticationErrorMessage = nil } }
                )) {
                    Button("OK", role: .cancel) {
                        authenticationErrorMessage = nil
                    }
                } message: {
                    Text(authenticationErrorMessage ?? "")
                }
                .onOpenURL { url in
                    #if canImport(RevenueCat)
                    if Purchases.shared.presentPaywall(from: url) {
                        return
                    }
                    #endif
                    handleURL(url)
                }
        }
    }
    
    // MARK: - Authentication

    @MainActor
    private func performAuthentication() async throws {
        guard AuthManager.shared.isSignedIn else {
            throw PaywallAuthenticationError.signInRequired
        }
    }

    // MARK: - URL Handling
    
    private func handleURL(_ url: URL) {
        print("🟣 App: Opening URL: \(url)")
        
        // Handle URL schemes here
        // Examples:
        // - Deep linking: yourapp://feature/detail?id=123
        // - Universal links: https://yourdomain.com/path
        // - Custom URL schemes
        
        // You can add your URL handling logic here
    }
}

private enum PaywallAuthenticationError: Error {
    case signInRequired
}

// MARK: - Root navigation

@MainActor
struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedAssessment = false
    @State private var entryStep: EntryStep = .onboarding

    var body: some View {
        ZStack {
            Theme.pageBackground
                .ignoresSafeArea()

            if hasCompletedAssessment {
                RootTabView()
            } else {
                switch entryStep {
                case .onboarding:
                    OnboardingView {
                        entryStep = .paywall
                    }
                case .paywall:
                    PaywallView(
                        onClose: { entryStep = .onboarding },
                        onCreateAccount: { entryStep = .signUp },
                        onSignIn: { entryStep = .signIn },
                        onPurchaseComplete: { entryStep = .signUp }
                    )
                case .signUp:
                    SignUpView(
                        onAuthenticated: finishEntry,
                        onShowSignIn: { entryStep = .signIn },
                        onBack: { entryStep = .paywall }
                    )
                case .signIn:
                    SignInView(
                        onAuthenticated: finishEntry,
                        onShowSignUp: { entryStep = .signUp },
                        onBack: { entryStep = .paywall }
                    )
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showSignIn)) { _ in
            entryStep = .signIn
        }
    }

    private func finishEntry() {
        hasCompletedAssessment = true
    }
}

private enum EntryStep {
    case onboarding
    case paywall
    case signUp
    case signIn
}

extension Notification.Name {
    static let showSignIn = Notification.Name("showSignIn")
}

// MARK: - Splash Slide Model
private struct SplashSlide {
    let icon: String
    let title: String
    let subtitle: String
    let body: String
}

// MARK: - SplashView (Slider)
struct SplashView: View {
    let onComplete: () -> Void

    private func close() {
        onComplete()
    }

    private let slides: [SplashSlide] = [
        SplashSlide(
            icon: "flag.checkered",
            title: "RaceTrian",
            subtitle: "Plan your training. Track your progress.",
            body: "Build a focused routine around workouts, goals, mood, notes, and race-day preparation."
        ),
        SplashSlide(
            icon: "calendar.badge.clock",
            title: "Smart Plans",
            subtitle: "Your day, organized around what matters",
            body: "Use AI-guided planning to shape workouts, projects, habits, and recovery into a clear daily flow."
        ),
        SplashSlide(
            icon: "chart.line.uptrend.xyaxis",
            title: "Better Insights",
            subtitle: "See the patterns behind your progress",
            body: "Review training, goals, mood, and performance trends so every week has a sharper direction."
        )
    ]

    @State private var currentIndex = 0

    var body: some View {
        ZStack {
            splashGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                SlidePageView(slide: slides[currentIndex])
                    .id(currentIndex)
                    .frame(maxWidth: 520, maxHeight: .infinity)
                    .padding(.horizontal, 28)
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                if value.translation.width < -40 {
                                    advanceSlide()
                                } else if value.translation.width > 40 {
                                    previousSlide()
                                }
                            }
                    )

                controls
                    .frame(maxWidth: 520)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 28)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var splashGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.85, green: 0.32, blue: 0.00),
                Color(red: 1.00, green: 0.55, blue: 0.05),
                Color(red: 1.00, green: 0.82, blue: 0.00)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var controls: some View {
        VStack(spacing: 14) {
            pageIndicators
                .padding(.bottom, 6)

            primaryButton
        }
    }

    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<slides.count, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        currentIndex = i
                    }
                } label: {
                    Capsule()
                        .fill(.white.opacity(i == currentIndex ? 1 : 0.4))
                        .frame(width: i == currentIndex ? 24 : 8, height: 8)
                        .frame(width: 36, height: 32)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var primaryButton: some View {
        Button {
            advanceSlideOrClose()
        } label: {
            Text(currentIndex == slides.count - 1 ? "Get Started" : "Next")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(currentIndex == slides.count - 1 ? Color.accentColor : .white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background {
                    if currentIndex == slides.count - 1 {
                        Capsule()
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
                    } else {
                        Capsule()
                            .fill(.white.opacity(0.2))
                            .overlay(Capsule().stroke(.white.opacity(0.4), lineWidth: 1))
                    }
                }
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func advanceSlide() {
        guard currentIndex < slides.count - 1 else { return }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            currentIndex += 1
        }
    }

    private func previousSlide() {
        guard currentIndex > 0 else { return }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            currentIndex -= 1
        }
    }

    private func advanceSlideOrClose() {
        if currentIndex == slides.count - 1 {
            close()
        } else {
            advanceSlide()
        }
    }
}

// MARK: - Single Slide Page
private struct SlidePageView: View {
    let slide: SplashSlide

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 24)

            ZStack {
                FlagBadge()
                    .fill(.white)
                    .frame(width: 98, height: 72)
                    .shadow(color: .black.opacity(0.10), radius: 10, y: 5)

                Image(systemName: slide.icon)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Theme.primary)
                    .offset(x: -5)
            }
            .padding(.bottom, 32)

            Text(slide.title)
                .font(.system(size: 38, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .padding(.bottom, 10)

            Text(slide.subtitle)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.92))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)
                .padding(.bottom, 14)

            Text(slide.body)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 12)

            Spacer(minLength: 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct FlagBadge: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let notchDepth = rect.width * 0.18
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - notchDepth, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
