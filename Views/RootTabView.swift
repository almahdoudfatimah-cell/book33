#if !os(watchOS)
import SwiftUI

extension Notification.Name {
    static let switchTab = Notification.Name("switchTab")
}

// MARK: - Temporary stubs until view files are added to target
// TODO: Add TodayView.swift to build target

fileprivate struct TodayView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "calendar.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Theme.primary)
                    
                    Text("Today")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    
                    Text("Your daily training schedule and activities")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Spacer()
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
}

fileprivate struct UserAssessmentViewStub: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "list.clipboard.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Theme.primary)
                    
                    Text("Fitness Assessment")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    
                    Text("Complete a quick assessment to personalize your training experience")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Button {
                        // TODO: Start assessment
                    } label: {
                        Text("Start Assessment")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.heroGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Assessment")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
}

fileprivate struct AIAssistantView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "sparkles.rectangle.stack")
                        .font(.system(size: 80))
                        .foregroundStyle(Theme.primary)
                    
                    Text("AI Assistant")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    
                    Text("Get personalized training advice and answers to your fitness questions")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Button {
                        // TODO: Start chat
                    } label: {
                        Text("Start Chat")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.heroGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Assistant")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
}

// MARK: - Account View
fileprivate struct AccountView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Theme.primary.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(Theme.primary)
                        }
                        
                        Text("John Athlete")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Text("Premium Member")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Theme.primary.opacity(0.15))
                            .clipShape(Capsule())
                    }
                    .padding(.top, 20)
                    
                    // Account Stats
                    HStack(spacing: 12) {
                        AccountStatCard(icon: "flame.fill", value: "128", label: "Day Streak", color: .orange)
                        AccountStatCard(icon: "trophy.fill", value: "47", label: "Badges", color: .yellow)
                        AccountStatCard(icon: "star.fill", value: "12.4K", label: "Points", color: .purple)
                    }
                    .padding(.horizontal)
                    
                    // Account Sections
                    VStack(spacing: 16) {
                        AccountInfoSection(title: "PERSONAL INFO") {
                            AccountRow(icon: "envelope.fill", title: "Email", value: "john@example.com", color: .blue)
                            AccountRow(icon: "phone.fill", title: "Phone", value: "+1 (555) 123-4567", color: .green)
                            AccountRow(icon: "mappin.circle.fill", title: "Location", value: "San Francisco, CA", color: .red)
                        }
                        
                        AccountInfoSection(title: "SUBSCRIPTION") {
                            AccountRow(icon: "crown.fill", title: "Plan", value: "Premium Annual", color: .yellow)
                            AccountRow(icon: "calendar.badge.clock", title: "Renews", value: "Dec 15, 2026", color: .orange)
                            AccountActionRow(icon: "creditcard.fill", title: "Manage Subscription", color: .purple)
                        }
                        
                        AccountInfoSection(title: "PREFERENCES") {
                            AccountActionRow(icon: "bell.fill", title: "Notifications", color: .red)
                            AccountActionRow(icon: "lock.shield.fill", title: "Privacy & Security", color: .blue)
                            AccountActionRow(icon: "globe", title: "Language & Region", color: .cyan)
                        }
                        
                        AccountInfoSection(title: "ACCOUNT") {
                            AccountActionRow(icon: "arrow.triangle.2.circlepath", title: "Sync Settings", color: .green)
                            AccountActionRow(icon: "arrow.down.doc.fill", title: "Export Data", color: .orange)
                            AccountActionRow(icon: "arrow.right.square.fill", title: "Sign Out", color: .red)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .background(Theme.pageBackground)
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // QR code or share profile
                    } label: {
                        Label("QR Code", systemImage: "qrcode")
                            .font(.system(size: 20))
                            .foregroundStyle(.blue)
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // Share account/achievements
                    Button {
                        // Share profile
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundStyle(.green)
                            .labelStyle(.iconOnly)
                    }
                    
                    // Settings
                    Button {
                        // Settings
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .font(.system(size: 20))
                            .foregroundStyle(.gray)
                            .labelStyle(.iconOnly)
                    }
                    
                    // Edit profile
                    Button {
                        // Edit
                    } label: {
                        Label("Edit", systemImage: "pencil.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.primary)
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }.appPageTheme()
    }
}

// MARK: - Main Dashboard View
fileprivate struct MainDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back!")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        Text("Ready to crush your goals today?")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Quick Stats
                    VStack(alignment: .leading, spacing: 16) {
                        Text("TODAY'S OVERVIEW")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 12) {
                            DashboardStatCard(icon: "flame.fill", value: "420", label: "Calories", color: .orange)
                            DashboardStatCard(icon: "figure.walk", value: "8.2K", label: "Steps", color: .green)
                            DashboardStatCard(icon: "clock.fill", value: "45m", label: "Active", color: .blue)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("QUICK ACTIONS")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            DashboardQuickActionCard(icon: "figure.run", title: "Start Workout", color: .orange)
                            DashboardQuickActionCard(icon: "chart.bar.fill", title: "View Stats", color: .purple)
                            DashboardQuickActionCard(icon: "calendar.badge.clock", title: "Schedule", color: .blue)
                            DashboardQuickActionCard(icon: "trophy.fill", title: "Challenges", color: .yellow)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 16) {
                        Text("RECENT ACTIVITY")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                        
                        DashboardActivityRow(icon: "figure.run", title: "Morning Run", time: "Today, 7:00 AM", value: "5.2 km", color: .orange)
                        DashboardActivityRow(icon: "dumbbell.fill", title: "Strength Training", time: "Yesterday, 6:00 PM", value: "45 min", color: .red)
                        DashboardActivityRow(icon: "bicycle", title: "Evening Ride", time: "2 days ago", value: "15.8 km", color: .blue)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // Goals Progress
                    VStack(alignment: .leading, spacing: 16) {
                        Text("WEEKLY GOALS")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                        
                        GoalProgressRow(title: "Running", current: "32.4 km", goal: "50 km", progress: 0.65, color: .orange)
                        GoalProgressRow(title: "Workouts", current: "4", goal: "6", progress: 0.67, color: .purple)
                        GoalProgressRow(title: "Active Minutes", current: "180", goal: "300", progress: 0.60, color: .blue)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .background(Theme.pageBackground)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        AccountView()
                    } label: {
                        Label("Account", systemImage: "person.circle.fill")
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink {
                        TodayView()
                    } label: {
                        Label("Today", systemImage: "calendar.circle.fill")
                    }
                    
                    NavigationLink {
                        PlanView()
                    } label: {
                        Label("Plan", systemImage: "calendar.badge.clock")
                    }
                    
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Label("More", systemImage: "ellipsis.circle.fill")
                    }
                }
            }
        }.appPageTheme()
    }
}

