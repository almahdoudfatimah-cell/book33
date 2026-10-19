import SwiftUI

struct TodayPlanSection: View {
    @Binding var tasks: [PlanTask]
    var onAdd: () -> Void = {}
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            sectionHeader
            if tasks.isEmpty {
                EmptyPlanView()
            } else {
                VStack(spacing: isIPad ? 14 : 10) {
                    ForEach(Array(tasks.enumerated()), id: \.element.id) { idx, _ in
                        TaskRow(task: $tasks[idx])
                    }
                }
            }
        }
    }

    private var sectionHeader: some View {
        HStack {
            Text("Today's Plan")
                .font(.system(size: isIPad ? 24 : 20, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            Spacer()
            Button { onAdd() } label: {
                Label("Add", systemImage: "plus")
                    .font(.system(size: isIPad ? 16 : 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.primary)
            }
        }
    }
}

private struct TaskRow: View {
    @Binding var task: PlanTask
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        HStack(spacing: isIPad ? 18 : 14) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { task.isDone.toggle() }
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(task.category.tint.opacity(0.5), lineWidth: isIPad ? 2.5 : 2)
                        .frame(width: isIPad ? 34 : 26, height: isIPad ? 34 : 26)
                    if task.isDone {
                        Circle().fill(task.category.tint).frame(width: isIPad ? 34 : 26, height: isIPad ? 34 : 26)
                        Image(systemName: "checkmark")
                            .font(.system(size: isIPad ? 17 : 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: isIPad ? 50 : 44, height: isIPad ? 50 : 44)
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())

            VStack(alignment: .leading, spacing: isIPad ? 6 : 4) {
                Text(task.title)
                    .font(.system(size: isIPad ? 18 : 15, weight: .semibold, design: .rounded))
                    .strikethrough(task.isDone)
                    .foregroundStyle(task.isDone ? .secondary : .primary)
                HStack(spacing: isIPad ? 12 : 8) {
                    Label(task.time, systemImage: "clock")
                        .font(.system(size: isIPad ? 14 : 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                    Text(task.category.rawValue)
                        .font(.system(size: isIPad ? 12 : 10, weight: .bold, design: .rounded))
                        .foregroundStyle(task.category.tint)
                        .padding(.horizontal, isIPad ? 10 : 7)
                        .padding(.vertical, isIPad ? 4 : 2)
                        .background(Capsule().fill(task.category.tint.opacity(0.15)))
                }
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(task.category.tint.opacity(0.18))
                    .frame(width: isIPad ? 44 : 36, height: isIPad ? 44 : 36)
                Image(systemName: task.category.icon)
                    .font(.system(size: isIPad ? 19 : 15, weight: .semibold))
                    .foregroundStyle(task.category.tint)
            }
        }
        .padding(.horizontal, isIPad ? 20 : 14)
        .padding(.vertical, isIPad ? 16 : 12)
        .glassCard(cornerRadius: isIPad ? 24 : 18)
        .opacity(task.isDone ? 0.65 : 1.0)
    }
}

private struct EmptyPlanView: View {
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(spacing: isIPad ? 16 : 12) {
            Image(systemName: "sparkles")
                .font(.system(size: isIPad ? 38 : 32))
                .foregroundStyle(Theme.primary)
            Text("No plans yet")
                .font(.system(size: isIPad ? 19 : 15, weight: .bold, design: .rounded))
            Text("Tap + to let AI craft your perfect day.")
                .font(.system(size: isIPad ? 16 : 13, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(isIPad ? 36 : 28)
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: isIPad ? 26 : 20)
    }
}
