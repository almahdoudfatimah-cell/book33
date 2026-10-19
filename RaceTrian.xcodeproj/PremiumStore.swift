import SwiftUI
import RevenueCat
import Combine

/// Manages premium subscription status
final class PremiumStore: ObservableObject {
    static let shared = PremiumStore()
    
    @Published var isActive: Bool = false
    @Published var customerInfo: CustomerInfo?
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Check initial subscription status
        checkSubscriptionStatus()
        
        // Listen for subscription changes
        Purchases.shared.customerInfoStream
            .receive(on: DispatchQueue.main)
            .sink { [weak self] customerInfo in
                self?.customerInfo = customerInfo
                self?.updateSubscriptionStatus(customerInfo)
            }
            .store(in: &cancellables)
    }
    
    func checkSubscriptionStatus() {
        Task {
            do {
                let customerInfo = try await Purchases.shared.customerInfo()
                await MainActor.run {
                    self.customerInfo = customerInfo
                    updateSubscriptionStatus(customerInfo)
                }
            } catch {
                print("❌ Error fetching customer info: \(error)")
            }
        }
    }
    
    private func updateSubscriptionStatus(_ info: CustomerInfo) {
        // Check if user has any active premium entitlement
        isActive = info.entitlements.active.contains { $0.key == "premium" }
            || !info.activeSubscriptions.isEmpty
    }
    
    func restorePurchases() async throws {
        let customerInfo = try await Purchases.shared.restorePurchases()
        await MainActor.run {
            self.customerInfo = customerInfo
            updateSubscriptionStatus(customerInfo)
        }
    }
}
