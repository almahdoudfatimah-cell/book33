import SwiftUI

struct NewsView: View {
    @State private var page: Int = 0

    private let items: [NewsItem] = [
        NewsItem(
            icon: "sparkles",
            title: "AI credits on Today",
            body: "Your free AI credits now appear on the Today screen so you always know what's left.",
            tag: "New"
        ),
        NewsItem(
            icon: "checklist",
            title: "Quick-add habits",
            body: "Tap a preset chip — Sports, Sleeping hours, Studying hours and more — to start a habit in one tap.",
            tag: "Improved"
        ),
        NewsItem(
            icon: "gearshape.fill",
            title: "More in Settings",
            body: "Productivity, Wellness, Reminders, Security, Accessibility and Integrations are all here now.",
            tag: "New"
        ),
        NewsItem(
            icon: "briefcase.fill",
            title: "Work tools",
            body: "Working hours, focus sessions, Pomodoro timer and time tracking are now grouped under Work in Settings.",
            tag: "New"
        ),
        NewsItem(
            icon: "leaf.fill",
            title: "Mental health hub",
            body: "Breathing exercises, guided meditation, stress check-ins and a crisis helpline shortcut.",
            tag: "New"
        ),
        NewsItem(
            icon: "lock.fill",
            title: "Security & privacy",
            body: "App lock, biometric unlock and preview hiding to keep your planner private.",
            tag: "New"
        ),
        NewsItem(
            icon: "figure.wave",
            title: "Accessibility upgrades",
            body: "Text size, high contrast, reduce motion and richer VoiceOver hints throughout the app.",
            tag: "Improved"
        ),
        NewsItem(
            icon: "calendar.badge.plus",
            title: "Integrations",
            body: "Apple Calendar, Reminders, Health, Siri Shortcuts and Focus filters all in one place.",
            tag: "New"
        ),
        NewsItem(
            icon: "icloud.and.arrow.up",
            title: "Backup & export",
            body: "Export your data or back it up to iCloud so nothing important is ever lost.",
            tag: "New"
        ),
        NewsItem(
            icon: "bell.badge.fill",
            title: "Smarter reminders",
            body: "Daily plan, habit, mood and journal reminders — each with its own custom time.",
            tag: "New"
        ),
        NewsItem(
            icon: "questionmark.circle.fill",
            title: "Help & tutorials",
            body: "Replay the onboarding tour, browse the FAQ, and discover tips & tricks any time.",
            tag: "New"
        ),
        NewsItem(
            icon: "paintbrush.fill",
            title: "Personalization",
            body: "Pick a new app icon, language, sound pack and add widgets to your Home Screen.",
            tag: "New"
        )
    ]

    var body: some View {
        TabView(selection: $page) {
            ForEach(items.indices, id: \.self) { index in
                NewsPage(item: items[index], pageIndex: index, totalPages: items.count)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationTitle("What's New")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct NewsItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let body: String
    let tag: String
}

private struct NewsPage: View {
    let item: NewsItem
    let pageIndex: Int
    let totalPages: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("\(pageIndex + 1) of \(totalPages)")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)

            ZStack {
                Circle()
                    .fill(Theme.primary.opacity(0.15))
                    .frame(width: 110, height: 110)
                Image(systemName: item.icon)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(Theme.primary)
            }

            Text(item.tag.uppercased())
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundStyle(Theme.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Capsule().fill(Theme.primary.opacity(0.12)))

            Text(item.title)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)

            Text(item.body)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer(minLength: 30)
        }
        .padding(.top, 30)
        .padding(.bottom, 60)
    }
}

#Preview {
    NavigationStack { NewsView() }.appPageTheme()
}
