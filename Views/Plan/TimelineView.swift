import SwiftUI

struct TimelineView: View {
    @Binding var tasks: [PlanTask]
    @Binding var selectedDate: Date

    private let slotHeight: CGFloat = 56
    private let hours = Array(6...22)
    private let timeColWidth: CGFloat = 52

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack(alignment: .topLeading) {
                    // Hour grid rows
                    VStack(spacing: 0) {
                        ForEach(hours, id: \.self) { hour in
                            HStack(spacing: 0) {
                                Text(hourLabel(hour))
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundStyle(.secondary)
                                    .frame(width: timeColWidth, alignment: .trailing)
                                    .padding(.trailing, 10)
                                Rectangle()
                                    .fill(Color.primary.opacity(0.06))
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(height: slotHeight)
                            .id(hour)
                        }
                    }

                    // Task blocks
                    ForEach($tasks) { $task in
                        if hours.contains(task.hour) {
                            let yOffset = CGFloat(task.hour - hours.first!) * slotHeight + 18
                            let blockHeight = CGFloat(task.durationSlots) * slotHeight - 6

                            TaskBlock(task: $task)
                                .frame(height: blockHeight)
                                .padding(.leading, timeColWidth + 14)
                                .padding(.trailing, 14)
                                .offset(y: yOffset)
                        }
                    }

                    // Current time indicator (today only)
                    if Calendar.current.isDateInToday(selectedDate) {
                        currentTimeLine
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .onAppear {
                let hour = Calendar.current.component(.hour, from: Date())
                let target = max(hours.first!, min(hours.last!, hour - 1))
                proxy.scrollTo(target, anchor: .top)
            }
        }
    }

    private var currentTimeLine: some View {
        let now = Date()
        let cal = Calendar.current
        let hour = cal.component(.hour, from: now)
        let minute = cal.component(.minute, from: now)
        guard hours.contains(hour) else { return AnyView(EmptyView()) }
        let offset = CGFloat(hour - hours.first!) * slotHeight + CGFloat(minute) / 60 * slotHeight + 18
        return AnyView(
            HStack(spacing: 0) {
                Circle()
                    .fill(Theme.rose)
                    .frame(width: 8, height: 8)
                    .offset(x: -1)
                Rectangle()
                    .fill(Theme.rose)
                    .frame(height: 1.5)
            }
            .padding(.leading, timeColWidth + 6)
            .offset(y: offset)
            .allowsHitTesting(false)
        )
    }

    private func hourLabel(_ h: Int) -> String {
        h == 0 ? "12 AM" : h < 12 ? "\(h) AM" : h == 12 ? "12 PM" : "\(h - 12) PM"
    }
}

private struct TaskBlock: View {
    @Binding var task: PlanTask

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                task.isDone.toggle()
            }
        } label: {
            HStack(alignment: .top, spacing: 10) {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(task.category.tint)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(task.isDone ? .secondary : .primary)
                        .strikethrough(task.isDone, color: .secondary)
                        .lineLimit(2)
                    HStack(spacing: 6) {
                        Text(task.time)
                            .font(.system(size: 11, design: .rounded))
                            .foregroundStyle(.secondary)
                        categoryPill
                    }
                }
                Spacer()

                if task.isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(task.category.tint)
                        .font(.system(size: 16))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(task.category.tint.opacity(task.isDone ? 0.06 : 0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(task.category.tint.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var categoryPill: some View {
        Text(task.category.rawValue)
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(Capsule().fill(task.category.tint.opacity(0.18)))
            .foregroundStyle(task.category.tint)
    }
}
