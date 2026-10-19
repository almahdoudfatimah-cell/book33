// PAYWALL INTEGRATION GUIDE
// =======================

/*
 
 OVERVIEW
 --------
 This guide shows you how to integrate the paywall throughout your RaceTrian app.
 The paywall is already configured with RevenueCat and ready to use.
 
 
 QUICK START - 3 WAYS TO SHOW THE PAYWALL
 -----------------------------------------
 
 1️⃣ SIMPLE SHEET PRESENTATION
 
    import SwiftUI
    
    struct MyView: View {
        @State private var showPaywall = false
        
        var body: some View {
            Button("Upgrade to Premium") {
                showPaywall = true
            }
            .paywall(isPresented: $showPaywall)
        }
    }
 
 
 2️⃣ CHECK PREMIUM STATUS FIRST
 
    struct MyFeatureView: View {
        @ObservedObject private var premium = PremiumStore.shared
        @State private var showPaywall = false
        
        var body: some View {
            Button("Use Premium Feature") {
                if premium.isActive {
                    // User has premium, allow access
                    performPremiumAction()
                } else {
                    // Show paywall to upgrade
                    showPaywall = true
                }
            }
            .paywall(isPresented: $showPaywall)
        }
    }
 
 
 3️⃣ USE PREMIUM GATE VIEW
 
    struct LockedFeatureView: View {
        @ObservedObject private var premium = PremiumStore.shared
        
        var body: some View {
            if premium.isActive {
                // Show premium content
                PremiumContentView()
            } else {
                // Show gate with upgrade button
                PremiumGateView(
                    title: "Premium Feature",
                    message: "Upgrade to access this feature",
                    icon: "crown.fill"
                )
            }
        }
    }
 
 
 PREMIUM STATUS CHECKING
 -----------------------
 
 // Check if user has premium
 if PremiumStore.shared.isActive {
     // User has premium
 }
 
 // Get current plan
 if let plan = PremiumStore.shared.currentPlan {
     print("User has: \(plan.title)") // "Weekly", "Monthly", or "Yearly"
 }
 
 
 COACH QUOTA SYSTEM (FREE TIER)
 ------------------------------
 
 // Free users get 5 AI Coach messages per day
 // Premium users get unlimited messages
 
 let remaining = PremiumStore.shared.coachRemainingToday
 print("Messages remaining: \(remaining)")
 
 // Consume a message (returns false if quota exceeded)
 if PremiumStore.shared.consumeCoachMessage() {
     // Send the message
     sendCoachMessage()
 } else {
     // Show paywall - quota exceeded
     showPaywall = true
 }
 
 
 PREMIUM BADGES & UI INDICATORS
 ------------------------------
 
 // Add a premium badge next to a feature name
 HStack {
     Text("Advanced Analytics")
     if !premium.isActive {
         PremiumBadge(size: 14)
     }
 }
 
 // Lock overlay on premium content
 VStack {
     // Your content here
 }
 .premiumGate(isLocked: !premium.isActive) {
     showPaywall = true
 }
 
 
 LISTENING TO SUBSCRIPTION CHANGES
 ----------------------------------
 
 // PremiumStore automatically listens to RevenueCat updates
 // Just observe the PremiumStore in your view:
 
 @ObservedObject private var premium = PremiumStore.shared
 
 // Your UI will automatically update when subscription status changes
 
 
 MANUAL REFRESH
 --------------
 
 // Manually check RevenueCat for latest subscription status
 Task {
     await PremiumStore.shared.checkEntitlement()
 }
 
 // Or trigger a quick refresh
 PremiumStore.shared.refreshFromRevenueCat()
 
 
 RESTORE PURCHASES
 -----------------
 
 // Restore previous purchases
 Task {
     await PremiumStore.shared.restore()
     
     if PremiumStore.shared.isActive {
         print("Purchases restored!")
     }
 }
 
 
 TESTING
 -------
 
 The app works without RevenueCat installed (for testing):
 - Mock purchases will simulate successful transactions
 - You can test the paywall UI without real products
 
 To test real purchases:
 1. Add RevenueCat SDK to your project
 2. Configure products in RevenueCat dashboard
 3. Use TestFlight or Sandbox environment
 
 
 NOTIFICATION CENTER EVENTS
 --------------------------
 
 The app posts these notifications you can listen to:
 
 // Subscription status changed (from AppDelegate)
 NotificationCenter.default.addObserver(
     forName: NSNotification.Name("subscriptionStatusChanged"),
     object: nil,
     queue: .main
 ) { notification in
     if let isPremium = notification.userInfo?["isPremiumActive"] as? Bool {
         print("Premium status: \(isPremium)")
     }
 }
 
 
 AVAILABLE PLANS
 ---------------
 
 1. Weekly Plan - $18/week
 2. Yearly Plan - $117.99/year (Best Value)
 
 Free Trial: 1 week free trial available on first subscription
 
 
 WHERE IS THE PAYWALL SHOWN IN THE APP?
 --------------------------------------
 
 Currently shown in the launch flow:
 - App Launch -> Splash Screen -> Paywall -> Auth -> Main App
 
 You can also show it:
 - From any view using .paywall(isPresented:)
 - In Settings/Profile
 - When accessing premium features
 - When coach quota is exceeded
 
 
 CUSTOMIZATION
 -------------
 
 The paywall UI is in PaywallView.swift
 - Change colors in Theme.swift
 - Modify features list in featuresList computed property
 - Adjust pricing in PremiumPlan enum
 - Update RevenueCat product IDs in PremiumPlan.productIdentifier
 
 
 COMMON PATTERNS
 ---------------
 
 Pattern 1: Feature Button with Premium Check
 
     Button("Advanced Feature") {
         guard premium.isActive else {
             showPaywall = true
             return
         }
         showFeature()
     }
 
 
 Pattern 2: Conditional Navigation
 
     NavigationLink(
         destination: premium.isActive ? 
             AnyView(PremiumFeatureView()) : 
             AnyView(PremiumGateView())
     ) {
         Text("Advanced Stats")
     }
 
 
 Pattern 3: List with Premium Indicator
 
     List {
         NavigationLink("Basic Feature") { BasicView() }
         
         Button {
             if premium.isActive {
                 showPremiumFeature()
             } else {
                 showPaywall = true
             }
         } label: {
             HStack {
                 Text("Premium Feature")
                 Spacer()
                 PremiumBadge(size: 12)
             }
         }
     }
 
 
 REVENUE CAT CONFIGURATION
 -------------------------
 
 API Key: appl_VctVBGhshxVGvZgSrJMddtaxSPP
 Entitlement ID: "RaceTrian Pro"
 
 Configured in:
 - PremiumStore.swift (main configuration)
 - AppDelegate.swift (delegate setup)
 - PlannerApp.swift (initialization)
 
 
 TROUBLESHOOTING
 ---------------
 
 Q: Paywall doesn't show?
 A: Make sure you're using .paywall(isPresented: $showPaywall) modifier
 
 Q: Premium status not updating?
 A: Check that AppDelegate is properly wired with @UIApplicationDelegateAdaptor
 
 Q: Purchases not working?
 A: Verify RevenueCat products are configured and match productIdentifier in PremiumPlan
 
 Q: Can't restore purchases?
 A: User must be signed in (check auth.isSignedIn before restore)
 
 
 EXAMPLES FILE
 -------------
 
 See PaywallExamples.swift for 7 complete working examples:
 1. Simple button trigger
 2. Premium gate check
 3. Gate view usage
 4. Feature lock overlay
 5. Premium badges
 6. Coach quota system
 7. Settings integration
 
 
 SUPPORT
 -------
 
 Files to review:
 - PaywallView.swift - Main paywall UI
 - PaywallPresenter.swift - Helper views and modifiers
 - PremiumStore.swift - Subscription logic
 - AppDelegate.swift - RevenueCat delegate
 - PaywallExamples.swift - Integration examples
 
*/
