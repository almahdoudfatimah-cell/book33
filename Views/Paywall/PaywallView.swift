import SwiftUI
#if canImport(RevenueCat)
import RevenueCat
#endif
#if canImport(RevenueCatUI)
import RevenueCatUI
#endif
#if canImport(RevenueCat)
typealias AppOfferings = Offerings
#else
typealias AppOfferings = MockOfferings
#endif

struct PaywallView: View {
    var onClose: (() -> Void)?
    var onCreateAccount: (() -> Void)?
    var onSignIn: (() -> Void)?
    var onPurchaseComplete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var premium = PremiumStore.shared
    @ObservedObject private var auth = AuthManager.shared
    @State private var selectedPlanID: String = "freeTrial"
    @State private var offerings: AppOfferings?
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var authenticationErrorMessage: String?

    #if DEBUG
    @State private var showDebug = false
    @State private var debugText: String = ""
    #endif

    @State private var offeringsLoadFailed = false

    /// Local struct to represent display plans including the free trial option
    struct DisplayPlan: Identifiable, Equatable {
        let id: String
        let title: String
        let subtitle: String
        let price: String
        let period: String
        let savingsBadge: String?
        let linkedPremiumPlan: PremiumPlan?
        
        static func == (lhs: DisplayPlan, rhs: DisplayPlan) -> Bool {
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.subtitle == rhs.subtitle &&
            lhs.price == rhs.price &&
            lhs.period == rhs.period &&
            lhs.savingsBadge == rhs.savingsBadge &&
            lhs.linkedPremiumPlan?.rawValue == rhs.linkedPremiumPlan?.rawValue
        }

        static let freeTrial = DisplayPlan(
            id: "freeTrial",
            title: "Free Trial",
            subtitle: "Start with one week free, then $18 per week.",
            price: "Free",
            period: "",
            savingsBadge: "1 Week Free",
            linkedPremiumPlan: nil
        )
        static let weekly = DisplayPlan(
            id: PremiumPlan.weekly.id,
            title: "Perminium Weekly",
            subtitle: "$18 per week",
            price: "$18.00",
            period: "/week",
            savingsBadge: nil,
            linkedPremiumPlan: .weekly
        )
        static let yearly = DisplayPlan(
            id: PremiumPlan.yearly.id,
            title: "Perminium Yearly",
            subtitle: "$117.99 per year - Best Value",
            price: "$117.99",
            period: "/year",
            savingsBadge: "Best Value",
            linkedPremiumPlan: .yearly
        )
    }

    /// Available plans shown during upgrade.
    private var displayPlans: [DisplayPlan] = [
        .freeTrial,
        .weekly,
        .yearly
    ]

    init(
        onClose: (() -> Void)? = nil,
        onCreateAccount: (() -> Void)? = nil,
        onSignIn: (() -> Void)? = nil,
        onPurchaseComplete: (() -> Void)? = nil
    ) {
        self.onClose = onClose
        self.onCreateAccount = onCreateAccount
        self.onSignIn = onSignIn
        self.onPurchaseComplete = onPurchaseComplete
    }

