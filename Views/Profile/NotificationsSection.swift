import SwiftUI

struct NotificationsSection: View {
    @ObservedObject var store: ProfileStore
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            sectionHeader(title: "Notifications", subtitle: "Stay on track with smart reminders", icon: "bell.badge.fill")

            VStack(spacing: 0) {
                // Morning briefing with time selector
                notifToggleRow(
                    icon: "sun.max.fill", iconColor: Theme.accent,
                    title: "Morning Briefing",
                    subtitle: "Daily AI plan delivered at \(DaySchedule.label(store.morningNotifHour))",
                    isOn: $store.morningBriefing
                )

                if store.morningBriefing {
                    timePickerRow(
                        label: "Briefing time",
                        options: Array(5...12),
                        selected: $store.morningNotifHour
                    )
                }

                rowDivider

                // Evening review with time selector
                notifToggleRow(
                    icon: "moon.fill", iconColor: Theme.secondary,
                    title: "Evening Review",
                    subtitle: "Reflect on your day at \(DaySchedule.label(store.eveningNotifHour))",
                    isOn: $store.eveningReview
                )

                if store.eveningReview {
                    timePickerRow(
                        label: "Review time",
                        options: Array(18...23),
                        selected: $store.eveningNotifHour
                    )
                }

                rowDivider

                notifToggleRow(
                    icon: "flame.fill", iconColor: Theme.rose,
                    title: "Habit Reminders",
                    subtitle: "Nudges to keep your streaks alive",
                    isOn: $store.habitReminders
                )

                rowDivider

                notifToggleRow(
                    icon: "brain.head.profile", iconColor: Theme.primary,
                    title: "Focus Alerts",
                    subtitle: "Reminders to start your focus blocks",
                    isOn: $store.focusAlerts
                )

                rowDivider

                notifToggleRow(
                    icon: "sparkles", iconColor: Theme.mint,
                    title: "AI Insights",
                    subtitle: "Personalised tips from your coach",
                    isOn: $store.aiInsights
                )

                rowDivider

                notifToggleRow(
                    icon: "chart.bar.fill", iconColor: Theme.secondary,
                    title: "Weekly Report",
                    subtitle: "Your productivity summary every Sunday",
                    isOn: $store.weeklyReport
                )
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }

    private var rowDivider: some View {
        Divider().padding(.leading, isIPad ? 54 : 46).opacity(0.4)
    }
    
    private func sectionHeader(title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: isIPad ? 14 : 10) {
            Image(systemName: icon)
                .font(.system(size: isIPad ? 18 : 14, weight: .semibold))
                .foregroundStyle(Theme.primary)
                .frame(width: isIPad ? 42 : 30, height: isIPad ? 42 : 30)
                .background(Circle().fill(Theme.primary.opacity(0.12)))
            VStack(alignment: .leading, spacing: isIPad ? 3 : 1) {
                Text(title)
                    .font(.system(size: isIPad ? 24 : 16, weight: .bold, design: .rounded))
                Text(subtitle)
                    .font(.system(size: isIPad ? 18 : 12, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    private func notifToggleRow(icon: String, iconColor: Color,
                                 title: String, subtitle: String,
                                 isOn: Binding<Bool>) -> some View {
        HStack(spacing: isIPad ? 16 : 12) {
            Image(systemName: icon)
                .font(.system(size: isIPad ? 18 : 14, weight: .semibold))
                .foregroundStyle(iconColor)
                .frame(width: isIPad ? 42 : 30, height: isIPad ? 42 : 30)
                .background(Circle().fill(iconColor.opacity(0.12)))

            VStack(alignment: .leading, spacing: isIPad ? 4 : 2) {
                Text(title)
                    .font(.system(size: isIPad ? 18 : 14, weight: .semibold, design: .rounded))
                Text(subtitle)
                    .font(.system(size: isIPad ? 16 : 12, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Toggle(isOn: isOn) {}
                .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
        }
        .padding(.vertical, isIPad ? 12 : 10)
        .contentShape(Rectangle())
    }

    private func timePickerRow(label: String, options: [Int], selected: Binding<Int>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: isIPad ? 16 : 12, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.leading, isIPad ? 48 : 42)
            Spacer()
            Picker(label, selection: selected) {
                ForEach(options, id: \.self) { h in
                    Text(DaySchedule.label(h)).tag(h)
                }
            }
            .pickerStyle(.menu)
            .tint(Theme.primary)
            .font(.system(size: isIPad ? 17 : 13, design: .rounded))
        }
        .padding(.bottom, isIPad ? 10 : 6)
    }
}
