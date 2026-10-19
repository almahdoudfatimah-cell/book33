import SwiftUI
import StoreKit
#if canImport(RevenueCat)
import RevenueCat
#endif
import Combine

final class PremiumStore: ObservableObject {
    private var updatesTask: Task<Void, Never>?

    static let shared = PremiumStore()

    static let entitlementID = "RaceTrian Pro"
    static let revenueCatPublicAPIKey = "appl_VctVBGhshxVGvZgSrJMddtaxSPP"
    static let revenueCatOfferingID: String? = nil
    static let revenueCatAppGroupSuiteName: String? = nil

    private static var revenueCatAppUserID: String? {
        let identifier = UserDefaults.standard.string(forKey: "auth.userIdentifier") ?? ""
        return identifier.isEmpty ? nil : identifier
    }

    @AppStorage("premium.isActive")    private(set) var isActiveStorage: Bool = false
    @AppStorage("premium.plan")        private var planRaw: String = ""
    @AppStorage("coach.dailyCount")    private var dailyCount: Int = 0
    @AppStorage("coach.dailyDate")     private var dailyDateString: String = ""

    @Published var isPurchasing: Bool = false
    @Published var purchaseError: String?

    /// Free users get this many AI Coach messages per day.
    let freeDailyLimit: Int = 5

    var isActive: Bool { isActiveStorage }

    var currentPlan: PremiumPlan? {
        PremiumPlan(rawValue: planRaw)
    }

    private init() {
        #if canImport(RevenueCat)
        // Ensure RevenueCat is configured as early as possible
        // (safe to call multiple times; configure is idempotent in practice when key matches)
        Self.configureRevenueCat()
        #endif

        // Listen for subscription status changes from AppDelegate
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("subscriptionStatusChanged"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            if let isPremiumActive = notification.userInfo?["isPremiumActive"] as? Bool {
                print("🟠 PremiumStore: Received subscription status update - isPremium: \(isPremiumActive)")
                self.isActiveStorage = isPremiumActive
                self.objectWillChange.send()
            }
        }
        startListeningForTransactions()
    }

    static func configureRevenueCat() {
        #if canImport(RevenueCat)
        Purchases.logLevel = .debug
        var configurationBuilder = Configuration.Builder(withAPIKey: revenueCatPublicAPIKey)
        if let appUserID = revenueCatAppUserID {
            configurationBuilder = configurationBuilder.with(appUserID: appUserID)
        }
        if let suiteName = revenueCatAppGroupSuiteName,
           let userDefaults = UserDefaults(suiteName: suiteName) {
            configurationBuilder = configurationBuilder.with(userDefaults: userDefaults)
        }
        Purchases.configure(with: configurationBuilder.build())
        Purchases.shared.delegate = shared
        #endif
    }

