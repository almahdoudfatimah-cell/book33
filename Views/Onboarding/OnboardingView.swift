import SwiftUI

struct OnboardingView: View {
    var onComplete: (() -> Void)? = nil

    @Environment(\.colorScheme) private var scheme
    @ObservedObject private var profile = ProfileStore.shared

    @State private var step: Int = 0
    @State private var name: String = ""
    @State private var avatar: String = "🧑‍💻"
    @State private var areas: Set<LifeArea> = [.career, .health, .mindset]
    @State private var focus: FocusStyle = .deepWork
    @State private var wake: Int = 7
    @State private var sleep: Int = 23
    @State private var notifications: Bool = true
    @State private var trackMood: Bool = true
    @State private var trackHabits: Bool = true
    @State private var useAI: Bool = true
    @State private var theme: String = "Indigo"
    @State private var weekStart: Int = 1
    @State private var timeFormat: Bool = false
    @State private var showQuotes: Bool = true
    @State private var privacyMode: Bool = false
    @State private var language: String = "English"
    @State private var autoBackup: Bool = true
    @State private var soundEffects: Bool = true
    @State private var darkModePreference: String = "Auto"
    @State private var weeklyGoals: Bool = true
    @State private var workHoursStart: Int = 9
    @State private var workHoursEnd: Int = 17
    @State private var enableBreakReminders: Bool = true
    @State private var focusSessionDuration: Int = 25
    @State private var enableWidgets: Bool = true
    
    private let totalSteps = 25

    public var body: some View {
        ZStack {
            Theme.pageBackground.ignoresSafeArea()
            decorativeOrbs

            VStack(spacing: 0) {
                progressBar
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .frame(height: 52)

                currentStepView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(step)
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomButtons
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 10)
                .background(.clear)
        }
    }


    @ViewBuilder
    private var currentStepView: some View {
        switch step {
        case 0: WelcomeStep()
        case 1: NameStep(name: $name, avatar: $avatar)
        case 2: AreasStep(selected: $areas)
        case 3: FocusStep(selected: $focus)
        case 4: ScheduleStep(wake: $wake, sleep: $sleep)
        case 5: NotificationStep(enabled: $notifications)
        case 6: MoodTrackingStep(enabled: $trackMood)
        case 7: HabitTrackingStep(enabled: $trackHabits)
        case 8: AIAssistantStep(enabled: $useAI)
        case 9: ThemeSelectionStep(selected: $theme)
        case 10: WeekStartStep(weekStart: $weekStart)
        case 11: TimeFormatStep(use24Hour: $timeFormat)
        case 12: QuotesStep(enabled: $showQuotes)
        case 13: PrivacyStep(enabled: $privacyMode)
        case 14: LanguageStep(selected: $language)
        case 15: BackupStep(enabled: $autoBackup)
        case 16: SoundEffectsStep(enabled: $soundEffects)
        case 17: DarkModeStep(selected: $darkModePreference)
        case 18: WeeklyGoalsStep(enabled: $weeklyGoals)
        case 19: WorkHoursStep(startHour: $workHoursStart, endHour: $workHoursEnd)
        case 20: BreakRemindersStep(enabled: $enableBreakReminders)
        case 21: FocusSessionStep(duration: $focusSessionDuration)
        case 22: WidgetsStep(enabled: $enableWidgets)
        case 23: DataSharingStep()
        default: FinalStep()
        }
    }

    private var decorativeOrbs: some View {
        ZStack {
            Circle()
                .fill(Theme.primary.opacity(0.25))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(x: -120, y: -260)
            Circle()
                .fill(Theme.accent.opacity(0.22))
                .frame(width: 240, height: 240)
                .blur(radius: 60)
                .offset(x: 140, y: 320)
        }
        .allowsHitTesting(false)
    }

