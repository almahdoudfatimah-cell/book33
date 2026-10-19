import SwiftUI

struct DayScheduleSection: View {
    @ObservedObject var store: ProfileStore
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            sectionHeader(title: "Day Schedule", subtitle: "Your typical wake & sleep times", icon: "moon.stars.fill")

            HStack(spacing: isIPad ? 16 : 12) {
                scheduleCard(
                    icon: "sun.rise.fill",
                    label: "Wake up",
                    color: Theme.accent,
                    options: DaySchedule.wakeOptions,
                    selected: $store.wakeHour
                )
                scheduleCard(
                    icon: "moon.fill",
                    label: "Bedtime",
                    color: Theme.secondary,
                    options: DaySchedule.sleepOptions,
                    selected: $store.sleepHour
                )
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }

    private func scheduleCard(icon: String, label: String, color: Color,
                              options: [Int], selected: Binding<Int>) -> some View {
        VStack(spacing: isIPad ? 14 : 10) {
            Image(systemName: icon)
                .font(.system(size: isIPad ? 28 : 22))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: isIPad ? 16 : 12, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)

            Picker(label, selection: selected) {
                ForEach(options, id: \.self) { h in
                    Text(DaySchedule.label(h)).tag(h)
                        .font(.system(size: isIPad ? 17 : 13, design: .rounded))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: isIPad ? 100 : 90)
            .clipped()
        }
        .frame(maxWidth: .infinity)
        .padding(isIPad ? 16 : 12)
        .background(
            RoundedRectangle(cornerRadius: isIPad ? 20 : 16, style: .continuous)
                .fill(color.opacity(0.08))
        )
    }
}
