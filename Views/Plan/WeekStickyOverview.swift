import SwiftUI

// MARK: - Sticky-note color rotation per weekday
struct StickyDayStyle {
    let bg: Color
    let tape: Color
    let tapeRotation: Double
    let cardRotation: Double
}

enum StickyPalette {
    static func style(for weekday: Int) -> StickyDayStyle {
        switch weekday {
        case 1: return StickyDayStyle(bg: Theme.stickyYellow,  tape: Theme.secondary,  tapeRotation: -6, cardRotation: -1.5)
        case 2: return StickyDayStyle(bg: Theme.stickyCoral,   tape: Theme.mint,       tapeRotation:  4, cardRotation:  1.0)
        case 3: return StickyDayStyle(bg: Theme.stickyPink,    tape: Theme.stickyYellow, tapeRotation: -3, cardRotation: -1.0)
        case 4: return StickyDayStyle(bg: Theme.stickyCoral,   tape: Theme.stickyYellow, tapeRotation:  5, cardRotation:  1.5)
        case 5: return StickyDayStyle(bg: Theme.stickyPeach,   tape: Theme.stickyCoral, tapeRotation: -4, cardRotation: -1.0)
        case 6: return StickyDayStyle(bg: Theme.stickyYellow,  tape: Theme.stickySage, tapeRotation:  3, cardRotation:  1.0)
        default: return StickyDayStyle(bg: Theme.mint,          tape: Theme.secondary,  tapeRotation: -5, cardRotation: -1.5)
        }
    }

    static func dayName(for weekday: Int) -> String {
        ["", "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"][weekday]
    }
}

// MARK: - Weekday sticky-note card
struct WeekdayStickyCard: View {
    let date: Date
    let tasks: [PlanTask]
    var onToggleTask: (PlanTask) -> Void
    var onLongPress: () -> Void
    var onTapHeader: () -> Void

    private var weekday: Int { Calendar.current.component(.weekday, from: date) }
    private var dayNumber: Int { Calendar.current.component(.day, from: date) }
    private var style: StickyDayStyle { StickyPalette.style(for: weekday) }
    private var name: String { StickyPalette.dayName(for: weekday) }
    private var isToday: Bool { Calendar.current.isDateInToday(date) }

    var body: some View {
        ZStack(alignment: .top) {
            // Back shadow card peeking behind (depth)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(style.bg.opacity(0.55))
                .offset(x: 4, y: 4)

            // Main sticky note
            VStack(alignment: .leading, spacing: 8) {
                Spacer().frame(height: 22)
                if tasks.isEmpty {
                    Text("long-press to add")
                        .font(.system(size: 11, design: .rounded).italic())
                        .foregroundStyle(.black.opacity(0.45))
                } else {
                    ForEach(tasks.prefix(4)) { t in
                        bulletRow(t)
                    }
                    if tasks.count > 4 {
                        Text("+\(tasks.count - 4) more")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundStyle(.black.opacity(0.55))
                            .padding(.top, 2)
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, minHeight: 160, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(style.bg)
            )
            .overlay(alignment: .topTrailing) {
                if isToday {
                    Text("\(dayNumber)")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(Circle().fill(Color.black.opacity(0.7)))
                        .padding(8)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: 6))
            .onLongPressGesture(minimumDuration: 0.4, maximumDistance: 50) {
                let gen = UIImpactFeedbackGenerator(style: .medium)
                gen.impactOccurred()
                onLongPress()
            }

            // Washi tape with day name (tappable to open day timeline)
            ZStack {
                Rectangle()
                    .fill(style.tape)
                    .frame(width: 92, height: 22)
                Text(name)
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .tracking(0.6)
                    .foregroundStyle(.black.opacity(0.85))
            }
            .rotationEffect(.degrees(style.tapeRotation))
            .offset(y: -4)
            .onTapGesture { onTapHeader() }
        }
        .rotationEffect(.degrees(style.cardRotation))
        .shadow(color: Color.black.opacity(0.10), radius: 6, x: 0, y: 4)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: tasks)
    }

    @ViewBuilder
    private func bulletRow(_ t: PlanTask) -> some View {
        Button { onToggleTask(t) } label: {
            HStack(alignment: .top, spacing: 6) {
                ZStack {
                    Circle()
                        .strokeBorder(Color.black.opacity(0.7), lineWidth: 1.5)
                        .frame(width: 12, height: 12)
                    if t.isDone {
                        Circle()
                            .fill(Color.black.opacity(0.75))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 3)

                Text(t.title)
                    .font(.system(size: 11.5, weight: .medium, design: .rounded))
                    .foregroundStyle(.black.opacity(t.isDone ? 0.45 : 0.85))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .strikethrough(t.isDone, color: .black.opacity(0.5))
                Spacer(minLength: 0)
            }
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}

// MARK: - Inline add-task sheet (compact)
struct InlineAddTaskSheet: View {
    let date: Date
    let style: StickyDayStyle
    var onAdd: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @FocusState private var focused: Bool

    private var dayName: String {
        StickyPalette.dayName(for: Calendar.current.component(.weekday, from: date)).capitalized
    }

    var body: some View {
        VStack(spacing: 18) {
            Capsule().fill(Color.black.opacity(0.15))
                .frame(width: 40, height: 4)
                .padding(.top, 8)

            HStack {
                ZStack {
                    Rectangle().fill(style.tape).frame(width: 90, height: 20)
                    Text(dayName.uppercased())
                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                        .tracking(0.6)
                        .foregroundStyle(.black.opacity(0.85))
                }
                .rotationEffect(.degrees(style.tapeRotation))
                Spacer()
                Text("New task")
                    .font(.system(.headline, design: .rounded))
            }
            .padding(.horizontal, 4)

            TextField("e.g. Football 8h", text: $text, axis: .vertical)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .focused($focused)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(style.bg.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.08), lineWidth: 1)
                )
                .onSubmit(submit)

            Button(action: submit) {
                Text("Add to \(dayName)")
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(Theme.heroGradient))
            }
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(text.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)

            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 12)
        .background(PaperBackground())
        .onAppear { focused = true }
    }

    private func submit() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onAdd(trimmed)
        dismiss()
    }
}