    var body: some View {
        ZStack {
            PaperBackground()

            VStack(spacing: 0) {
                topBar

                if isLoading {
                    Spacer()
                    ProgressView().tint(Theme.primary)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 22) {
                            heroSection
                            Text("One week free, then $18/week. You can switch to yearly at any time.")
                                .font(.system(.footnote, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 22)
                            valueStrip
                            featuresList
                            plansSection
                            if offeringsLoadFailed {
                                VStack(spacing: 8) {
                                    Text("We couldn’t load purchase options.")
                                        .font(.system(.footnote, design: .rounded))
                                        .foregroundStyle(.secondary)
                                    Button {
                                        Task {
                                            #if canImport(RevenueCat)
                                            do {
                                                offeringsLoadFailed = false
                                                offerings = try await Purchases.shared.offerings()
                                                if offerings?.current == nil && (offerings?.all.isEmpty ?? true) {
                                                    offeringsLoadFailed = true
                                                }
                                            } catch {
                                                offeringsLoadFailed = true
                                            }
                                            #endif
                                        }
                                    } label: {
                                        Label("Try Again", systemImage: "arrow.clockwise")
                                            .font(.system(.caption, design: .rounded, weight: .semibold))
                                    }
                                    .buttonStyle(PressScaleButtonStyle())
                                }
                                .padding(.vertical, 6)
                            }
                            purchaseButton
                            accountActions
                            smallPrint
                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, 28)
                    }
                }
            }
        }
        .overlay {
            if showSuccess { successOverlay }
        }
        .interactiveDismissDisabled(premium.isPurchasing)
        .alert("Purchase Failed", isPresented: Binding(
            get: { premium.purchaseError != nil },
            set: { if !$0 { premium.purchaseError = nil } }
        )) {
            Button("OK", role: .cancel) { premium.purchaseError = nil }
        } message: {
            Text(premium.purchaseError ?? "")
        }
        .alert("Authentication Required", isPresented: Binding(
            get: { authenticationErrorMessage != nil },
            set: { if !$0 { authenticationErrorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { authenticationErrorMessage = nil }
        } message: {
            Text(authenticationErrorMessage ?? "")
        }
        #if DEBUG
        .sheet(isPresented: $showDebug) {
            NavigationStack {
                ScrollView { Text(debugText).font(.system(.footnote, design: .monospaced)).padding() }
                    .navigationTitle("Paywall Debug")
                    .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Close") { showDebug = false } } }
            }
        }
        #endif
        .task {
            #if canImport(RevenueCat)
            do {
                offeringsLoadFailed = false
                offerings = try await Purchases.shared.offerings()
                if offerings?.current == nil && (offerings?.all.isEmpty ?? true) {
                    offeringsLoadFailed = true
                }
            } catch {
                offeringsLoadFailed = true
            }
            #else
            // Mock delay for testing
            try? await Task.sleep(nanoseconds: 500_000_000)
            offerings = MockOfferings()
            offeringsLoadFailed = false
            #endif
        }
    }

    private func restorePurchases() async {
        guard auth.isSignedIn else {
            print("Authentication failed, cancel restore flow")
            authenticationErrorMessage = "Please sign in before restoring purchases."
            return
        }

        print("Authentication complete, presenting restore flow")
        await premium.restore()
    }

    private func close() {
        if let onClose {
            onClose()
        } else {
            dismiss()
        }
    }

    // MARK: - Price helper

    private func price(for displayPlan: DisplayPlan) -> String {
        if displayPlan.id == "freeTrial" {
            return displayPlan.price
        }
        let selectedOffering = PremiumStore.revenueCatOfferingID.flatMap { offerings?.all[$0] } ?? offerings?.current
        guard let offering = selectedOffering else { return displayPlan.price }
        #if canImport(RevenueCat)
        guard let plan = displayPlan.linkedPremiumPlan else { return displayPlan.price }
        let pkgType: PackageType = {
            switch plan {
            case .weekly:  return .weekly
            case .monthly: return .monthly
            case .yearly:  return .annual
            }
        }()
        return offering.availablePackages
            .first {
                $0.identifier == plan.packageIdentifier ||
                $0.storeProduct.productIdentifier == plan.productIdentifier ||
                $0.packageType == pkgType
            }?
            .localizedPriceString ?? displayPlan.price
        #else
        return displayPlan.price
        #endif
    }
    
    #if DEBUG
    private func loadDebugInfo() async {
        #if canImport(RevenueCat)
        var lines: [String] = []
        lines.append("— RevenueCat Debug —")
        do {
            let off = try await Purchases.shared.offerings()
            if let current = off.current {
                lines.append("Current offering: \(current.identifier)")
                for pkg in current.availablePackages {
                    lines.append(" • pkg id=\(pkg.identifier), type=\(pkg.packageType), product=\(pkg.storeProduct.productIdentifier), price=\(pkg.localizedPriceString)")
                }
            } else {
                lines.append("No current offering")
            }
            let info = try await Purchases.shared.customerInfo()
            let activeKeys = Array(info.entitlements.active.keys)
            lines.append("Active entitlements: \(activeKeys)")
            lines.append("Named entitlement active (\(PremiumStore.entitlementID)): \(info.entitlements.all[PremiumStore.entitlementID]?.isActive == true)")
        } catch {
            lines.append("Error: \(error.localizedDescription)")
        }
        await MainActor.run {
            debugText = lines.joined(separator: "\n")
            showDebug = true
        }
        #else
        await MainActor.run {
            debugText = "StoreKit (no RevenueCat) — no debug info available here."
            showDebug = true
        }
        #endif
    }
    #endif

    // MARK: - Sections

    private var topBar: some View {
        HStack {
            Button { close() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.secondary)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .buttonStyle(PressScaleButtonStyle())
            .contentShape(Rectangle())
            Spacer()
            Button("Restore") {
                Task { await restorePurchases() }
            }
            .font(.system(.subheadline, design: .rounded, weight: .semibold))
            .foregroundStyle(.secondary)
            .buttonStyle(PressScaleButtonStyle())
            .contentShape(Rectangle())
            .padding(.vertical, 8)
            .padding(.leading, 16)
            #if DEBUG
            Button("Debug") { Task { await loadDebugInfo() } }
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(Theme.accent)
                .buttonStyle(PressScaleButtonStyle())
                .contentShape(Rectangle())
                .padding(.vertical, 8)
                .padding(.leading, 8)
            #endif
            if !auth.isSignedIn {
                Text("Sign in to restore purchases")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 4)
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Theme.heroGradient)
                    .frame(width: 108, height: 108)
                    .rotationEffect(.degrees(-5))
                    .shadow(color: Theme.primary.opacity(0.32), radius: 18, x: 0, y: 12)
                VStack(spacing: 4) {
                    Image(systemName: "figure.run.circle.fill")
                        .font(.system(size: 42, weight: .bold))
                    Text("PRO")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                }
                .foregroundStyle(.white)
            }
            .padding(.top, 8)

            RaceTrianLogo(size: 34, stacked: false)
                .multilineTextAlignment(.center)

            VStack(spacing: 6) {
                Text("Train smarter with Premium")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Unlimited coaching, sharper planning, and race-ready tracking in one focused training hub.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 18)
        }
    }

