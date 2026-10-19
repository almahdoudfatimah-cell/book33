import SwiftUI

public struct PlanView: View {
    @Environment(\.colorScheme) private var scheme
    @State private var selectedDate: Date = Date()
    @State private var tasks: [PlanTask] = SampleData.tasks(for: Date())
    @State private var showAddTask = false
    @State private var weekOffset: Int = 0
    @State private var mode: Mode = .week

    public enum Mode: String, CaseIterable { case week = "Week", day = "Day" }
    
    public init() {}

    private var weekDays: [Date] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        // Sunday-first to match the planner reference (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
        let weekday = cal.component(.weekday, from: today) - 1
        let sunday = cal.date(byAdding: .day, value: -weekday + weekOffset * 7, to: today) ?? today
        return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: sunday) }
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                VStack(spacing: 0) {
                    modePicker
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 4)

                    if mode == .week {
                        ScrollView {
                            weekHeader
                            WeekStickyOverview(
                                days: weekDays,
                                onTapDay: { date in
                                    selectedDate = date
                                    tasks = WeekTaskStore.shared.tasks(for: date)
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                        mode = .day
                                    }
                                }
                            )
                            .padding(.bottom, 40)
                        }
                    } else {
                        WeekStripView(days: weekDays, selected: $selectedDate, weekOffset: $weekOffset)
                            .padding(.top, 4)
                            .padding(.bottom, 8)
                        Divider().opacity(0.15)
                        TimelineView(tasks: $tasks, selectedDate: $selectedDate)
                    }
                }
            }
            .navigationTitle("Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // In week mode, switch to day view first then open sheet
                        if mode == .week {
                            tasks = WeekTaskStore.shared.tasks(for: selectedDate)
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                mode = .day
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                showAddTask = true
                            }
                        } else {
                            showAddTask = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskSheet(tasks: $tasks, date: selectedDate)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            .onChange(of: selectedDate) { _, newDate in
                tasks = SampleData.tasks(for: newDate)
            }
        }.appPageTheme()
    }

    // MARK: - Mode picker
    private var modePicker: some View {
        HStack(spacing: 8) {
            ForEach(Mode.allCases, id: \.self) { m in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) { mode = m }
                } label: {
                    Text(m.rawValue)
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .tracking(0.5)
                        .foregroundStyle(mode == m ? .white : .black.opacity(0.65))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                if mode == m {
                                    Capsule().fill(Theme.heroGradient)
                                } else {
                                    Capsule().fill(.ultraThinMaterial)
                                    Capsule().fill(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.35), Color.white.opacity(0.05)],
                                            startPoint: .top, endPoint: .bottom
                                        )
                                    )
                                }
                            }
                        )
                        .overlay(
                            Capsule().strokeBorder(Color.white.opacity(mode == m ? 0.35 : 0.25), lineWidth: 0.5)
                        )
                        .shadow(color: Color.black.opacity(mode == m ? 0.18 : 0.08), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
            }
            Spacer()
            // Week navigation only meaningful in week mode
            HStack(spacing: 6) {
                Button { withAnimation(.spring(response: 0.35)) { weekOffset -= 1 } } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Theme.primary)
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(.ultraThinMaterial))
                        .overlay(Circle().strokeBorder(Color.white.opacity(0.4), lineWidth: 0.5))
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                }
                Button { withAnimation(.spring(response: 0.35)) { weekOffset += 1 } } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Theme.primary)
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(.ultraThinMaterial))
                        .overlay(Circle().strokeBorder(Color.white.opacity(0.4), lineWidth: 0.5))
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                }
            }
        }
    }

    // MARK: - Week header
    private var weekHeader: some View {
        VStack(spacing: 4) {
            Text(monthLabel)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
                .tracking(1)
        }
        .padding(.top, 10)
    }

    private var monthLabel: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: weekDays.first ?? Date()).uppercased()
    }
}

#Preview { PlanView() }
