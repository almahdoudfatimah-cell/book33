import SwiftUI

struct AddTaskSheet: View {
    @Binding var tasks: [PlanTask]
    let date: Date

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    @State private var title = ""
    @State private var selectedCategory: TaskCategory = .focus
    @State private var selectedHour: Int = 9
    @State private var durationSlots: Int = 2

    private let hours = Array(6...22)

    var body: some View {
        ZStack {
            PaperBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    titleField
                    categoryPicker
                    timePicker
                    durationPicker
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .safeAreaInset(edge: .bottom) {
            addButton
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(.ultraThinMaterial)
        }
    }

    // MARK: Sub-sections
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("New Task")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Text(dateLabel)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var titleField: some View {
        TextField("Task title…", text: $title)
            .font(.system(size: 16, design: .rounded))
            .padding(14)
            .glassCard(cornerRadius: 16)
    }

    private var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            HStack(spacing: 8) {
                ForEach(TaskCategory.allCases, id: \.self) { cat in
                    let sel = cat == selectedCategory
                    Button { withAnimation { selectedCategory = cat } } label: {
                        VStack(spacing: 4) {
                            Image(systemName: cat.icon)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(sel ? .white : cat.tint)
                            Text(cat.rawValue)
                                .font(.system(size: 9, weight: .semibold, design: .rounded))
                                .foregroundStyle(sel ? .white : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(sel ? cat.tint : cat.tint.opacity(0.12))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var timePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Start Time")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(hours, id: \.self) { h in
                        let sel = h == selectedHour
                        Button { withAnimation { selectedHour = h } } label: {
                            Text(hourLabel(h))
                                .font(.system(size: 12, weight: sel ? .bold : .medium, design: .rounded))
                                .foregroundStyle(sel ? .white : .primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(sel ? Theme.primary : Color.primary.opacity(0.08))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private var durationPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Duration")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            HStack(spacing: 10) {
                ForEach([1,2,3,4,6], id: \.self) { slots in
                    let sel = slots == durationSlots
                    let label = slots == 1 ? "30m" : slots == 2 ? "1h" : slots == 3 ? "1.5h" : slots == 4 ? "2h" : "3h"
                    Button { withAnimation { durationSlots = slots } } label: {
                        Text(label)
                            .font(.system(size: 13, weight: sel ? .bold : .medium, design: .rounded))
                            .foregroundStyle(sel ? .white : .primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(
                                Capsule().fill(sel ? Theme.secondary : Color.primary.opacity(0.08))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var addButton: some View {
        Button {
            let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedTitle.isEmpty else { return }
            let newTask = PlanTask(
                title: trimmedTitle,
                time: "\(hourLabel(selectedHour))",
                hour: selectedHour,
                durationSlots: durationSlots,
                category: selectedCategory,
                isDone: false,
                aiSuggested: false,
                date: date
            )
            withAnimation { tasks.append(newTask) }
            dismiss()
        } label: {
            Text("Add Task")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Theme.heroGradient)
                )
                .shadow(color: Theme.primary.opacity(0.35), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .opacity(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.55 : 1)
    }

    private var dateLabel: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        return f.string(from: date)
    }

    private func hourLabel(_ h: Int) -> String {
        h == 0 ? "12 AM" : h < 12 ? "\(h) AM" : h == 12 ? "12 PM" : "\(h - 12) PM"
    }
}
