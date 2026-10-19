import SwiftUI

struct SettingsView: View {
    @StateObject private var auth = AuthManager.shared
    @StateObject private var premium = PremiumStore.shared
    @State private var showSignOutConfirm = false
    @State private var showPaywall = false
    @State private var showTutorial = false

    var body: some View {
        NavigationStack {
            List {
                accountSection
                premiumSection
                featuresSection
                productivitySection
                workSection
                wellnessSection
                mentalHealthSection
                personalizationSection
                remindersSection
                securitySection
                accessibilitySection
                dataSection
                appSection
                integrationsSection
                helpSection
                aboutSection
                supportSection
                dangerSection
            }.appPageTheme()
            .navigationTitle("Settings")
            .confirmationDialog("Sign out of your account?",
                                isPresented: $showSignOutConfirm,
                                titleVisibility: .visible) {
                Button("Sign out", role: .destructive) {
                    auth.signOut()
                }
                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .fullScreenCover(isPresented: $showTutorial) {
                SplashView()
            }
        }.appPageTheme()
    }

    private var featuresSection: some View {
        Section("Features") {
            NavigationLink {
                HabitsView()
            } label: {
                Label("Habits", systemImage: "checklist")
            }
            NavigationLink {
                AffirmationsView()
            } label: {
                Label("Affirmations", systemImage: "sparkles")
            }
            NavigationLink {
                CaptureView()
            } label: {
                Label("Quick Capture", systemImage: "tray.fill")
            }
            NavigationLink {
                DiaryView()
            } label: {
                Label("Diary", systemImage: "book.closed.fill")
            }
            NavigationLink {
                NotesView()
            } label: {
                Label("Notes", systemImage: "note.text")
            }
        }
    }

    private var productivitySection: some View {
        Section("Productivity") {
            NavigationLink {
                PlanView()
            } label: {
                Label("Weekly planner", systemImage: "calendar")
            }
            NavigationLink {
                ProjectsView()
            } label: {
                Label("Projects", systemImage: "folder.badge.gearshape")
            }
            NavigationLink {
                GoalsView()
            } label: {
                Label("Goals & tracking", systemImage: "chart.bar.fill")
            }
            NavigationLink {
                CoachView()
            } label: {
                Label("AI Coach", systemImage: "sparkles.rectangle.stack.fill")
            }
        }
    }

    private var workSection: some View {
        Section("Work") {
            NavigationLink {
                PlaceholderView(title: "Working hours", subtitle: "Set your working schedule and stay productive.", icon: "briefcase.fill")
            } label: {
                Label("Working hours", systemImage: "briefcase.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Focus sessions", subtitle: "Deep work sessions to supercharge your productivity.", icon: "timer")
            } label: {
                Label("Focus sessions", systemImage: "timer")
            }
            NavigationLink {
                PlaceholderView(title: "Pomodoro timer", subtitle: "Work in focused sprints with breaks in between.", icon: "stopwatch.fill")
            } label: {
                Label("Pomodoro timer", systemImage: "stopwatch.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Time tracking", subtitle: "Track where your time goes across tasks and projects.", icon: "clock.badge.checkmark.fill")
            } label: {
                Label("Time tracking", systemImage: "clock.badge.checkmark.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Meeting log", subtitle: "Log and reflect on your meetings.", icon: "person.2.wave.2.fill")
            } label: {
                Label("Meeting log", systemImage: "person.2.wave.2.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Work-life balance", subtitle: "Find harmony between work and personal time.", icon: "scalemass.fill")
            } label: {
                Label("Work-life balance", systemImage: "scalemass.fill")
            }
        }
    }

    private var wellnessSection: some View {
        Section("Wellness") {
            NavigationLink {
                MoodView()
            } label: {
                Label("Mood check-in", systemImage: "face.smiling.fill")
            }
            NavigationLink {
                DiaryView()
            } label: {
                Label("Daily journal", systemImage: "book.closed.fill")
            }
            NavigationLink {
                AffirmationsView()
            } label: {
                Label("Affirmations", systemImage: "heart.text.square.fill")
            }
            NavigationLink {
                HabitsView()
            } label: {
                Label("Habit streaks", systemImage: "flame.fill")
            }
        }
    }

    private var mentalHealthSection: some View {
        Section("Mental Health") {
            NavigationLink {
                PlaceholderView(title: "Breathing exercises", subtitle: "Simple breathing techniques to reduce stress.", icon: "wind")
            } label: {
                Label("Breathing exercises", systemImage: "wind")
            }
            NavigationLink {
                PlaceholderView(title: "Guided meditation", subtitle: "Mindful meditation sessions for clarity and calm.", icon: "leaf.fill")
            } label: {
                Label("Guided meditation", systemImage: "leaf.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Stress check-in", subtitle: "Monitor and manage your stress levels daily.", icon: "heart.text.square.fill")
            } label: {
                Label("Stress check-in", systemImage: "heart.text.square.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Gratitude log", subtitle: "Record what you're grateful for each day.", icon: "hands.sparkles.fill")
            } label: {
                Label("Gratitude log", systemImage: "hands.sparkles.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Sleep wind-down", subtitle: "A peaceful routine to help you sleep better.", icon: "moon.zzz.fill")
            } label: {
                Label("Sleep wind-down", systemImage: "moon.zzz.fill")
            }
            Link(destination: URL(string: "tel:988")!) {
                Label("Crisis helpline", systemImage: "phone.fill")
                    .foregroundStyle(.red)
            }
        }
    }

    private var personalizationSection: some View {
        Section("Personalization") {
            NavigationLink {
                PlaceholderView(title: "App icon", subtitle: "Choose your favorite app icon.", icon: "app.badge.fill")
            } label: {
                Label("App icon", systemImage: "app.badge.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Language", subtitle: "Set your preferred language.", icon: "globe")
            } label: {
                Label("Language", systemImage: "globe")
            }
            NavigationLink {
                PlaceholderView(title: "Sounds & haptics", subtitle: "Customize sounds and haptic feedback.", icon: "speaker.wave.2.fill")
            } label: {
                Label("Sounds & haptics", systemImage: "speaker.wave.2.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Widgets", subtitle: "Add RaceTrian widgets to your home screen.", icon: "square.grid.2x2.fill")
            } label: {
                Label("Widgets", systemImage: "square.grid.2x2.fill")
            }
        }
    }

    private var integrationsSection: some View {
        Section("Integrations") {
            NavigationLink {
                PlaceholderView(title: "Apple Calendar", subtitle: "Sync your tasks and plans with Apple Calendar.", icon: "calendar.badge.plus")
            } label: {
                Label("Apple Calendar", systemImage: "calendar.badge.plus")
            }
            NavigationLink {
                PlaceholderView(title: "Apple Reminders", subtitle: "Import and sync with Apple Reminders.", icon: "checkmark.circle.fill")
            } label: {
                Label("Apple Reminders", systemImage: "checkmark.circle.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Apple Health", subtitle: "Connect your health and activity data.", icon: "heart.fill")
            } label: {
                Label("Apple Health", systemImage: "heart.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Siri Shortcuts", subtitle: "Automate your tasks with Siri Shortcuts.", icon: "mic.fill")
            } label: {
                Label("Siri Shortcuts", systemImage: "mic.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Focus filters", subtitle: "Integrate RaceTrian with iOS Focus modes.", icon: "moon.fill")
            } label: {
                Label("Focus filters", systemImage: "moon.fill")
            }
        }
    }

    private var remindersSection: some View {
        Section("Reminders") {
            NavigationLink {
                PlaceholderView(title: "Daily plan reminder", subtitle: "Get reminded to plan your day every morning.", icon: "bell.fill")
            } label: {
                Label("Daily plan reminder", systemImage: "bell.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Habit reminders", subtitle: "Never miss a habit with smart reminders.", icon: "checklist")
            } label: {
                Label("Habit reminders", systemImage: "checklist")
            }
            NavigationLink {
                PlaceholderView(title: "Mood check-in time", subtitle: "Set a daily time to check in with your mood.", icon: "clock.fill")
            } label: {
                Label("Mood check-in time", systemImage: "clock.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Journal reminder", subtitle: "A gentle nudge to write in your journal.", icon: "book.closed.fill")
            } label: {
                Label("Journal reminder", systemImage: "book.closed.fill")
            }
        }
    }

    private var securitySection: some View {
        Section("Security & Privacy") {
            NavigationLink {
                PlaceholderView(title: "App lock", subtitle: "Lock the app with a PIN for privacy.", icon: "lock.fill")
            } label: {
                Label("App lock", systemImage: "lock.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Biometric unlock", subtitle: "Use Face ID or Touch ID to unlock the app.", icon: "faceid")
            } label: {
                Label("Biometric unlock", systemImage: "faceid")
            }
            NavigationLink {
                PlaceholderView(title: "Hide previews", subtitle: "Hide app content in the iOS app switcher.", icon: "eye.slash.fill")
            } label: {
                Label("Hide previews", systemImage: "eye.slash.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Analytics & tracking", subtitle: "Manage analytics and data collection preferences.", icon: "chart.line.uptrend.xyaxis")
            } label: {
                Label("Analytics & tracking", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
    }

    private var accessibilitySection: some View {
        Section("Accessibility") {
            NavigationLink {
                PlaceholderView(title: "Text size", subtitle: "Adjust text size for better readability.", icon: "textformat.size")
            } label: {
                Label("Text size", systemImage: "textformat.size")
            }
            NavigationLink {
                PlaceholderView(title: "High contrast", subtitle: "Improve visibility with high contrast mode.", icon: "circle.lefthalf.filled")
            } label: {
                Label("High contrast", systemImage: "circle.lefthalf.filled")
            }
            NavigationLink {
                PlaceholderView(title: "Reduce motion", subtitle: "Minimize animations for a calmer experience.", icon: "tortoise.fill")
            } label: {
                Label("Reduce motion", systemImage: "tortoise.fill")
            }
            NavigationLink {
                PlaceholderView(title: "VoiceOver hints", subtitle: "Extra guidance for VoiceOver users.", icon: "speaker.wave.3.fill")
            } label: {
                Label("VoiceOver hints", systemImage: "speaker.wave.3.fill")
            }
        }
    }

    private var helpSection: some View {
        Section("Help") {
            Button {
                showTutorial = true
            } label: {
                Label("Replay tutorial", systemImage: "play.rectangle.fill")
                    .foregroundStyle(.primary)
            }
            NavigationLink {
                PlaceholderView(title: "FAQ", subtitle: "Answers to your most common questions.", icon: "questionmark.circle.fill")
            } label: {
                Label("FAQ", systemImage: "questionmark.circle.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Tips & tricks", subtitle: "Get the most out of RaceTrian.", icon: "lightbulb.fill")
            } label: {
                Label("Tips & tricks", systemImage: "lightbulb.fill")
            }
            NavigationLink {
                NewsView()
            } label: {
                Label("What's new", systemImage: "sparkles")
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            NavigationLink {
                PlaceholderView(title: "Credits", subtitle: "The people behind RaceTrian.", icon: "person.2.fill")
            } label: {
                Label("Credits", systemImage: "person.2.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Acknowledgements", subtitle: "Libraries and resources used in this app.", icon: "doc.append.fill")
            } label: {
                Label("Acknowledgements", systemImage: "doc.append.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Join beta program", subtitle: "Test new features before they launch.", icon: "flask.fill")
            } label: {
                Label("Join beta program", systemImage: "flask.fill")
            }
            NavigationLink {
                PlaceholderView(title: "Send feedback", subtitle: "Share your thoughts and ideas with us.", icon: "bubble.left.and.bubble.right.fill")
            } label: {
                Label("Send feedback", systemImage: "bubble.left.and.bubble.right.fill")
            }
        }
    }

    private var dataSection: some View {
        Section("Data") {
            NavigationLink {
                PlaceholderView(title: "Export data", subtitle: "Export all your data as a file.", icon: "square.and.arrow.up")
            } label: {
                Label("Export data", systemImage: "square.and.arrow.up")
            }
            NavigationLink {
                PlaceholderView(title: "Backup & sync", subtitle: "Back up and sync your data to iCloud.", icon: "icloud.and.arrow.up")
            } label: {
                Label("Backup & sync", systemImage: "icloud.and.arrow.up")
            }
            NavigationLink {
                PlaceholderView(title: "Clear cache", subtitle: "Free up space by clearing the app cache.", icon: "trash")
            } label: {
                Label("Clear cache", systemImage: "trash")
            }
        }
    }

    private var accountSection: some View {
        Section("Account") {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Theme.heroGradient).frame(width: 40, height: 40)
                    Image(systemName: "person.fill")
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(auth.currentDisplayName ?? "Guest")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    if let email = auth.currentEmail {
                        Text(email)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    } else if auth.isGuest {
                        Text("Guest mode")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var premiumSection: some View {
        Section("Premium") {
            if premium.isActive {
                HStack {
                    Image(systemName: "crown.fill").foregroundStyle(Theme.primary)
                    Text("Premium active")
                    Spacer()
                    if let plan = premium.currentPlan {
                        Text(plan.title)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                Button("Restore purchases") {
                    Task { await premium.restore() }
                }
            } else {
                Button {
                    showPaywall = true
                } label: {
                    HStack {
                        Image(systemName: "crown.fill").foregroundStyle(Theme.primary)
                        Text("Upgrade to Premium").foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(.secondary)
                    }
                }
                Button("Restore purchases") {
                    Task { await premium.restore() }
                }
            }
        }
    }

    private var appSection: some View {
        Section("App") {
            NavigationLink {
                ScrollView { NotificationsSection(store: ProfileStore.shared).padding() }
                    .navigationTitle("Notifications")
            } label: {
                Label("Notifications", systemImage: "bell.fill")
            }
            NavigationLink {
                ScrollView { ThemesSection(store: ProfileStore.shared).padding() }
                    .navigationTitle("Theme")
            } label: {
                Label("Theme", systemImage: "paintbrush.fill")
            }
            NavigationLink {
                ScrollView { AppPreferencesSection(store: ProfileStore.shared).padding() }
                    .navigationTitle("Preferences")
            } label: {
                Label("Preferences", systemImage: "slider.horizontal.3")
            }
        }
    }

    private var supportSection: some View {
        Section("Support") {
            Link(destination: URL(string: "mailto:support@example.com")!) {
                Label("Contact support", systemImage: "envelope.fill")
            }
            ShareLink(item: URL(string: "https://example.com/app")!) {
                Label("Share the app", systemImage: "square.and.arrow.up.fill")
            }
            Link(destination: URL(string: "https://apps.apple.com")!) {
                Label("Rate on the App Store", systemImage: "star.fill")
            }
            Link(destination: URL(string: "https://example.com/privacy")!) {
                Label("Privacy Policy", systemImage: "lock.fill")
            }
            Link(destination: URL(string: "https://example.com/terms")!) {
                Label("Terms of Service", systemImage: "doc.text.fill")
            }
            HStack {
                Label("Version", systemImage: "info.circle.fill")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var dangerSection: some View {
        Section {
            Button(role: .destructive) {
                showSignOutConfirm = true
            } label: {
                Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
            }
        }
    }
}

#Preview { SettingsView() }