// MARK: - Account Supporting Views

struct AccountStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct AccountInfoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 0) {
                content
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct AccountRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
                .frame(width: 28)
            
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.surface)
    }
}

struct AccountActionRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(color)
                    .frame(width: 28)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Theme.surface)
        }
    }
}

// MARK: - Dashboard Supporting Views

struct DashboardStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DashboardQuickActionCard: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundStyle(color)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct DashboardActivityRow: View {
    let icon: String
    let title: String
    let time: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Text(time)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .padding()
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct GoalProgressRow: View {
    let title: String
    let current: String
    let goal: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Spacer()
                Text("\(current) / \(goal)")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct RootTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            PlanView()
                .tabItem {
                    Label("Plan", systemImage: "calendar.badge.clock")
                }
                .tag(1)
            
            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
                .tag(2)
            
            ProjectsView()
                .tabItem {
                    Label("Projects", systemImage: "folder.fill")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle.fill")
                }
                .tag(4)
        }
        .tint(Theme.primary)
        .onReceive(NotificationCenter.default.publisher(for: .switchTab)) { notification in
            if let tab = notification.object as? Int ?? notification.userInfo?["tab"] as? Int,
               0...4 ~= tab {
                selectedTab = tab
            }
        }
    }
}

// MARK: - Progress Tracking View
struct ProgressTrackingView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Progress")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 12) {
                            ProgressStatCard(icon: "chart.line.uptrend.xyaxis", value: "+12%", label: "This Month", color: .green)
                            ProgressStatCard(icon: "flame.fill", value: "85%", label: "Goal Met", color: .orange)
                            ProgressStatCard(icon: "trophy.fill", value: "24", label: "Milestones", color: .yellow)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Activity Progress
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Activity Progress")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        ProgressRow(activity: "Running", current: "42.5 km", goal: "50 km", progress: 0.85, color: .orange)
                        ProgressRow(activity: "Cycling", current: "120 km", goal: "150 km", progress: 0.80, color: .blue)
                        ProgressRow(activity: "Strength", current: "8", goal: "12", progress: 0.67, color: .red)
                        ProgressRow(activity: "Yoga", current: "5", goal: "8", progress: 0.62, color: .purple)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Monthly Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Monthly Overview")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        // Placeholder for chart
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.surface)
                                .frame(height: 200)
                            
                            VStack(spacing: 8) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.purple)
                                Text("Progress Chart")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
}