    private var valueStrip: some View {
        HStack(spacing: 10) {
            PaywallStatPill(title: "Coach", value: "Unlimited", color: Theme.primary)
            PaywallStatPill(title: "Plans", value: "AI-built", color: Theme.secondary)
            PaywallStatPill(title: "Reports", value: "Weekly", color: Theme.accent)
        }
        .padding(6)
        .glassCard(cornerRadius: 18, tint: Theme.accent)
    }

    private var featuresList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Everything included")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .padding(.horizontal, 2)

            PaywallFeatureRow(icon: "infinity",                   color: Theme.primary,
                              title: "Unlimited AI Coach",        subtitle: "Ask for workouts, pacing, recovery, and habit support")
            PaywallFeatureRow(icon: "calendar.badge.clock",       color: Theme.secondary,
                              title: "Adaptive Training Plans",   subtitle: "Build daily and weekly plans around your real schedule")
            PaywallFeatureRow(icon: "chart.line.uptrend.xyaxis",  color: Theme.accent,
                              title: "Performance Insights",      subtitle: "See trends across training, mood, notes, and goals")
            PaywallFeatureRow(icon: "flag.checkered",             color: Theme.rose,
                              title: "Race-Day Readiness",        subtitle: "Track events, milestones, and prep blocks clearly")
        }
    }

    private var plansSection: some View {
        VStack(spacing: 12) {
            ForEach(displayPlans) { plan in
                PlanCard(
                    plan: plan,
                    price: price(for: plan),
                    isSelected: selectedPlanID == plan.id
                ) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedPlanID = plan.id
                    }
                }
            }
        }
        .padding(.top, 4)
    }

    private var purchaseButton: some View {
        Button {
            Task {
                // Determine plan to purchase:
                // If free trial selected, purchase weekly plan by default after trial
                let planToPurchase: PremiumPlan
                if selectedPlanID == "freeTrial" {
                    planToPurchase = .weekly
                } else if selectedPlanID == PremiumPlan.weekly.id {
                    planToPurchase = .weekly
                } else if selectedPlanID == PremiumPlan.yearly.id {
                    planToPurchase = .yearly
                } else {
                    planToPurchase = .weekly // fallback
                }
                await premium.purchase(planToPurchase)
                if premium.isActive {
                    showSuccess = true
                    try? await Task.sleep(nanoseconds: 900_000_000)
                    if let onPurchaseComplete {
                        onPurchaseComplete()
                    } else {
                        close()
                    }
                }
            }
        } label: {
            ZStack {
                if premium.isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    VStack(spacing: 2) {
                        Text("Start Premium")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                        if let selectedPlan = displayPlans.first(where: { $0.id == selectedPlanID }) {
                            Text("\(price(for: selectedPlan)) \(selectedPlan.period)")
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                                .opacity(0.9)
                        }
                    }
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(Theme.heroGradient, in: Capsule())
            .shadow(color: Theme.primary.opacity(0.5), radius: 18, x: 0, y: 10)
        }
        .disabled(premium.isPurchasing)
        .buttonStyle(PressScaleButtonStyle())
        .contentShape(Rectangle())
        .padding(.top, 4)
    }

    @ViewBuilder
    private var accountActions: some View {
        if onCreateAccount != nil || onSignIn != nil {
            VStack(spacing: 12) {
                Button("Create Account") {
                    onCreateAccount?()
                }
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(Theme.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Theme.primary.opacity(0.12), in: Capsule())
                .buttonStyle(PressScaleButtonStyle())

                Button("Already have an account? Sign In") {
                    onSignIn?()
                }
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(.secondary)
                .buttonStyle(PressScaleButtonStyle())
            }
        }
    }

    private var smallPrint: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: "lock.fill").font(.caption2)
                Text("Secure payment via Apple")
                    .font(.system(.caption, design: .rounded))
            }
            .foregroundStyle(.secondary)

            Text("Auto-renews until cancelled. Manage or cancel anytime in Apple Settings.")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 14) {
                Text("Terms").underline()
                Text("Privacy").underline()
            }
            .font(.system(.caption2, design: .rounded))
            .foregroundStyle(.secondary)
            .padding(.top, 4)
        }
        .padding(.top, 6)
    }

    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack(spacing: 16) {
                ZStack {
                    Circle().fill(Theme.heroGradient).frame(width: 90, height: 90)
                    Image(systemName: "checkmark")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(.white)
                }
                Text("You're Premium!")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                Text("Welcome to the full experience.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(36)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .padding(.horizontal, 40)
        }
        .transition(.opacity)
    }
}

