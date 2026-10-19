import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) private var scheme
    @StateObject private var moodStore = MoodStore.shared
    @State private var tasks: [PlanTask] = SampleData.tasks(for: Date())
    @State private var showingAIPlanner = false
    @State private var showingNotifications = false
    @State private var showingAddTask = false
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    private var completion: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(tasks.filter { $0.isDone }.count) / Double(tasks.count)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                PaperBackground()
                ScrollView {
                    VStack(spacing: isIPad ? 26 : 20) {
                        HomeHeroCard(completion: completion,
                                     doneCount: tasks.filter { $0.isDone }.count,
                                     totalCount: tasks.count)
                        MetricsRow()
                        MoodCheckinBanner()
                        PremiumNudgeBanner()
                        AIInsightCard(action: { showingAIPlanner = true })
                        TodayPlanSection(tasks: $tasks, onAdd: { showingAddTask = true })
                        HomePlanBoard()
                        GoalsCarousel()
                        ProjectsHomeSection()
                        Color.clear.frame(height: isIPad ? 40 : 32)
                    }
                    .padding(.horizontal, isIPad ? 24 : 18)
                    .padding(.top, isIPad ? 12 : 8)
                }
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingNotifications = true } label: {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: isIPad ? 28 : 17))
                            .foregroundStyle(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAIPlanner) {
                AIPlannerSheet()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingNotifications) {
                NotificationsSheet()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskSheet(tasks: $tasks, date: Date())
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }.appPageTheme()
    }
}

private struct GreetingTitle: View {
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(greeting())
                .font(.system(size: isIPad ? 36 : 13, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
            Text("Hey, Alex")
                .font(.system(size: isIPad ? 42 : 18, weight: .bold, design: .rounded))
        }
    }
    private func greeting() -> String {
        let h = Calendar.current.component(.hour, from: Date())
        switch h {
        case 5..<12: return "Good morning ☀️"
        case 12..<17: return "Good afternoon 🌤"
        case 17..<22: return "Good evening 🌙"
        default: return "Hello, night owl ✨"
        }
    }
}

#Preview { HomeView() }