struct ProgressStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ProgressRow: View {
    let activity: String
    let current: String
    let goal: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(activity)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Spacer()
                Text("\(current) / \(goal)")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - All Features List View
struct AllFeaturesListView: View {
    typealias FeatureItem = (icon: String, title: String, color: Color)
    typealias FeatureCategory = (category: String, items: [FeatureItem])
    
    @State private var searchText = ""
    
    private var trainingFeatures: [FeatureItem] {
        [
            ("figure.run", "Sports Tracking", .orange),
            ("dumbbell.fill", "Training Log", .red),
            ("chart.bar.fill", "Training Tracking", .blue),
            ("flag.checkered", "Race Events", .purple),
            ("calendar.badge.clock", "Training Calendar", .cyan),
            ("bolt.heart.fill", "Interval Training", .orange),
            ("figure.cooldown", "Recovery Tracker", .green),
            ("target", "Training Goals", .blue),
            ("film.fill", "Exercise Library", .purple),
            ("list.clipboard.fill", "Workout Plans", .green),
            ("figure.strengthtraining.traditional", "Strength Training", .red),
            ("timer", "Workout Timer", .orange),
            ("flame.circle.fill", "HIIT Workouts", .pink),
            ("figure.yoga", "Yoga & Flexibility", .purple),
            ("figure.boxing", "Boxing Training", .red),
            ("figure.gymnastics", "Gymnastics", .cyan)
        ]
    }
    
    private var trackingFeatures: [FeatureItem] {
        [
            ("chart.xyaxis.line", "Performance", .blue),
            ("flame.fill", "Calories", .orange),
            ("figure.walk", "Steps", .green),
            ("heart.fill", "Heart Rate", .pink),
            ("scalemass.fill", "Weight", .orange),
            ("trophy.fill", "Records", .yellow),
            ("speedometer", "Pace", .cyan),
            ("figure.stairs", "Elevation", .brown),
            ("drop.fill", "Hydration", .blue),
            ("wind", "VO2 Max", .teal),
            ("chart.line.uptrend.xyaxis", "Progress", .purple),
            ("square.grid.3x3.fill", "Body Comp", .indigo),
            ("gauge.with.dots.needle.67percent", "Stress", .red),
            ("lungs.fill", "Breathing", .mint),
            ("figure.run.circle.fill", "Running Analytics", .orange),
            ("bicycle.circle.fill", "Cycling Metrics", .blue),
            ("figure.pool.swim", "Swimming", .cyan),
            ("sparkles.rectangle.stack.fill", "Form Analysis", .purple),
            ("cross.case.fill", "Injury Prevention", .red),
            ("cloud.sun.fill", "Weather Impact", .orange),
            ("chart.bar.xaxis", "Training Load", .indigo),
            ("calendar.circle.fill", "Seasonal Trends", .green),
            ("flag.checkered.2.crossed", "Race Readiness", .yellow),
            ("brain.head.profile", "Performance AI", .mint),
            ("bolt.circle.fill", "Energy Levels", .yellow),
            ("moon.stars.fill", "Sleep Quality", .purple),
            ("figure.walk.motion", "Activity Rings", .green),
            ("chart.pie.fill", "Macro Tracking", .orange)
        ]
    }
    
    private var healthFeatures: [FeatureItem] {
        [
            ("fork.knife", "Nutrition", .green),
            ("bed.double.fill", "Sleep", .purple),
            ("heart.text.square.fill", "Body Metrics", .pink),
            ("pill.fill", "Medication", .red),
            ("brain.fill", "Mental Health", .indigo),
            ("figure.mind.and.body", "Meditation", .teal),
            ("leaf.fill", "Wellness Score", .green),
            ("heart.circle.fill", "Vitals Monitor", .pink),
            ("waveform.path.ecg", "Health Trends", .red),
            ("figure.walk.arrival", "Daily Movement", .orange),
            ("sun.max.fill", "Vitamin D", .yellow),
            ("cup.and.saucer.fill", "Caffeine Tracker", .brown)
        ]
    }
    
