import SwiftUI

private enum HomePlanDestination: String, CaseIterable, Identifiable {
    case weekly
    case monthly
    case weekend
    case vacation
    case travel
    case training
    case achievement
    case raceVision
    
    var id: String { rawValue }
    
    var title: LocalizedStringResource {
        switch self {
        case .weekly: "Weekly Plan"
        case .monthly: "Monthly Plan"
        case .weekend: "Weekend Plan"
        case .vacation: "Vacation Plan"
        case .travel: "Travel Plan"
        case .training: "Train & Track"
        case .achievement: "Achievement Timer"
        case .raceVision: "Year Race Vision"
        }
    }
    
    var subtitle: LocalizedStringResource {
        switch self {
        case .weekly: "Build the next 7 days"
        case .monthly: "Set this month's focus"
        case .weekend: "Plan rest and activity"
        case .vacation: "Keep holidays organized"
        case .travel: "Prepare trips and workouts"
        case .training: "All sports and tracking"
        case .achievement: "Time your goal sessions"
        case .raceVision: "Map the racing year"
        }
    }
    
    var icon: String {
        switch self {
        case .weekly: "calendar.badge.clock"
        case .monthly: "calendar"
        case .weekend: "sun.max.fill"
        case .vacation: "beach.umbrella.fill"
        case .travel: "airplane"
        case .training: "figure.run"
        case .achievement: "stopwatch.fill"
        case .raceVision: "flag.checkered"
        }
    }
    
    var color: Color {
        switch self {
        case .weekly: Theme.primary
        case .monthly: .blue
        case .weekend: Theme.accent
        case .vacation: .cyan
        case .travel: .indigo
        case .training: Theme.secondary
        case .achievement: .purple
        case .raceVision: Theme.rose
        }
    }
    
    var chatbotPrompt: String {
        switch self {
        case .weekly:
            String(localized: "Help me create a realistic weekly plan. Ask about my priorities, available time, training, rest, and important deadlines, then build a seven-day schedule.")
        case .monthly:
            String(localized: "Help me create a monthly plan. Ask about my main goals, milestones, habits, training schedule, and recovery days, then organize them week by week.")
        case .weekend:
            String(localized: "Help me plan my weekend. Balance training, recovery, personal tasks, family time, and something enjoyable. Ask me questions before creating the plan.")
        case .vacation:
            String(localized: "Help me create a vacation plan with dates, activities, rest, fitness, packing, reservations, and a simple daily schedule. Ask for the missing details first.")
        case .travel:
            String(localized: "Help me create a travel plan. Ask about destination, dates, budget, transport, accommodation, activities, packing, and how I want to keep training while traveling.")
        case .training:
            String(localized: "Be my sports training planner. Ask which sports I practice, my level, goals, available days, equipment, injuries, and event dates. Create a training plan and tell me which metrics to track for every selected sport.")
        case .achievement:
            String(localized: "Help me build an achievement plan using timed focus sessions. Ask about the achievement, deadline, available time, and milestones. Then create tasks with a recommended timer duration for each session.")
        case .raceVision:
            String(localized: "Help me create my race vision for this year. Ask about my target races, dates, distances, current fitness, personal records, and dream achievement. Then build a month-by-month roadmap.")
        }
    }
}

struct HomePlanBoard: View {
    private let destinations = HomePlanDestination.allCases
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("AI Plan Board")
                        .font(.title3.bold())
                        .foregroundStyle(.black)
                    Text("Choose a plan and build it with your chatbot")
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.68))
                }
                
                Spacer()
                
                Image(systemName: "rectangle.grid.2x2.fill")
                    .foregroundStyle(Theme.primary)
                    .accessibilityHidden(true)
            }
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(destinations) { destination in
                    NavigationLink {
                        planDestination(destination)
                    } label: {
                        HomePlanButton(
                            title: destination.title,
                            subtitle: destination.subtitle,
                            icon: destination.icon,
                            color: destination.color
                        )
                    }
                    .buttonStyle(PressScaleButtonStyle())
                }
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 22, tint: Theme.primary)
    }
    
    @ViewBuilder
    private func planDestination(_ destination: HomePlanDestination) -> some View {
        if destination == .raceVision {
            RaceVisionYearView()
        } else {
            PlanChatbotView(
                title: destination.title,
                starterPrompt: destination.chatbotPrompt,
                icon: destination.icon,
                color: destination.color,
                showsTimer: destination == .achievement
            )
        }
    }
}