// MARK: - Habits Tracker Sticker
struct HabitsTrackerSticker: View {
    private let dayLetters = ["S","M","T","W","T","F","S"]
    private let health: [Int] =    [0,1,0,2,0,0,2]
    private let work: [Int] =      [0,0,0,0,0,1,2]
    private let lifestyle: [Int] = [2,0,1,0,1,0,2]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("MY HABITS TRACKER")
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(.primary)
                .padding(.bottom, 2)

            HStack(spacing: 6) {
                tag("MY HABITS", bg: Theme.primary.opacity(0.15))
                Spacer()
                ForEach(0..<7, id: \.self) { i in
                    Text(dayLetters[i])
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(width: 22, height: 22)
                        .background(Circle().fill(Theme.primary))
                }
            }
            row(label: "HEALTH",    bg: Theme.stickyYellow, color: Theme.secondary, data: health)
            row(label: "WORK",      bg: Theme.stickySage,   color: Theme.primary,   data: work)
            row(label: "LIFESTYLE", bg: Theme.stickyCoral,  color: Theme.accent,    data: lifestyle)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func tag(_ text: String, bg: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .heavy, design: .rounded))
            .foregroundStyle(Theme.primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(bg))
    }

    @ViewBuilder
    private func row(label: String, bg: Color, color: Color, data: [Int]) -> some View {
        HStack(spacing: 6) {
            tag(label, bg: bg)
                .frame(minWidth: 90, alignment: .leading)
            Spacer()
            ForEach(0..<7, id: \.self) { i in
                dot(data[i], color: color)
            }
        }
    }

    @ViewBuilder
    private func dot(_ kind: Int, color: Color) -> some View {
        ZStack {
            Circle()
                .strokeBorder(color.opacity(0.7), lineWidth: 1.4)
                .frame(width: 22, height: 22)
            if kind == 1 {
                Circle().fill(color).frame(width: 16, height: 16)
            } else if kind == 2 {
                Circle().fill(Color.gray.opacity(0.55)).frame(width: 16, height: 16)
            }
        }
    }
}

// MARK: - Week sticky overview
struct WeekStickyOverview: View {
    let days: [Date]
    var onTapDay: (Date) -> Void

    @StateObject private var store = WeekTaskStore.shared
    @State private var addingDate: Date?

    private var twoColumns: [GridItem] {
        [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("THIS WEEK")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .tracking(1)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Theme.heroGradient))
                Spacer()
            }
            .padding(.horizontal, 4)

            Text("Tap a bullet to mark done · Long-press a card to add")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)

            LazyVGrid(columns: twoColumns, spacing: 14) {
                ForEach(days, id: \.self) { day in
                    WeekdayStickyCard(
                        date: day,
                        tasks: store.tasks(for: day),
                        onToggleTask: { task in
                            let gen = UIImpactFeedbackGenerator(style: .light)
                            gen.impactOccurred()
                            store.toggleDone(taskId: task.id, on: day)
                        },
                        onLongPress: { addingDate = day },
                        onTapHeader: { onTapDay(day) }
                    )
                }
            }

            HabitsTrackerSticker()
                .padding(.top, 4)

            HStack(spacing: 10) {
                pill("• Tasks", bg: Theme.primary.opacity(0.15), fg: Theme.primary)
                pill("Notes",   bg: .clear, fg: Theme.accent, bordered: true)
                pill("THIS WEEK", bg: Theme.accent, fg: .white)
                Spacer()
                Text("YOU CAN\nDO IT!")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.secondary)
                    .lineSpacing(-2)
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .sheet(item: Binding<DateWrapper?>(
            get: { addingDate.map(DateWrapper.init) },
            set: { addingDate = $0?.date }
        )) { wrapper in
            let weekday = Calendar.current.component(.weekday, from: wrapper.date)
            InlineAddTaskSheet(
                date: wrapper.date,
                style: StickyPalette.style(for: weekday),
                onAdd: { title in
                    store.addTask(title: title, on: wrapper.date)
                }
            )
            .presentationDetents([.height(280)])
            .presentationDragIndicator(.hidden)
        }
    }

    @ViewBuilder
    private func pill(_ text: String, bg: Color, fg: Color, bordered: Bool = false) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .heavy, design: .rounded))
            .tracking(0.5)
            .foregroundStyle(fg)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(bg))
            .overlay(
                Capsule().strokeBorder(bordered ? Theme.primary : .clear, lineWidth: 1.5)
            )
    }
}

// Helper to make Date Identifiable for .sheet(item:)
private struct DateWrapper: Identifiable {
    let date: Date
    var id: TimeInterval { date.timeIntervalSince1970 }
}
