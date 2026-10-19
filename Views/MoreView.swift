import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    MoreRow(title: "Projects", systemImage: "folder.badge.gearshape", tint: .orange) {
                        ProjectsView()
                    }
                    MoreRow(title: "Coach", systemImage: "sparkles", tint: .purple) {
                        CoachView()
                    }
                    MoreRow(title: "Diary", systemImage: "book.closed.fill", tint: .brown) {
                        DiaryView()
                    }
                    MoreRow(title: "Notes", systemImage: "note.text", tint: .yellow) {
                        NotesView()
                    }
                    MoreRow(title: "Inbox", systemImage: "tray.fill", tint: .blue) {
                        CaptureView()
                    }
                    MoreRow(title: "Habits", systemImage: "checklist", tint: .green) {
                        HabitsView()
                    }
                    MoreRow(title: "Affirmations", systemImage: "sparkles.rectangle.stack.fill", tint: .pink) {
                        AffirmationsView()
                    }
                    MoreRow(title: "Profile", systemImage: "person.crop.circle.fill", tint: .indigo) {
                        ProfileView()
                    }
                    MoreRow(title: "Settings", systemImage: "gearshape.fill", tint: .gray) {
                        SettingsView()
                    }
                }

                Section("Discover") {
                    MoreRow(title: "What's New", systemImage: "sparkles", tint: .mint) {
                        NewsView()
                    }
                    MoreRow(title: "Premium", systemImage: "crown.fill", tint: .yellow) {
                        PaywallView()
                    }
                    MoreRow(title: "Onboarding Tour", systemImage: "play.rectangle.fill", tint: .teal) {
                        OnboardingView()
                    }
                    MoreRow(title: "Notifications", systemImage: "bell.badge.fill", tint: .red) {
                        NotificationsSheet()
                    }
                }

                Section("Wellness") {
                    MoreRow(title: "Mood History", systemImage: "face.smiling.fill", tint: .pink) {
                        MoodView()
                    }
                    MoreRow(title: "Affirmations", systemImage: "heart.text.square.fill", tint: .pink) {
                        AffirmationsView()
                    }
                    MoreRow(title: "Habits", systemImage: "flame.fill", tint: .orange) {
                        HabitsView()
                    }
                    MoreRow(title: "Diary", systemImage: "book.fill", tint: .brown) {
                        DiaryView()
                    }
                    MoreRow(title: "Walking Tracking", systemImage: "figure.walk", tint: .green) {
                        PlaceholderView(title: "Walking Tracking",
                                        subtitle: "Track steps, distance and active minutes each day.",
                                        icon: "figure.walk")
                    }
                    MoreRow(title: "Routine", systemImage: "repeat.circle.fill", tint: .purple) {
                        PlaceholderView(title: "Routine",
                                        subtitle: "Build morning and evening routines that stick.",
                                        icon: "repeat.circle.fill")
                    }
                }

                Section("Productivity") {
                    MoreRow(title: "Weekly Plan", systemImage: "calendar", tint: .blue) {
                        PlanView()
                    }
                    MoreRow(title: "Tracking", systemImage: "chart.bar.fill", tint: .indigo) {
                        GoalsView()
                    }
                    MoreRow(title: "Projects", systemImage: "folder.fill", tint: .orange) {
                        ProjectsView()
                    }
                    MoreRow(title: "Quick Capture", systemImage: "tray.fill", tint: .blue) {
                        CaptureView()
                    }
                }
            }.appPageTheme()
            .navigationTitle("More")
        }.appPageTheme()
    }
}

private struct MoreRow<Destination: View>: View {
    let title: String
    let systemImage: String
    let tint: Color
    @ViewBuilder let destination: () -> Destination

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(tint.opacity(0.18))
                        .frame(width: 32, height: 32)
                    Image(systemName: systemImage)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(tint)
                }
                Text(title)
                    .font(.system(.body, design: .rounded, weight: .medium))
            }
            .padding(.vertical, 2)
        }
    }
}

#Preview { MoreView() }