private struct HomePlanButton: View {
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(color.gradient, in: RoundedRectangle(cornerRadius: 11))
            
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.black)
            
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.black.opacity(0.68))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 126, alignment: .topLeading)
        .padding(14)
        .background(color.opacity(0.10), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(color.opacity(0.22))
        }
    }
}

private struct PlanChatbotView: View {
    let title: LocalizedStringResource
    let starterPrompt: String
    let icon: String
    let color: Color
    let showsTimer: Bool
    
    @StateObject private var viewModel = CoachViewModel()
    @ObservedObject private var premium = PremiumStore.shared
    @State private var inputText = ""
    @State private var didStartConversation = false
    @State private var showingScheduleSheet = false
    @FocusState private var inputFocused: Bool
    
    var body: some View {
        ZStack {
            PaperBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                PlanChatHeader(title: title, icon: icon, color: color)
                
                if showsTimer {
                    PlanChatTimer(color: color)
                }
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                            
                            if viewModel.isThinking {
                                HStack(spacing: 10) {
                                    ProgressView()
                                        .tint(color)
                                    Text("Building your plan…")
                                        .font(.subheadline)
                                        .foregroundStyle(.black.opacity(0.68))
                                    Spacer()
                                }
                                .padding(14)
                                .glassCard(cornerRadius: 16, tint: color)
                                .id("thinking")
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) { _, _ in
                        scrollToBottom(proxy)
                    }
                    .onChange(of: viewModel.isThinking) { _, _ in
                        scrollToBottom(proxy)
                    }
                }

                if latestAssistantPlan != nil && !viewModel.isThinking {
                    Button {
                        showingScheduleSheet = true
                    } label: {
                        Label("Add This Plan to Schedule", systemImage: "calendar.badge.plus")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(color.gradient, in: RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                HStack(spacing: 10) {
                    TextField("Message your planning chatbot…", text: $inputText, axis: .vertical)
                        .lineLimit(1...4)
                        .focused($inputFocused)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 11)
                        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 20))
                        .foregroundStyle(.black)
                    
                    Button {
                        Task { await sendInput() }
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(color.gradient, in: Circle())
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isThinking)
                    .accessibilityLabel("Send message")
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingScheduleSheet) {
            if let plan = latestAssistantPlan {
                AIPlanScheduleSheet(
                    planTitle: String(localized: title),
                    planText: plan
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
        .task {
            guard !didStartConversation else { return }
            didStartConversation = true
            premium.consumeCoachMessage()
            await viewModel.send(text: starterPrompt)
        }
        .appPageTheme()
    }
    
    private var latestAssistantPlan: String? {
        viewModel.messages.last(where: { $0.role == .assistant && !$0.content.isEmpty })?.content
    }

    private func sendInput() async {
        let message = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }
        inputText = ""
        inputFocused = false
        premium.consumeCoachMessage()
        await viewModel.send(text: message)
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.25)) {
            if viewModel.isThinking {
                proxy.scrollTo("thinking", anchor: .bottom)
            } else if let lastMessage = viewModel.messages.last {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

private struct AIPlanScheduleItem: Identifiable {
    let id = UUID()
    var title: String
    var isIncluded = true
}

private struct AIPlanScheduleSheet: View {
    let planTitle: String
    let planText: String

    @Environment(\.dismiss) private var dismiss
    @State private var startDate = Date()
    @State private var items: [AIPlanScheduleItem]

    init(planTitle: String, planText: String) {
        self.planTitle = planTitle
        self.planText = planText
        _items = State(initialValue: Self.extractScheduleItems(from: planText))
    }

    private var selectedCount: Int {
        items.filter(\.isIncluded).count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()

                List {
                    Section {
                        DatePicker(
                            "Schedule begins",
                            selection: $startDate,
                            in: Calendar.current.startOfDay(for: Date())...,
                            displayedComponents: .date
                        )
                    } header: {
                        Text("Start Date")
                    } footer: {
                        Text("Each selected plan item will be scheduled on the next day.")
                    }

                    Section {
                        if items.isEmpty {
                            ContentUnavailableView(
                                "No schedule items found",
                                systemImage: "calendar.badge.exclamationmark",
                                description: Text("Ask the AI chatbot for a plan with clear daily steps, then try again.")
                            )
                        } else {
                            ForEach($items) { $item in
                                Toggle(isOn: $item.isIncluded) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(item.title)
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                            .foregroundStyle(.black)
                                        if let index = items.firstIndex(where: { $0.id == item.id }) {
                                            Text(scheduledDate(for: index), format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                                                .font(.caption)
                                                .foregroundStyle(.black.opacity(0.58))
                                        }
                                    }
                                }
                                .tint(Theme.primary)
                            }
                        }
                    } header: {
                        HStack {
                            Text("Review Schedule")
                            Spacer()
                            Text("\(selectedCount) selected")
                        }
                    }

                    Section {
                        Button {
                            addToSchedule()
                        } label: {
                            Label("Send to Plan Calendar", systemImage: "calendar.badge.plus")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                                .background(Theme.heroGradient, in: RoundedRectangle(cornerRadius: 15))
                        }
                        .buttonStyle(.plain)
                        .disabled(selectedCount == 0)
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(planTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .appPageTheme()
    }

    private func scheduledDate(for index: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: index, to: startDate) ?? startDate
    }

    private func addToSchedule() {
        var scheduledOffset = 0
        for item in items where item.isIncluded {
            let date = Calendar.current.date(byAdding: .day, value: scheduledOffset, to: startDate) ?? startDate
            WeekTaskStore.shared.addTask(title: item.title, on: date)
            scheduledOffset += 1
        }

        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            NotificationCenter.default.post(name: .switchTab, object: 1)
        }
    }

    private static func extractScheduleItems(from text: String) -> [AIPlanScheduleItem] {
        let ignoredPrefixes = ["here", "plan", "summary", "goal", "note", "tips"]
        let cleaned = text
            .components(separatedBy: .newlines)
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "-•*#0123456789. ):"))
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .filter { line in
                guard line.count >= 4, line.count <= 120 else { return false }
                let lower = line.lowercased()
                return !ignoredPrefixes.contains(where: { lower.hasPrefix($0 + ":") })
            }

        let unique = cleaned.reduce(into: [String]()) { result, item in
            if !result.contains(item) {
                result.append(item)
            }
        }

        let scheduleItems = Array(unique.prefix(14))
        if scheduleItems.isEmpty {
            return [AIPlanScheduleItem(title: "Review and begin the AI plan")]
        }
        return scheduleItems.map { AIPlanScheduleItem(title: $0) }
    }
}

private struct PlanChatHeader: View {
    let title: LocalizedStringResource
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3.bold())
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(color.gradient, in: RoundedRectangle(cornerRadius: 14))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.black)
                Text("AI planning chatbot")
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.68))
            }
            
            Spacer()
            
            HStack(spacing: 5) {
                Circle()
                    .fill(Theme.secondary)
                    .frame(width: 8, height: 8)
                Text("Online")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.black)
            }
        }
        .padding()
        .background(Theme.surface)
    }
}