    func checkEntitlement() async {
        #if canImport(RevenueCat)
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            // First, try the configured entitlement ID exactly as provided
            let namedActive = customerInfo.entitlements.all[Self.entitlementID]?.isActive == true

            // If not active under the named key, fall back to any active entitlement
            let anyActive = namedActive || customerInfo.entitlements.active.isEmpty == false

            await MainActor.run {
                isActiveStorage = anyActive
                objectWillChange.send()
            }
        } catch {
            print("RevenueCat error: \(error)")
        }
        #else
        // Mock implementation - for testing, always return current state
        await MainActor.run {
            objectWillChange.send()
        }
        #endif
    }

    func refreshFromRevenueCat() {
        Task { await checkEntitlement() }
    }

    @MainActor
    func purchase(_ plan: PremiumPlan) async {
        purchaseError = nil
        isPurchasing = true
        defer { isPurchasing = false }
        
        #if canImport(RevenueCat)
        do {
            let offerings = try await Purchases.shared.offerings()
            let offering = Self.revenueCatOfferingID.flatMap { offerings.all[$0] } ?? offerings.current
            guard let offering else {
                purchaseError = "No offerings available. Please try again later."
                return
            }
            let pkgType: PackageType = {
                switch plan {
                case .weekly:  return .weekly
                case .monthly: return .monthly
                case .yearly:  return .annual
                }
            }()
            guard let package = offering.availablePackages.first(where: {
                $0.identifier == plan.packageIdentifier ||
                $0.storeProduct.productIdentifier == plan.productIdentifier ||
                $0.packageType == pkgType
            }) else {
                purchaseError = "Product not found. Please check your RevenueCat dashboard."
                return
            }
            let result = try await Purchases.shared.purchase(package: package)
            guard !result.userCancelled else { return }
            let namedActive = result.customerInfo.entitlements.all[Self.entitlementID]?.isActive == true
            let anyActive = namedActive || result.customerInfo.entitlements.active.isEmpty == false
            isActiveStorage = anyActive
            if isActiveStorage { planRaw = plan.rawValue }
            objectWillChange.send()
        } catch {
            purchaseError = error.localizedDescription
        }
        #else
        do {
            let products = try await StoreKit.Product.products(for: [plan.productIdentifier])
            guard let product = products.first else {
                purchaseError = "This subscription is unavailable. Please check the StoreKit configuration."
                return
            }

            let result = try await product.purchase()
            switch result {
            case .success(let verificationResult):
                await handle(transactionResult: verificationResult)
                // UI will update via applyEntitlement on MainActor
            case .pending:
                purchaseError = "Your purchase is pending approval."
            case .userCancelled:
                return
            @unknown default:
                purchaseError = "The purchase could not be completed."
            }
        } catch {
            purchaseError = error.localizedDescription
        }
        #endif
    }

    @MainActor
    func restore() async {
        purchaseError = nil
        isPurchasing = true
        defer { isPurchasing = false }
        
        #if canImport(RevenueCat)
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            let namedActive = customerInfo.entitlements.all[Self.entitlementID]?.isActive == true
            let anyActive = namedActive || customerInfo.entitlements.active.isEmpty == false
            isActiveStorage = anyActive
            if !isActiveStorage { purchaseError = "No previous purchases found." }
            objectWillChange.send()
        } catch {
            purchaseError = error.localizedDescription
        }
        #else
        do {
            try await AppStore.sync()
            var restoredPlan: PremiumPlan?

            for await result in StoreKit.Transaction.currentEntitlements {
                guard case .verified(let transaction) = result,
                      transaction.revocationDate == nil,
                      transaction.expirationDate.map({ $0 > Date() }) ?? true else {
                    continue
                }
                restoredPlan = PremiumPlan.allCases.first {
                    $0.productIdentifier == transaction.productID
                }
                if restoredPlan != nil { break }
            }

            startListeningForTransactions()

            isActiveStorage = restoredPlan != nil
            planRaw = restoredPlan?.rawValue ?? ""
            if !isActiveStorage {
                purchaseError = "No previous purchases found."
            }
            objectWillChange.send()
        } catch {
            purchaseError = error.localizedDescription
        }
        #endif
    }

    @MainActor
    func cancelLocally() {
        isActiveStorage = false
        planRaw = ""
        objectWillChange.send()
    }

    // MARK: - Free-tier coach quota

    /// Returns true if the user is allowed to send another coach message.
    /// Increments the daily counter on success.
    @discardableResult
    func consumeCoachMessage() -> Bool {
        if isActive { return true }
        rolloverIfNeeded()
        if dailyCount < freeDailyLimit {
            dailyCount += 1
            return true
        }
        return false
    }

    var coachRemainingToday: Int {
        if isActive { return Int.max }
        let today = Self.dayKey(Date())
        let effectiveCount = dailyDateString == today ? dailyCount : 0
        return max(0, freeDailyLimit - effectiveCount)
    }

    private func rolloverIfNeeded() {
        let today = Self.dayKey(Date())
        if dailyDateString != today {
            dailyDateString = today
            dailyCount = 0
        }
    }

    private static func dayKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    // MARK: - StoreKit transaction updates (non-RevenueCat builds)
    private func startListeningForTransactions() {
        #if !canImport(RevenueCat)
        // Start a single task to listen for transaction updates for the lifetime of the app
        if updatesTask == nil {
            updatesTask = Task.detached(priority: .background) { [weak self] in
                for await update in StoreKit.Transaction.updates {
                    guard let self else { continue }
                    await self.handle(transactionResult: update)
                }
            }
        }
        #endif
    }

    @MainActor
    private func applyEntitlement(from transaction: StoreKit.Transaction) {
        // Update local entitlement state based on the purchased product
        if let plan = PremiumPlan.allCases.first(where: { $0.productIdentifier == transaction.productID }) {
            isActiveStorage = true
            planRaw = plan.rawValue
        } else {
            // If we don't recognize the product ID, still mark premium active
            isActiveStorage = true
        }
        objectWillChange.send()
    }

    private func handle(transactionResult result: StoreKit.VerificationResult<StoreKit.Transaction>) async {
        switch result {
        case .verified(let transaction):
            await MainActor.run { self.applyEntitlement(from: transaction) }
            await transaction.finish()
        case .unverified(_, _):
            // Ignore or log unverified transactions
            break
        }
    }

    deinit {
        updatesTask?.cancel()
    }
}

enum PremiumPlan: String, CaseIterable, Identifiable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"

    static let allCases: [PremiumPlan] = [.weekly, .yearly]

    var id: String { rawValue }

    var title: String {
        switch self {
        case .weekly:  return "Weekly"
        case .monthly: return "Monthly"
        case .yearly:  return "Yearly"
        }
    }

    var packageIdentifier: String {
        switch self {
        case .weekly:  return "$rc_weekly"
        case .monthly: return "$rc_monthly"
        case .yearly:  return "$rc_annual"
        }
    }

    var productIdentifier: String {
        switch self {
        case .weekly:  return "Perminium_Weekly"
        case .monthly: return "Perminium_Monthly"
        case .yearly:  return "Perminium_Yearly"
        }
    }

    var price: String {
        switch self {
        case .weekly:  return "$18.00"
        case .monthly: return "$50.00"
        case .yearly:  return "$117.99"
        }
    }

    var period: String {
        switch self {
        case .weekly:  return "per week"
        case .monthly: return "per month"
        case .yearly:  return "per year"
        }
    }

    var subtitle: String {
        switch self {
        case .weekly:  return "Try premium short-term"
        case .monthly: return "Flexible monthly access"
        case .yearly:  return "Best deal · save over 80%"
        }
    }

    var savingsBadge: String? {
        switch self {
        case .weekly:  return nil
        case .monthly: return nil
        case .yearly:  return "Best value"
        }
    }
}

#if canImport(RevenueCat)
extension PremiumStore: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            let namedActive = customerInfo.entitlements.all[Self.entitlementID]?.isActive == true
            let anyActive = namedActive || customerInfo.entitlements.active.isEmpty == false
            isActiveStorage = anyActive
            objectWillChange.send()
        }
    }
}
#endif