    private var progressBar: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalSteps, id: \.self) { i in
                Capsule()
                    .fill(i <= step ? AnyShapeStyle(Theme.heroGradient) : AnyShapeStyle(Color.primary.opacity(0.12)))
                    .frame(height: 5)
                    .animation(.easeInOut(duration: 0.35), value: step)
            }
        }
    }

    private var bottomButtons: some View {
        HStack(spacing: 12) {
            if step > 0 {
                Button {
                    print("DEBUG: Back button tapped")
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                        step -= 1
                    }
                } label: {
                    Text("Back")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.ultraThinMaterial, in: Capsule())
                }
                .buttonStyle(PressScaleButtonStyle())
                .contentShape(Capsule())
                .frame(maxWidth: .infinity)
                .transition(.move(edge: .leading).combined(with: .opacity))
            }

            Button {
                if step == totalSteps - 1 {
                    saveAndFinish()
                } else {
                    advance()
                }
            } label: {
                Text(primaryButtonTitle)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(step == totalSteps - 1 ? Theme.primary : Color.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(primaryButtonBackground)
            }
            .buttonStyle(PressScaleButtonStyle())
            .contentShape(Capsule())
            .frame(maxWidth: .infinity)
            .accessibilityLabel(step == totalSteps - 1 ? "Get started with the app" : "Continue to next step")
        }
        .frame(maxWidth: .infinity)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: step)
    }

    private var primaryButtonTitle: String {
        if step == totalSteps - 1 { return "Get Started" }
        return step == 0 ? "Let's Go" : "Continue"
    }

    @ViewBuilder
    private var primaryButtonBackground: some View {
        if step == totalSteps - 1 {
            Capsule()
                .fill(Color.white)
                .shadow(color: Theme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
        } else {
            Capsule()
                .fill(Theme.heroGradient)
                .shadow(color: Theme.primary.opacity(0.4), radius: 14, x: 0, y: 8)
        }
    }

    private func advance() {
        print("DEBUG: advance() called - current step: \(step), totalSteps: \(totalSteps)")
        if step < totalSteps - 1 {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                step += 1
            }
            print("DEBUG: Advanced to step \(step)")
        } else {
            print("DEBUG: Final step reached, calling saveAndFinish()")
            saveAndFinish()
        }
    }

    private func saveAndFinish() {
        print("DEBUG: saveAndFinish() called")
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty { 
            profile.name = trimmed 
            print("DEBUG: Set name to: \(trimmed)")
        } else {
            print("DEBUG: Name is empty")
        }
        profile.avatarEmoji = avatar
        profile.selectedAreas = areas
        profile.focusStyle = focus
        profile.wakeHour = wake
        profile.sleepHour = sleep

        let defaults = UserDefaults.standard
        defaults.set(notifications, forKey: "assessment.notifications")
        defaults.set(trackMood, forKey: "assessment.trackMood")
        defaults.set(trackHabits, forKey: "assessment.trackHabits")
        defaults.set(useAI, forKey: "assessment.useAI")
        defaults.set(theme, forKey: "assessment.theme")
        defaults.set(weekStart, forKey: "assessment.weekStart")
        defaults.set(timeFormat, forKey: "assessment.use24Hour")
        defaults.set(showQuotes, forKey: "assessment.showQuotes")
        defaults.set(privacyMode, forKey: "assessment.privacyMode")
        defaults.set(language, forKey: "assessment.language")
        defaults.set(autoBackup, forKey: "assessment.autoBackup")
        defaults.set(soundEffects, forKey: "assessment.soundEffects")
        defaults.set(darkModePreference, forKey: "assessment.darkMode")
        defaults.set(weeklyGoals, forKey: "assessment.weeklyGoals")
        defaults.set(workHoursStart, forKey: "assessment.workHoursStart")
        defaults.set(workHoursEnd, forKey: "assessment.workHoursEnd")
        defaults.set(enableBreakReminders, forKey: "assessment.breakReminders")
        defaults.set(focusSessionDuration, forKey: "assessment.focusSessionDuration")
        defaults.set(enableWidgets, forKey: "assessment.widgets")
        
        print("DEBUG: Completing onboarding")
        completeOnboarding()
    }
    
    private func skipOnboarding() {
        print("DEBUG: skipOnboarding() called")
        
        // Set defaults when skipping
        if !name.isEmpty {
            profile.name = name.trimmingCharacters(in: .whitespaces)
        } else {
            profile.name = "User"
        }
        
        profile.avatarEmoji = avatar
        profile.selectedAreas = areas.isEmpty ? [.career, .health] : areas
        profile.focusStyle = focus
        profile.wakeHour = wake
        profile.sleepHour = sleep
        
        print("DEBUG: Completing onboarding with name: \(profile.name)")
        completeOnboarding()
    }

    private func completeOnboarding() {
        onComplete?()
    }
}

#Preview {
    OnboardingView()
}