private struct PlanChatTimer: View {
    let color: Color
    
    @State private var isRunning = false
    @State private var startedAt = Date()
    @State private var savedDuration: TimeInterval = 0
    
    var body: some View {
        HStack(spacing: 12) {
            SwiftUI.TimelineView(.periodic(from: .now, by: 1)) { context in
                Text(duration(at: context.date), format: .time(pattern: .hourMinuteSecond))
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .monospacedDigit()
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            Button(isRunning ? "Pause" : "Start") {
                toggle()
            }
            .buttonStyle(.borderedProminent)
            .tint(color)
            
            Button("Reset") {
                isRunning = false
                savedDuration = 0
                startedAt = Date()
            }
            .buttonStyle(.bordered)
            .tint(color)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(color.opacity(0.10))
    }
    
    private func duration(at date: Date) -> Duration {
        .seconds(savedDuration + (isRunning ? date.timeIntervalSince(startedAt) : 0))
    }
    
    private func toggle() {
        if isRunning {
            savedDuration += Date().timeIntervalSince(startedAt)
        } else {
            startedAt = Date()
        }
        isRunning.toggle()
    }
}

private struct PersonalPlanItem: Identifiable {
    let id = UUID()
    let title: String
}

private struct PersonalPlanView: View {
    let title: LocalizedStringResource
    let prompt: LocalizedStringResource
    let icon: String
    let color: Color
    
    @State private var newItem = ""
    @State private var items: [PersonalPlanItem] = []
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    TextField(prompt, text: $newItem)
                        .textInputAutocapitalization(.sentences)
                        .submitLabel(.done)
                        .onSubmit(addItem)
                    
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(color)
                    }
                    .disabled(newItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel("Add plan item")
                }
            } header: {
                Label("Add to plan", systemImage: icon)
            }
            
