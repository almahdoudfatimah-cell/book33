import SwiftUI

/// Developer Testing View for Paywall System
/// Add this to your app during development to test all paywall functionality
struct PaywallTestingView: View {
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showPaywall = false
    @State private var testMessages: [String] = []
    
    var body: some View {
        NavigationView {
            List {
                statusSection
                quickActionsSection
                coachQuotaSection
                testMessagesSection
                debugSection
                examplesSection
            }
            .navigationTitle("Paywall Testing")
            .navigationBarTitleDisplayMode(.inline)
        }
        .paywall(isPresented: $showPaywall)
    }
    
    // MARK: - Status Section
    
    private var statusSection: some View {
        Section {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Premium Status")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(premium.isActive ? "Active ✅" : "Not Active ❌")
                        .font(.headline)
                }
                Spacer()
                if premium.isActive {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(Theme.primary)
                        .font(.title2)
                }
            }
            
            if let plan = premium.currentPlan {
                HStack {
                    Text("Current Plan")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(plan.title)
                        .font(.headline)
                }
            }
            
            HStack {
                Text("Coach Messages Remaining")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(premium.isActive ? "Unlimited" : "\(premium.coachRemainingToday)")
                    .font(.headline)
                    .foregroundStyle(premium.isActive ? Theme.primary : .primary)
            }
        } header: {
            Text("Current Status")
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        Section {
            Button {
                showPaywall = true
            } label: {
                Label("Show Paywall", systemImage: "square.and.arrow.up")
            }
            
            Button {
                Task {
                    await premium.checkEntitlement()
                }
            } label: {
                Label("Refresh Status", systemImage: "arrow.clockwise")
            }
            
            Button {
                Task {
                    await premium.restore()
                }
            } label: {
                Label("Restore Purchases", systemImage: "arrow.down.circle")
            }
            
            if premium.isActive {
                Button(role: .destructive) {
                    premium.cancelLocally()
                } label: {
                    Label("Cancel Locally (Testing)", systemImage: "xmark.circle")
                }
            }
        } header: {
            Text("Quick Actions")
        } footer: {
            Text("Use these buttons to test different paywall scenarios")
        }
    }
    
    // MARK: - Coach Quota Testing
    
    private var coachQuotaSection: some View {
        Section {
            HStack {
                Text("Messages Sent Today")
                Spacer()
                Text("\(5 - premium.coachRemainingToday) / 5")
                    .foregroundStyle(.secondary)
            }
            
            Button {
                testCoachMessage()
            } label: {
                HStack {
                    Label("Send Test Message", systemImage: "message.fill")
                    Spacer()
                    if !premium.isActive && premium.coachRemainingToday == 0 {
                        Text("Quota Exceeded")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .disabled(!premium.isActive && premium.coachRemainingToday == 0)
            
            if !testMessages.isEmpty {
                ForEach(testMessages.indices, id: \.self) { index in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Message \(index + 1)")
                        Spacer()
                        Text("Sent")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            if !testMessages.isEmpty {
                Button(role: .destructive) {
                    testMessages.removeAll()
                } label: {
                    Label("Clear Messages", systemImage: "trash")
                }
            }
        } header: {
            Text("Coach Quota Testing")
        } footer: {
            Text(premium.isActive ? 
                 "Premium users have unlimited messages" : 
                 "Free users get 5 messages per day. Try exceeding the limit to see the paywall.")
        }
    }
    
    // MARK: - Test Messages Display
    
    private var testMessagesSection: some View {
        Section {
            if testMessages.isEmpty {
                Text("No test messages sent yet")
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(Array(testMessages.enumerated()), id: \.offset) { index, message in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Message \(index + 1)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(message)
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                }
            }
        } header: {
            Text("Test Messages History")
        }
    }
    
    // MARK: - Debug Info
    
    private var debugSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                DebugRow(label: "Premium Active", value: "\(premium.isActive)")
                DebugRow(label: "Is Purchasing", value: "\(premium.isPurchasing)")
                DebugRow(label: "Plan Raw Value", value: premium.currentPlan?.rawValue ?? "nil")
                DebugRow(label: "Coach Remaining", value: "\(premium.coachRemainingToday)")
                DebugRow(label: "Free Daily Limit", value: "\(premium.freeDailyLimit)")
                
                if let error = premium.purchaseError {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last Error:")
                            .font(.caption)
                            .foregroundStyle(.red)
                        Text(error)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                }
            }
        } header: {
            Text("Debug Information")
        }
    }
    
    // MARK: - Examples Link
    
    private var examplesSection: some View {
        Section {
            NavigationLink {
                PaywallIntegrationExamples()
            } label: {
                Label("View Integration Examples", systemImage: "doc.text.magnifyingglass")
            }
        } header: {
            Text("Learn More")
        } footer: {
            VStack(alignment: .leading, spacing: 8) {
                Text("Paywall Integration Files:")
                    .font(.caption)
                    .fontWeight(.semibold)
                Text("• PaywallExamples.swift - 7 working examples")
                Text("• PAYWALL_GUIDE.swift - Complete documentation")
                Text("• PAYWALL_SUMMARY.swift - Quick reference")
                Text("• PaywallPresenter.swift - Helper views")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Helper Functions
    
    private func testCoachMessage() {
        if premium.consumeCoachMessage() {
            let message = "Test coach message #\(testMessages.count + 1)"
            testMessages.append(message)
            
            // Show success feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            // Quota exceeded - show paywall
            showPaywall = true
            
            // Show error feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}

// MARK: - Debug Row Component

private struct DebugRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption.monospaced())
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Preview

#Preview {
    PaywallTestingView()
}

// MARK: - How to Add to Your App

/*
 
 ADD THIS VIEW TO YOUR APP FOR TESTING
 ═════════════════════════════════════════════════════════════════════
 
 Option 1: Add to Settings/Profile
 
     NavigationLink {
         PaywallTestingView()
     } label: {
         Label("Paywall Testing", systemImage: "dollarsign.circle")
     }
 
 
 Option 2: Add as Debug Tab (Development Only)
 
     #if DEBUG
     TabView {
         // Your regular tabs...
         
         PaywallTestingView()
             .tabItem {
                 Label("Debug", systemImage: "hammer.fill")
             }
     }
     #endif
 
 
 Option 3: Show from Menu
 
     Menu("Developer") {
         Button("Paywall Testing") {
             showPaywallTesting = true
         }
     }
     .sheet(isPresented: $showPaywallTesting) {
         PaywallTestingView()
     }
 
 */