// MARK: - Subviews

private struct PaywallStatPill: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .heavy))
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
            Text(title)
                .font(.system(.caption2, design: .rounded, weight: .semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct PaywallFeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color.opacity(0.18))
                    .frame(width: 46, height: 46)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(.subheadline, design: .rounded, weight: .semibold))
                Text(subtitle).font(.system(.caption, design: .rounded)).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Theme.primary)
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

private struct PlanCard: View {
    let plan: PaywallView.DisplayPlan
    let price: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Theme.primary : Color.secondary.opacity(0.4), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle().fill(Theme.primary).frame(width: 14, height: 14)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(plan.title)
                            .font(.system(.headline, design: .rounded, weight: .bold))
                        if let badge = plan.savingsBadge {
                            Text(badge)
                                .font(.system(.caption2, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Theme.accent, in: Capsule())
                        }
                    }
                    Text(plan.subtitle)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 0) {
                    Text(price)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    Text(plan.period)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? Theme.primary : Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? Theme.primary.opacity(0.25) : .clear, radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview { PaywallView() }

// MARK: - Mock Types (for when RevenueCat is not available)

#if !canImport(RevenueCat)
struct MockOfferings {
    var current: MockOffering? { MockOffering() }
    var all: [String: MockOffering] { [:] }
}

struct MockOffering {
    var availablePackages: [MockPackage] { [] }
}

struct MockPackage {
    var packageType: String { "" }
    var localizedPriceString: String { "" }
}
#endif