    private var nutritionFeatures: [FeatureItem] {
        [
            ("carrot.fill", "Meal Planner", .orange),
            ("figure.mixed.cardio", "Calorie Goals", .red),
            ("drop.triangle.fill", "Water Intake", .cyan),
            ("list.clipboard", "Food Diary", .green),
            ("chart.bar.doc.horizontal", "Macro Split", .purple),
            ("camera.fill", "Meal Photos", .blue),
            ("cart.fill", "Grocery List", .orange),
            ("fork.knife.circle.fill", "Recipe Book", .pink)
        ]
    }
    
    private var settingsFeatures: [FeatureItem] {
        [
            ("person.circle.fill", "Profile", .orange),
            ("paintbrush.fill", "Appearance", .purple),
            ("bell.badge.fill", "Notifications", .red),
            ("lock.shield.fill", "Privacy", .blue),
            ("globe", "Language", .cyan),
            ("speaker.wave.3.fill", "Sound", .pink),
            ("externaldrive.fill.badge.icloud", "Backup", .indigo),
            ("arrow.triangle.2.circlepath", "Sync Settings", .green),
            ("hand.raised.fill", "Permissions", .orange),
            ("shield.checkered", "Security", .blue)
        ]
    }
    
    private var socialFeatures: [FeatureItem] {
        [
            ("person.2.fill", "Friends", .blue),
            ("bubble.left.and.bubble.right.fill", "Activity Feed", .green),
            ("medal.fill", "Challenges", .orange),
            ("chart.bar.doc.horizontal.fill", "Leaderboards", .purple),
            ("person.3.fill", "Groups", .cyan),
            ("message.fill", "Messages", .blue),
            ("camera.badge.ellipsis", "Stories", .pink),
            ("hand.thumbsup.fill", "Achievements", .yellow)
        ]
    }
    
    private var equipmentFeatures: [FeatureItem] {
        [
            ("shoeprints.fill", "Shoe Tracker", .brown),
            ("bicycle", "Bike", .blue),
            ("applewatch", "Device Sync", .black),
            ("stopwatch.fill", "Accessories", .red),
            ("beats.headphones", "Audio Gear", .pink),
            ("sensor.tag.radiowaves.forward.fill", "Sensors", .purple)
        ]
    }
    
    private var premiumFeatures: [FeatureItem] {
        [
            ("crown.fill", "Premium", .yellow),
            ("chart.pie.fill", "Analytics", .purple),
            ("person.fill.checkmark", "AI Coach", .blue),
            ("heart.circle.fill", "Insights", .pink),
            ("sparkles", "Custom Plans", .orange),
            ("star.circle.fill", "Expert Tips", .yellow),
            ("bolt.badge.automatic.fill", "Auto Tracking", .cyan)
        ]
    }
    
    private var gamificationFeatures: [FeatureItem] {
        [
            ("gamecontroller.fill", "Achievements", .green),
            ("star.fill", "Points & Rewards", .yellow),
            ("gift.fill", "Unlockables", .red),
            ("flag.fill", "Milestones", .purple),
            ("rosette", "Badges", .blue)
        ]
    }
    
    private var supportFeatures: [FeatureItem] {
        [
            ("questionmark.circle.fill", "Help Center", .orange),
            ("envelope.fill", "Contact Us", .blue),
            ("star.fill", "Rate App", .yellow),
            ("doc.text.fill", "Terms", .gray),
            ("info.circle.fill", "About", .purple),
            ("book.fill", "User Guide", .cyan),
            ("video.fill", "Tutorials", .pink),
            ("bubble.left.and.exclamationmark.bubble.right.fill", "FAQ", .green)
        ]
    }
    
    private var allFeatures: [FeatureCategory] {
        [
            ("TRAINING", trainingFeatures),
            ("TRACKING & ANALYTICS", trackingFeatures),
            ("HEALTH & WELLNESS", healthFeatures),
            ("NUTRITION", nutritionFeatures),
            ("SETTINGS", settingsFeatures),
            ("SOCIAL & COMMUNITY", socialFeatures),
            ("EQUIPMENT & GEAR", equipmentFeatures),
            ("PREMIUM FEATURES", premiumFeatures),
            ("GAMIFICATION", gamificationFeatures),
            ("SUPPORT", supportFeatures)
        ]
    }
    