            Section("Plan Board") {
                if items.isEmpty {
                    ContentUnavailableView(
                        "Your plan is ready to build",
                        systemImage: "list.clipboard",
                        description: Text("Add your first item above.")
                    )
                } else {
                    ForEach(items) { item in
                        Label(item.title, systemImage: "circle")
                    }
                    .onDelete { offsets in
                        items.remove(atOffsets: offsets)
                    }
                }
            }
        }
        .navigationTitle(title)
        .appPageTheme()
    }
    
    private func addItem() {
        let trimmedItem = newItem.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedItem.isEmpty else { return }
        items.append(PersonalPlanItem(title: trimmedItem))
        newItem = ""
    }
}

private struct AchievementTimerView: View {
    @State private var isRunning = false
    @State private var sessionStart = Date()
    @State private var savedDuration: TimeInterval = 0
    @State private var achievement = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                AchievementTimerHeader()
                
                TextField("Achievement you are working toward", text: $achievement)
                    .textFieldStyle(.roundedBorder)
                
                SwiftUI.TimelineView(.periodic(from: .now, by: 1)) { context in
                    Text(duration(at: context.date), format: .time(pattern: .hourMinuteSecond))
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .monospacedDigit()
                        .foregroundStyle(Theme.primary)
                        .contentTransition(.numericText())
                }
                
                HStack(spacing: 12) {
                    Button(isRunning ? "Pause" : "Start") {
                        toggleTimer()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(isRunning ? Theme.rose : Theme.secondary)
                    
                    Button("Reset", role: .destructive) {
                        isRunning = false
                        savedDuration = 0
                        sessionStart = Date()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .navigationTitle("Achievement Timer")
        .appPageTheme()
    }
    
    private func duration(at date: Date) -> Duration {
        .seconds(savedDuration + (isRunning ? date.timeIntervalSince(sessionStart) : 0))
    }
    
    private func toggleTimer() {
        if isRunning {
            savedDuration += Date().timeIntervalSince(sessionStart)
        } else {
            sessionStart = Date()
        }
        isRunning.toggle()
    }
}

private struct AchievementTimerHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "trophy.fill")
                .font(.largeTitle)
                .foregroundStyle(.purple)
            Text("Focus on one achievement")
                .font(.title2.bold())
            Text("Start the timer when you begin working toward it.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

private struct RaceVisionGoal: Identifiable {
    let id = UUID()
    let raceName: String
    let achievementGoal: String
    let raceDate: Date
    var isComplete = false
}

private struct RaceVisionYearView: View {
    @State private var raceName = ""
    @State private var achievementGoal = ""
    @State private var raceDate = Date()
    @State private var goals: [RaceVisionGoal] = []
    @State private var showingNewBoardConfirmation = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            PaperBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    RaceVisionBoardHeader(
                        goalCount: goals.count,
                        createNewBoard: { showingNewBoardConfirmation = true }
                    )
                    
                    RaceVisionAddCard(
                        raceName: $raceName,
                        achievementGoal: $achievementGoal,
                        raceDate: $raceDate,
                        addGoal: addGoal
                    )
                    
                    Text("MY RACE VISION")
                        .font(.caption.bold())
                        .foregroundStyle(.black.opacity(0.65))
                    
                    if goals.isEmpty {
                        RaceVisionEmptyBoard()
                    } else {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach($goals) { $goal in
                                RaceVisionGoalCard(goal: $goal) {
                                    goals.removeAll { $0.id == goal.id }
                                }
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Year Race Vision")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Create a new Race Vision Board?",
            isPresented: $showingNewBoardConfirmation,
            titleVisibility: .visible
        ) {
            Button("Create New Board", role: goals.isEmpty ? nil : .destructive) {
                goals.removeAll()
                raceName = ""
                achievementGoal = ""
                raceDate = Date()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if goals.isEmpty {
                Text("Your board is already empty and ready for new race goals.")
            } else {
                Text("This removes every race goal from the current board.")
            }
        }
        .appPageTheme()
    }
    
    private func addGoal() {
        let trimmedRaceName = raceName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAchievement = achievementGoal.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedRaceName.isEmpty else { return }
        
        goals.append(
            RaceVisionGoal(
                raceName: trimmedRaceName,
                achievementGoal: trimmedAchievement,
                raceDate: raceDate
            )
        )
        raceName = ""
        achievementGoal = ""
        raceDate = Date()
    }
}

private struct RaceVisionBoardHeader: View {
    let goalCount: Int
    let createNewBoard: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "flag.checkered")
                .font(.title.bold())
                .foregroundStyle(.white)
                .frame(width: 62, height: 62)
                .background(Theme.rose.gradient, in: RoundedRectangle(cornerRadius: 18))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("My Race Vision Board")
                    .font(.title2.bold())
                    .foregroundStyle(.black)
                Text("\(goalCount) race goals for this year")
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.68))
            }
            
            Spacer()
            
            Button(action: createNewBoard) {
                VStack(spacing: 4) {
                    Image(systemName: "plus.rectangle.on.rectangle")
                        .font(.title3.bold())
                    Text("New Board")
                        .font(.caption2.bold())
                }
                .foregroundStyle(.black)
                .padding(10)
                .background(Theme.accent.opacity(0.45), in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(PressScaleButtonStyle())
            .accessibilityLabel("Create a new Race Vision Board")
        }
        .padding(18)
        .glassCard(cornerRadius: 22, tint: Theme.rose)
    }
}

