import SwiftUI

struct WeekStripView: View {
    let days: [Date]
    @Binding var selected: Date
    @Binding var weekOffset: Int

    private let cal = Calendar.current
    private let dayLetters = ["M","T","W","T","F","S","S"]

    var body: some View {
        VStack(spacing: 8) {
            // Month + navigation
            HStack {
                Button { withAnimation(.spring(response: 0.35)) { weekOffset -= 1 } } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.primary)
                }
                Spacer()
                Text(monthLabel)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                Spacer()
                Button { withAnimation(.spring(response: 0.35)) { weekOffset += 1 } } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.primary)
                }
            }
            .padding(.horizontal, 20)

            // Day pills
            HStack(spacing: 6) {
                ForEach(Array(days.enumerated()), id: \.offset) { idx, day in
                    let isSelected = cal.isDate(day, inSameDayAs: selected)
                    let isToday = cal.isDateInToday(day)
                    Button { withAnimation(.spring(response: 0.3)) { selected = day } } label: {
                        VStack(spacing: 5) {
                            Text(dayLetters[idx % 7])
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(isSelected ? .white : .secondary)
                            Text("\(cal.component(.day, from: day))")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundStyle(isSelected ? .white : isToday ? Theme.primary : .primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Theme.heroGradient)
                            } else if isToday {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(Theme.primary.opacity(0.5), lineWidth: 1.5)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
        }
    }

    private var monthLabel: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: days.first ?? Date())
    }
}