    private var filteredFeatures: [FeatureCategory] {
        if searchText.isEmpty {
            return allFeatures
        }
        
        return allFeatures.compactMap { categoryItem in
            let filtered = categoryItem.items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText)
            }
            
            if filtered.isEmpty {
                return nil
            }
            
            return (category: categoryItem.category, items: filtered)
        }
    }
    
    var body: some View {
        NavigationStack {
            listContent
                .searchable(text: $searchText, prompt: "Search features...")
                .navigationTitle("All Features")
                .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
    
    private var listContent: some View {
        List {
            ForEach(filteredFeatures, id: \.category) { section in
                Section(header: Text(section.category)) {
                    ForEach(section.items, id: \.title) { item in
                        FeatureListRowSimple(icon: item.icon, title: item.title, color: item.color)
                    }
                }
            }
        }.appPageTheme()
    }
}

// Simple list row for AllFeaturesListView
struct FeatureListRowSimple: View {
    let icon: String
    let title: String
    let color: Color
    
    @ViewBuilder
    private var destinationView: some View {
        switch title {
        case "Sports Tracking": SportsTrackingView()
        case "Training Log": TrainingLogView()
        case "Training Tracking": TrainingTrackingView()
        case "Race Events": RaceEventsView()
        case "Training Calendar": TrainingCalendarView()
        case "Interval Training": IntervalTrainingView()
        case "Recovery Tracker": RecoveryTrackerView()
        case "Training Goals": TrainingGoalsView()
        case "Exercise Library": ExerciseLibraryView()
        case "Workout Plans": WorkoutPlansView()
        case "Performance": PerformanceTrackingView()
        case "Calories": CalorieTrackerView()
        case "Steps": StepsCounterView()
        case "Heart Rate": HeartRateMonitorView()
        case "Weight": WeightTrackingView()
        case "Records": PersonalRecordsView()
        case "Running Analytics": RunningAnalyticsView()
        case "Cycling Metrics": CyclingMetricsView()
        case "Swimming": SwimmingTrackingView()
        case "Form Analysis": FormAnalysisView()
        case "Injury Prevention": InjuryPreventionView()
        case "Weather Impact": WeatherImpactView()
        case "Training Load": TrainingLoadView()
        case "Seasonal Trends": SeasonalTrendsView()
        case "Race Readiness": CompetitionReadinessView()
        case "Performance AI": PerformancePredictorView()
        case "Nutrition": NutritionView()
        case "Sleep": SleepTrackerView()
        case "Body Metrics": BodyMetricsView()
        case "Profile": ProfileSettingsView()
        case "Appearance": AppearanceSettingsView()
        case "Privacy": PrivacySettingsView()
        case "Help Center": HelpCenterView()
        case "Rate App": RateAppView()
        default: ComingSoonViewSimple(title: title, icon: icon, color: color)
        }
    }
    
    var body: some View {
        NavigationLink(destination: destinationView) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(color)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
        }
    }
}

struct ComingSoonViewSimple: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(color)
            Text(title)
                .font(.title)
            Text("Coming Soon")
                .foregroundStyle(.secondary)
        }
        .navigationTitle(title)
    }
}