private struct RaceVisionAddCard: View {
    @Binding var raceName: String
    @Binding var achievementGoal: String
    @Binding var raceDate: Date
    let addGoal: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Add a race dream", systemImage: "sparkles")
                .font(.headline)
                .foregroundStyle(.black)
            
            TextField("Race name", text: $raceName)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(.black)
            
            TextField("Achievement goal", text: $achievementGoal)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(.black)
            
            DatePicker("Race date", selection: $raceDate, displayedComponents: .date)
                .foregroundStyle(.black)
            
            Button(action: addGoal) {
                Label("Pin to Vision Board", systemImage: "pin.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding(.vertical, 11)
                    .background(Theme.rose.gradient, in: RoundedRectangle(cornerRadius: 13))
            }
            .buttonStyle(.plain)
            .disabled(raceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(18)
        .glassCard(cornerRadius: 22, tint: Theme.accent)
    }
}

private struct RaceVisionGoalCard: View {
    @Binding var goal: RaceVisionGoal
    let deleteGoal: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "pin.fill")
                    .foregroundStyle(Theme.rose)
                Spacer()
                Menu {
                    Button(goal.isComplete ? "Mark Active" : "Mark Achieved") {
                        goal.isComplete.toggle()
                    }
                    Button("Delete", role: .destructive, action: deleteGoal)
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .foregroundStyle(.black.opacity(0.55))
                }
            }
            
            Image(systemName: goal.isComplete ? "trophy.fill" : "flag.checkered")
                .font(.title)
                .foregroundStyle(goal.isComplete ? Theme.secondary : Theme.rose)
            
            Text(goal.raceName)
                .font(.headline)
                .foregroundStyle(.black)
                .strikethrough(goal.isComplete)
                .lineLimit(2)
            
            if !goal.achievementGoal.isEmpty {
                Text(goal.achievementGoal)
                    .font(.caption)
                    .foregroundStyle(.black.opacity(0.68))
                    .lineLimit(3)
            }
            
            Spacer(minLength: 0)
            
            Text(goal.raceDate, format: .dateTime.month(.abbreviated).day().year())
                .font(.caption2.bold())
                .foregroundStyle(.black)
            
            Text(goal.isComplete ? "ACHIEVED" : "DREAM RACE")
                .font(.caption2.bold())
                .foregroundStyle(goal.isComplete ? Theme.secondary : Theme.rose)
        }
        .frame(maxWidth: .infinity, minHeight: 190, alignment: .topLeading)
        .padding(14)
        .background(
            LinearGradient(
                colors: [Theme.stickyPink, Theme.stickyPeach.opacity(0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 18)
        )
        .rotationEffect(.degrees(goal.isComplete ? 0 : -1))
        .shadow(color: Theme.rose.opacity(0.18), radius: 8, y: 5)
    }
}

private struct RaceVisionEmptyBoard: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.grid.2x2.fill")
                .font(.largeTitle)
                .foregroundStyle(Theme.rose)
            Text("Your vision board is ready")
                .font(.headline)
                .foregroundStyle(.black)
            Text("Add your first dream race and pin it here.")
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.68))
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .glassCard(cornerRadius: 22, tint: Theme.rose)
    }
}
