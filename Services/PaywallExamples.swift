import SwiftUI

// MARK: - Paywall Integration Examples

/// This file demonstrates different ways to show and integrate the paywall in your app

// MARK: - Example 1: Simple Button to Show Paywall

struct Example1_SimpleButton: View {
    @State private var showPaywall = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Example 1: Simple Button")
                .font(.headline)
            
            Button("Show Paywall") {
                showPaywall = true
            }
            .buttonStyle(.borderedProminent)
        }
        .paywall(isPresented: $showPaywall)
    }
}

// MARK: - Example 2: Check Premium Status Before Action

struct Example2_PremiumGate: View {
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showPaywall = false
    @State private var showPremiumFeature = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Example 2: Premium Gate")
                .font(.headline)
            
            Text("Premium Status: \(premium.isActive ? "Active ✅" : "Not Active ❌")")
                .font(.subheadline)
            
            Button("Access Premium Feature") {
                if premium.isActive {
                    // User is premium, show the feature
                    showPremiumFeature = true
                } else {
                    // User is not premium, show paywall
                    showPaywall = true
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .paywall(isPresented: $showPaywall) {
            // Optional: Action to perform when paywall is dismissed
            if premium.isActive {
                showPremiumFeature = true
            }
        }
        .sheet(isPresented: $showPremiumFeature) {
            Text("Premium Feature View")
                .font(.title)
        }
    }
}

// MARK: - Example 3: Using Premium Gate View

struct Example3_GateView: View {
    @ObservedObject private var premium = PremiumStore.shared
    
    var body: some View {
        VStack {
            if premium.isActive {
                // Show premium content
                VStack(spacing: 20) {
                    Text("🎉 Premium Content")
                        .font(.title)
                    Text("You have access to all features!")
                        .font(.subheadline)
                }
            } else {
                // Show premium gate
                PremiumGateView(
                    title: "Unlock Premium Features",
                    message: "Get unlimited access to all training tools",
                    icon: "crown.fill"
                )
            }
        }
    }
}

// MARK: - Example 4: Feature with Lock Overlay

struct Example4_FeatureLock: View {
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showPaywall = false
    
    var body: some View {
        ZStack {
            // Your feature content
            VStack(spacing: 20) {
                Text("Advanced Training Analytics")
                    .font(.title2)
                
                Text("View detailed performance metrics")
                    .foregroundStyle(.secondary)
                
                // Some chart or content
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blue.opacity(0.2))
                    .frame(height: 200)
                    .overlay {
                        Text("Chart Data")
                    }
            }
            .padding()
            .blur(radius: premium.isActive ? 0 : 8)
        }
        .premiumGate(isLocked: !premium.isActive) {
            showPaywall = true
        }
        .paywall(isPresented: $showPaywall)
    }
}

// MARK: - Example 5: Premium Badge on Feature

struct Example5_PremiumBadge: View {
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showPaywall = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Example 5: Premium Badge")
                .font(.headline)
            
            // Feature card with premium badge
            Button {
                if !premium.isActive {
                    showPaywall = true
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text("AI Coach")
                                .font(.headline)
                            
                            if !premium.isActive {
                                PremiumBadge(size: 14)
                            }
                        }
                        
                        Text("Get personalized training advice")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .paywall(isPresented: $showPaywall)
    }
}

// MARK: - Example 6: Coach Message Quota

struct Example6_CoachQuota: View {
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showPaywall = false
    @State private var messages: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Example 6: Coach Quota System")
                .font(.headline)
            
            if !premium.isActive {
                HStack(spacing: 8) {
                    Image(systemName: "message.fill")
                    Text("\(premium.coachRemainingToday) messages remaining today")
                        .font(.subheadline)
                    
                    Button {
                        showPaywall = true
                    } label: {
                        Text("Upgrade")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Theme.primary, in: Capsule())
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
            
            Button("Send Coach Message") {
                sendCoachMessage()
            }
            .buttonStyle(.borderedProminent)
            .disabled(premium.coachRemainingToday == 0 && !premium.isActive)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(messages, id: \.self) { message in
                        Text(message)
                            .padding()
                            .background(.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding()
        .paywall(isPresented: $showPaywall)
    }
    
    private func sendCoachMessage() {
        if premium.consumeCoachMessage() {
            messages.append("Coach message \(messages.count + 1)")
        } else {
            // Show paywall when quota exceeded
            showPaywall = true
        }
    }
}

// MARK: - Example 7: Settings Screen with Premium Status

struct Example7_SettingsWithPremium: View {
    @ObservedObject private var premium = PremiumStore.shared
    @State private var showPaywall = false
    
    var body: some View {
        List {
            Section {
                if premium.isActive {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(Theme.primary)
                        VStack(alignment: .leading) {
                            Text("Premium Active")
                                .font(.headline)
                            if let plan = premium.currentPlan {
                                Text(plan.title)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Button("Manage") {
                            // Open App Store subscriptions
                            if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                                UIApplication.shared.open(url)
                            }
                        }
                        .font(.caption)
                    }
                } else {
                    Button {
                        showPaywall = true
                    } label: {
                        HStack {
                            Image(systemName: "crown")
                                .foregroundStyle(Theme.primary)
                            VStack(alignment: .leading) {
                                Text("Upgrade to Premium")
                                    .font(.headline)
                                Text("Unlock all features")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text("Subscription")
            }
            
            Section {
                NavigationLink("Account Settings") {
                    Text("Account")
                }
                NavigationLink("Notifications") {
                    Text("Notifications")
                }
            } header: {
                Text("General")
            }
        }
        .paywall(isPresented: $showPaywall)
    }
}

// MARK: - Main Demo View

struct PaywallIntegrationExamples: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("1. Simple Button") {
                    Example1_SimpleButton()
                }
                
                NavigationLink("2. Premium Gate Check") {
                    Example2_PremiumGate()
                }
                
                NavigationLink("3. Premium Gate View") {
                    Example3_GateView()
                }
                
                NavigationLink("4. Feature Lock Overlay") {
                    Example4_FeatureLock()
                }
                
                NavigationLink("5. Premium Badge") {
                    Example5_PremiumBadge()
                }
                
                NavigationLink("6. Coach Quota System") {
                    Example6_CoachQuota()
                }
                
                NavigationLink("7. Settings with Premium") {
                    Example7_SettingsWithPremium()
                }
            }
            .navigationTitle("Paywall Examples")
        }
    }
}

// MARK: - Preview

#Preview {
    PaywallIntegrationExamples()
}