// MARK: - Nutrition Hub View
struct NutritionHubView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    nutritionSummary
                    quickActions
                    mealHistory
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Nutrition")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
    
    private var nutritionSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Nutrition")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            
            HStack(spacing: 12) {
                NutritionStatCard(title: "Calories", value: "1,820", goal: "2,000", color: .orange)
                NutritionStatCard(title: "Protein", value: "85g", goal: "120g", color: .red)
                NutritionStatCard(title: "Water", value: "2.1L", goal: "3L", color: .cyan)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Log")
                .font(.system(size: 17, weight: .bold, design: .rounded))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                NutritionQuickButton(icon: "camera.fill", title: "Scan Meal", color: .blue)
                NutritionQuickButton(icon: "plus.circle.fill", title: "Add Food", color: .green)
                NutritionQuickButton(icon: "drop.fill", title: "Log Water", color: .cyan)
                NutritionQuickButton(icon: "carrot.fill", title: "Recipes", color: .orange)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var mealHistory: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Meals")
                .font(.system(size: 17, weight: .bold, design: .rounded))
            
            MealRow(meal: "Breakfast", calories: "420", time: "8:00 AM", icon: "sunrise.fill")
            MealRow(meal: "Lunch", calories: "650", time: "1:00 PM", icon: "sun.max.fill")
            MealRow(meal: "Snack", calories: "180", time: "4:00 PM", icon: "leaf.fill")
            MealRow(meal: "Dinner", calories: "570", time: "7:30 PM", icon: "moon.stars.fill")
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct NutritionStatCard: View {
    let title: String
    let value: String
    let goal: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            Text("/ \(goal)")
                .font(.system(size: 10, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct NutritionQuickButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct MealRow: View {
    let meal: String
    let calories: String
    let time: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Text(time)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(calories) cal")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(.orange)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Social Hub View
struct SocialHubView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    activityFeedHeader
                    socialQuickActions
                    recentActivity
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Social")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
    
    private var activityFeedHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Feed")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            
            HStack(spacing: 12) {
                SocialStatCard(icon: "person.2.fill", value: "127", label: "Friends", color: .blue)
                SocialStatCard(icon: "flame.fill", value: "32", label: "Streak", color: .orange)
                SocialStatCard(icon: "trophy.fill", value: "8", label: "Challenges", color: .yellow)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var socialQuickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Connect")
                .font(.system(size: 17, weight: .bold, design: .rounded))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                SocialQuickButton(icon: "person.badge.plus", title: "Find Friends", color: .blue)
                SocialQuickButton(icon: "medal.fill", title: "Challenges", color: .orange)
                SocialQuickButton(icon: "chart.bar.doc.horizontal", title: "Leaderboard", color: .purple)
                SocialQuickButton(icon: "person.3.fill", title: "Groups", color: .green)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.system(size: 17, weight: .bold, design: .rounded))
            
            ActivityItem(name: "Sarah M.", action: "completed a 10K run", time: "2h ago", icon: "figure.run", color: .orange)
            ActivityItem(name: "Mike T.", action: "achieved a new PR", time: "5h ago", icon: "trophy.fill", color: .yellow)
            ActivityItem(name: "Emma L.", action: "joined Morning Runners", time: "8h ago", icon: "person.3.fill", color: .green)
            ActivityItem(name: "John D.", action: "completed 100 day streak", time: "1d ago", icon: "flame.fill", color: .orange)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct SocialStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SocialQuickButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct ActivityItem: View {
    let name: String
    let action: String
    let time: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(name)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                    Text(action)
                        .font(.system(size: 15, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Text(time)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Equipment Hub View
struct EquipmentHubView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    equipmentSummary
                    activeGear
                    manageActions
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Equipment")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
    
    private var equipmentSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Equipment")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            
            HStack(spacing: 12) {
                EquipmentStatCard(icon: "shoeprints.fill", value: "342", label: "Shoes KM", color: .brown)
                EquipmentStatCard(icon: "bicycle", value: "1.2K", label: "Bike KM", color: .blue)
                EquipmentStatCard(icon: "applewatch", value: "3", label: "Devices", color: .black)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var activeGear: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Gear")
                .font(.system(size: 17, weight: .bold, design: .rounded))
            
            EquipmentItem(name: "Nike Pegasus 40", type: "Running Shoes", usage: "342 km", status: "Good", color: .orange)
            EquipmentItem(name: "Trek Domane", type: "Road Bike", usage: "1,245 km", status: "Excellent", color: .blue)
            EquipmentItem(name: "Apple Watch Ultra", type: "Smartwatch", usage: "Active", status: "Connected", color: .purple)
            EquipmentItem(name: "Garmin HRM", type: "Heart Rate Monitor", usage: "Active", status: "85% Battery", color: .red)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var manageActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Manage")
                .font(.system(size: 17, weight: .bold, design: .rounded))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                EquipmentActionButton(icon: "plus.circle.fill", title: "Add Gear", color: .green)
                EquipmentActionButton(icon: "wrench.fill", title: "Maintenance", color: .orange)
                EquipmentActionButton(icon: "arrow.triangle.2.circlepath", title: "Replace", color: .red)
                EquipmentActionButton(icon: "chart.bar.fill", title: "Usage Stats", color: .blue)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct EquipmentStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct EquipmentItem: View {
    let name: String
    let type: String
    let usage: String
    let status: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Text(type)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    Text(usage)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.secondary)
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text(status)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(color)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct EquipmentActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Stats Hub View
struct StatsHubView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // This Week Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("This Week")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 12) {
                            StatsCard(icon: "flame.fill", value: "2,840", label: "Calories", color: .orange)
                            StatsCard(icon: "figure.walk", value: "47.2K", label: "Steps", color: .green)
                            StatsCard(icon: "clock.fill", value: "5.2h", label: "Active", color: .blue)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Performance Metrics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Performance")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        PerformanceRow(icon: "figure.run", title: "Running", value: "32.4 km", trend: "+12%", trendUp: true, color: .orange)
                        PerformanceRow(icon: "bicycle", title: "Cycling", value: "85.2 km", trend: "+8%", trendUp: true, color: .blue)
                        PerformanceRow(icon: "dumbbell.fill", title: "Strength", value: "4 sessions", trend: "-1", trendUp: false, color: .red)
                        PerformanceRow(icon: "figure.yoga", title: "Yoga", value: "2 sessions", trend: "+1", trendUp: true, color: .purple)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Personal Records
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Records")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        RecordRow(title: "Fastest 5K", value: "24:32", date: "2 days ago", icon: "bolt.fill", color: .yellow)
                        RecordRow(title: "Longest Run", value: "21.1 km", date: "1 week ago", icon: "figure.run", color: .orange)
                        RecordRow(title: "Max Push-ups", value: "65 reps", date: "3 days ago", icon: "figure.strengthtraining.traditional", color: .red)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
}

struct StatsCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PerformanceRow: View {
    let icon: String
    let title: String
    let value: String
    let trend: String
    let trendUp: Bool
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
            
            HStack(spacing: 2) {
                Image(systemName: trendUp ? "arrow.up.right" : "arrow.down.right")
                    .font(.system(size: 10, weight: .bold))
                Text(trend)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(trendUp ? .green : .red)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background((trendUp ? Color.green : Color.red).opacity(0.15))
            .clipShape(Capsule())
        }
        .padding(.vertical, 8)
    }
}

struct RecordRow: View {
    let title: String
    let value: String
    let date: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                Text(date)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Achievements Hub View
struct AchievementsHubView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Achievement Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Progress")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 12) {
                            AchievementStatCard(icon: "trophy.fill", value: "47", label: "Badges", color: .yellow)
                            AchievementStatCard(icon: "star.fill", value: "12,450", label: "Points", color: .orange)
                            AchievementStatCard(icon: "flame.fill", value: "32", label: "Streak", color: .red)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Recent Achievements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Achievements")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        AchievementCard(
                            icon: "figure.run",
                            title: "Century Runner",
                            description: "Run 100 kilometers",
                            points: "+500",
                            unlocked: true,
                            color: .orange
                        )
                        AchievementCard(
                            icon: "flame.fill",
                            title: "30 Day Streak",
                            description: "Train 30 days in a row",
                            points: "+300",
                            unlocked: true,
                            color: .red
                        )
                        AchievementCard(
                            icon: "sunrise.fill",
                            title: "Early Bird",
                            description: "Complete 10 morning workouts",
                            points: "+200",
                            unlocked: true,
                            color: .yellow
                        )
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // In Progress
                    VStack(alignment: .leading, spacing: 12) {
                        Text("In Progress")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        ProgressAchievement(
                            icon: "bicycle",
                            title: "Cycling Master",
                            description: "Cycle 500 kilometers",
                            progress: 0.67,
                            current: "335 km",
                            goal: "500 km",
                            color: .blue
                        )
                        ProgressAchievement(
                            icon: "dumbbell.fill",
                            title: "Iron Will",
                            description: "Complete 50 strength sessions",
                            progress: 0.82,
                            current: "41/50",
                            goal: "50",
                            color: .purple
                        )
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Rewards")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
}

struct AchievementStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct AchievementCard: View {
    let icon: String
    let title: String
    let description: String
    let points: String
    let unlocked: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text(description)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
                Text(points)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(color)
            }
            
            Spacer()
            
            if unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ProgressAchievement: View {
    let icon: String
    let title: String
    let description: String
    let progress: Double
    let current: String
    let goal: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Text(description)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(current)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Weather Hub View
struct WeatherHubView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Current Weather
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("San Francisco")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                Text("Partly Cloudy")
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "cloud.sun.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.orange, .cyan)
                                Text("72°F")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                            }
                        }
                        
                        HStack(spacing: 12) {
                            WeatherStatCard(icon: "wind", value: "12 mph", label: "Wind", color: .cyan)
                            WeatherStatCard(icon: "humidity.fill", value: "65%", label: "Humidity", color: .blue)
                            WeatherStatCard(icon: "sun.max.fill", value: "6", label: "UV Index", color: .orange)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Training Recommendation
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Training Conditions")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.green)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Excellent for running")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                Text("Ideal temperature and low wind")
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Hourly Forecast
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Hourly Forecast")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                HourlyWeather(time: "Now", temp: "72°", icon: "sun.max.fill", color: .orange)
                                HourlyWeather(time: "2 PM", temp: "74°", icon: "cloud.sun.fill", color: .orange)
                                HourlyWeather(time: "3 PM", temp: "75°", icon: "cloud.sun.fill", color: .orange)
                                HourlyWeather(time: "4 PM", temp: "73°", icon: "cloud.fill", color: .gray)
                                HourlyWeather(time: "5 PM", temp: "71°", icon: "cloud.fill", color: .gray)
                                HourlyWeather(time: "6 PM", temp: "68°", icon: "cloud.moon.fill", color: .indigo)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
}

struct WeatherStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct HourlyWeather: View {
    let time: String
    let temp: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(time)
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(.secondary)
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            Text(temp)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
        }
        .frame(width: 70)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Routes Hub View
struct RoutesHubView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Routes Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("My Routes")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 12) {
                            RouteStatCard(icon: "map.fill", value: "24", label: "Saved", color: .blue)
                            RouteStatCard(icon: "star.fill", value: "8", label: "Favorites", color: .yellow)
                            RouteStatCard(icon: "location.fill", value: "142", label: "Total KM", color: .green)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explore")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            RouteActionButton(icon: "plus.circle.fill", title: "New Route", color: .green)
                            RouteActionButton(icon: "map.circle.fill", title: "Explore", color: .blue)
                            RouteActionButton(icon: "figure.run", title: "Run Routes", color: .orange)
                            RouteActionButton(icon: "bicycle", title: "Bike Routes", color: .cyan)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Popular Routes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Routes")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        RouteCard(name: "Golden Gate Loop", distance: "8.4 km", elevation: "245 m", type: "Running", color: .orange)
                        RouteCard(name: "Bay Trail", distance: "12.6 km", elevation: "45 m", type: "Cycling", color: .blue)
                        RouteCard(name: "Hill Climb Challenge", distance: "5.2 km", elevation: "380 m", type: "Running", color: .red)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Routes")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
}

struct RouteStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct RouteActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct RouteCard: View {
    let name: String
    let distance: String
    let elevation: String
    let type: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                Image(systemName: "map.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                HStack(spacing: 12) {
                    Label(distance, systemImage: "arrow.left.and.right")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.secondary)
                    Label(elevation, systemImage: "arrow.up.right")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Text(type)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(color)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Community Hub View
struct CommunityHubView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Community Stats
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Community")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 12) {
                            CommunityStatCard(icon: "person.3.fill", value: "12.5K", label: "Members", color: .blue)
                            CommunityStatCard(icon: "figure.run", value: "847", label: "Active", color: .green)
                            CommunityStatCard(icon: "calendar.badge.clock", value: "32", label: "Events", color: .orange)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Join Groups
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Join Groups")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        GroupCard(name: "Morning Runners", members: "2,340", category: "Running", color: .orange)
                        GroupCard(name: "Cycling Enthusiasts", members: "1,892", category: "Cycling", color: .blue)
                        GroupCard(name: "Strength Squad", members: "3,120", category: "Strength", color: .red)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Upcoming Events
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Upcoming Events")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        
                        EventCard(name: "5K Charity Run", date: "Sep 3, 2026", participants: "145", color: .green)
                        EventCard(name: "Group Cycling Tour", date: "Sep 10, 2026", participants: "67", color: .blue)
                        EventCard(name: "Beach Workout", date: "Sep 15, 2026", participants: "89", color: .orange)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .background(Theme.pageBackground)
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.large)
        }.appPageTheme()
    }
}

struct CommunityStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct GroupCard: View {
    let name: String
    let members: String
    let category: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: "person.3.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                HStack(spacing: 8) {
                    Text("\(members) members")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(.secondary)
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text(category)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(color)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Join")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(color)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct EventCard: View {
    let name: String
    let date: String
    let participants: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 20))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Text(date)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 10))
                    Text("\(participants) going")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                .foregroundStyle(color)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    RootTabView()
}
#endif
