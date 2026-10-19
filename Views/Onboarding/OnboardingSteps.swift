import SwiftUI

// MARK: - Welcome

struct WelcomeStep: View {
    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 12) {
                RaceTrianLogo(size: 48, stacked: true)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text("Plan your day ... Improve your life ...")
                    .multilineTextAlignment(.center)
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.primary)
                    .padding(.horizontal, 24)

                Text("A daily AI-powered diary and life assistant that helps you plan your day, organize your work hours, and improve your life with personalized insights and smart scheduling.")
                    .multilineTextAlignment(.center)
                    .font(.system(.footnote, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .padding(.horizontal, 28)
            }

            Spacer()

            VStack(spacing: 14) {
                FeatureRow(icon: "sparkles", color: Theme.primary,
                           title: "AI that plans your day",
                           subtitle: "Smart suggestions tailored to you")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", color: Theme.accent,
                           title: "Track what matters",
                           subtitle: "Habits, mood, and progress at a glance")
                FeatureRow(icon: "heart.fill", color: Theme.rose,
                           title: "Designed to feel good",
                           subtitle: "Beautiful, calm, and made for you")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 4)
    }
}

private struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color.opacity(0.18))
                    .frame(width: 46, height: 46)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(.subheadline, design: .rounded, weight: .semibold))
                Text(subtitle).font(.system(.caption, design: .rounded)).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

// MARK: - Name + Avatar

struct NameStep: View {
    @Binding var name: String
    @Binding var avatar: String
    @FocusState private var nameFocused: Bool

    private let avatars = ["🧑‍💻","👩‍🎨","🧑‍🚀","🧘","🦊","🐢","🌸","⭐️","🎯","🌙","🔥","🌱"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                StepHeader(eyebrow: "Step 1",
                           title: "Let's get to know you",
                           subtitle: "What should we call you?")

                ZStack {
                    Circle()
                        .fill(Theme.heroGradient.opacity(0.18))
                        .frame(width: 130, height: 130)
                    Text(avatar).font(.system(size: 76))
                }
                .padding(.top, 6)

                TextField("Your name", text: $name)
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .textInputAutocapitalization(.words)
                    .focused($nameFocused)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Theme.primary.opacity(nameFocused ? 0.5 : 0.15), lineWidth: 1.2)
                    )
                    .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Pick an avatar")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 24)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6), spacing: 12) {
                        ForEach(avatars, id: \.self) { emoji in
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    avatar = emoji
                                }
                            } label: {
                                Text(emoji)
                                    .font(.system(size: 30))
                                    .frame(width: 50, height: 50)
                                    .background(
                                        Circle().fill(avatar == emoji ? Theme.primary.opacity(0.2) : Color.white.opacity(0.5))
                                    )
                                    .overlay(
                                        Circle().stroke(avatar == emoji ? Theme.primary : Color.clear, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                nameFocused = true
            }
        }
    }
}

// MARK: - Life Areas

struct AreasStep: View {
    @Binding var selected: Set<LifeArea>

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                StepHeader(eyebrow: "Step 2",
                           title: "What matters to you?",
                           subtitle: "Pick a few areas — we'll tailor suggestions to your life.")

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(LifeArea.allCases, id: \.self) { area in
                        AreaTile(area: area, isSelected: selected.contains(area)) {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                if selected.contains(area) {
                                    selected.remove(area)
                                } else {
                                    selected.insert(area)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
        }
    }
}

private struct AreaTile: View {
    let area: LifeArea
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(area.emoji).font(.system(size: 30))
                    Spacer()
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .foregroundStyle(isSelected ? area.tint : Color.secondary.opacity(0.4))
                }
                Text(area.rawValue)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? area.tint : Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? area.tint.opacity(0.25) : .clear, radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Focus Style

struct FocusStep: View {
    @Binding var selected: FocusStyle

    var body: some View {
        VStack(spacing: 18) {
            StepHeader(eyebrow: "Step 3",
                       title: "How do you focus best?",
                       subtitle: "We'll structure your plan around your style.")

            VStack(spacing: 12) {
                ForEach(FocusStyle.allCases, id: \.self) { style in
                    FocusRow(style: style, isSelected: selected == style) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selected = style
                        }
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer(minLength: 0)
        }
    }
}

private struct FocusRow: View {
    let style: FocusStyle
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isSelected ? AnyShapeStyle(Theme.heroGradient) : AnyShapeStyle(Theme.primary.opacity(0.15)))
                        .frame(width: 52, height: 52)
                    Image(systemName: style.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(isSelected ? .white : Theme.primary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(style.rawValue)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Text(style.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Theme.primary : Color.secondary.opacity(0.4))
            }
            .padding(14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? Theme.primary : Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Schedule

struct ScheduleStep: View {
    @Binding var wake: Int
    @Binding var sleep: Int

    var body: some View {
        VStack(spacing: 22) {
            StepHeader(eyebrow: "Step 4",
                       title: "Your daily rhythm",
                       subtitle: "When does your day begin and end?")

            VStack(spacing: 14) {
                TimeCard(emoji: "☀️", label: "Wake up", hour: $wake, tint: Theme.accent)
                TimeCard(emoji: "🌙", label: "Wind down", hour: $sleep, tint: Theme.secondary)
            }
            .padding(.horizontal, 20)

            VStack(spacing: 8) {
                Text("You'll have")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                Text("\(awakeHours) hours")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.heroGradient)
                Text("of focused, intentional time each day")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 6)

            Spacer(minLength: 0)
        }
    }

    private var awakeHours: Int {
        let diff = sleep - wake
        return diff > 0 ? diff : (24 + diff)
    }
}

private struct TimeCard: View {
    let emoji: String
    let label: String
    @Binding var hour: Int
    let tint: Color

    var body: some View {
        HStack(spacing: 14) {
            Text(emoji).font(.system(size: 32))
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(format(hour))
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(tint)
            }
            Spacer()
            Stepper("", value: $hour, in: 0...23)
                .labelsHidden()
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }

    private func format(_ h: Int) -> String {
        let suffix = h < 12 ? "AM" : "PM"
        let display = h == 0 ? 12 : (h > 12 ? h - 12 : h)
        return "\(display):00 \(suffix)"
    }
}

// MARK: - Shared header

struct StepHeader: View {
    let eyebrow: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            Text(eyebrow.uppercased())
                .font(.system(.caption, design: .rounded, weight: .bold))
                .tracking(1.4)
                .foregroundStyle(Theme.primary)

            Text(title)
                .multilineTextAlignment(.center)
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text(subtitle)
                .multilineTextAlignment(.center)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 24)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}
// MARK: - Notifications

struct NotificationStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 5",
                       title: "Stay on track",
                       subtitle: "Get helpful reminders throughout your day")
            
            Spacer()
            
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 80))
                .foregroundStyle(Theme.heroGradient)
            
            VStack(spacing: 16) {
                Toggle(isOn: $enabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Enable notifications")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Morning briefings, evening reviews, and gentle reminders")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
                .padding(.horizontal, 24)
            }
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Mood Tracking

struct MoodTrackingStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 6",
                       title: "Track your mood",
                       subtitle: "Understand patterns and improve your wellbeing")
            
            Spacer()
            
            HStack(spacing: 12) {
                ForEach(["😊", "😌", "😐", "😔", "😢"], id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 44))
                }
            }
            
            Toggle(isOn: $enabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enable mood tracking")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Text("Daily check-ins to understand emotional patterns")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Habit Tracking

struct HabitTrackingStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 7",
                       title: "Build better habits",
                       subtitle: "Track daily habits and celebrate progress")
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(Theme.accent)
            
            Toggle(isOn: $enabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enable habit tracking")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Text("Build streaks and stay consistent")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - AI Assistant

struct AIAssistantStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 8",
                       title: "AI-powered insights",
                       subtitle: "Let AI help plan your day and suggest improvements")
            
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundStyle(Theme.heroGradient)
            
            Toggle(isOn: $enabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enable AI assistant")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Text("Smart suggestions, auto-scheduling, and personalized insights")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Theme Selection

struct ThemeSelectionStep: View {
    @Binding var selected: String
    private let themes = ["Indigo", "Purple", "Blue", "Green", "Orange", "Pink"]
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 9",
                       title: "Choose your theme",
                       subtitle: "Pick a color that inspires you")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                ForEach(themes, id: \.self) { theme in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selected = theme
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Circle()
                                .fill(colorForTheme(theme))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Circle()
                                        .stroke(selected == theme ? Color.primary : Color.clear, lineWidth: 3)
                                )
                            Text(theme)
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.horizontal, 4)
    }
    
    private func colorForTheme(_ theme: String) -> Color {
        switch theme {
        case "Indigo": return .indigo
        case "Purple": return .purple
        case "Blue": return .blue
        case "Green": return .green
        case "Orange": return .orange
        case "Pink": return .pink
        default: return .indigo
        }
    }
}

// MARK: - Week Start

struct WeekStartStep: View {
    @Binding var weekStart: Int
    private let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 10",
                       title: "Week starts on...",
                       subtitle: "Choose when your week begins")
            
            Picker("Week Start", selection: $weekStart) {
                ForEach(0..<7) { index in
                    Text(days[index]).tag(index)
                }
            }
            .pickerStyle(.wheel)
            .padding(.horizontal, 24)
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Time Format

struct TimeFormatStep: View {
    @Binding var use24Hour: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 11",
                       title: "Time format",
                       subtitle: "How should we display time?")
            
            Spacer()
            
            VStack(spacing: 20) {
                Button {
                    withAnimation { use24Hour = false }
                } label: {
                    HStack {
                        Image(systemName: use24Hour ? "circle" : "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(use24Hour ? .secondary : Theme.primary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("12-hour format")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                            Text("9:30 AM, 2:15 PM")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                
                Button {
                    withAnimation { use24Hour = true }
                } label: {
                    HStack {
                        Image(systemName: use24Hour ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundStyle(use24Hour ? Theme.primary : .secondary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("24-hour format")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                            Text("09:30, 14:15")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Quotes

struct QuotesStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 12",
                       title: "Daily inspiration",
                       subtitle: "Start each day with motivational quotes")
            
            Spacer()
            
            VStack(spacing: 12) {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Theme.rose)
                
                Text("\"The journey of a thousand miles begins with one step\"")
                    .font(.system(.body, design: .rounded))
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }
            
            Toggle(isOn: $enabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Show daily quotes")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Text("Inspiring words to start your morning")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Privacy

struct PrivacyStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 13",
                       title: "Privacy mode",
                       subtitle: "Keep your data private and secure")
            
            Spacer()
            
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 80))
                .foregroundStyle(Theme.primary)
            
            VStack(spacing: 16) {
                Toggle(isOn: $enabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Enable privacy mode")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Blur sensitive content in app switcher, require authentication")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
                
                Text("Your data is always encrypted and stored locally on your device.")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Final Step

struct FinalStep: View {
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Theme.heroGradient)
                
                Text("You're all set!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                
                Text("Ready to start planning your best day ever?")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(Theme.primary)
                    Text("AI-powered planning")
                        .font(.system(.subheadline, design: .rounded))
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundStyle(Theme.accent)
                    Text("Progress tracking")
                        .font(.system(.subheadline, design: .rounded))
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(Theme.rose)
                    Text("Personalized insights")
                        .font(.system(.subheadline, design: .rounded))
                }
            }
            .padding(.bottom, 20)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Language

struct LanguageStep: View {
    @Binding var selected: String
    private let languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Arabic", "Portuguese"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                StepHeader(eyebrow: "Step 14",
                           title: "Choose your language",
                           subtitle: "Select your preferred language")
                
                VStack(spacing: 12) {
                    ForEach(languages, id: \.self) { language in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selected = language
                            }
                        } label: {
                            HStack {
                                Text(flagForLanguage(language))
                                    .font(.system(size: 32))
                                
                                Text(language)
                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                                
                                Spacer()
                                
                                Image(systemName: selected == language ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 22))
                                    .foregroundStyle(selected == language ? Theme.primary : .secondary)
                            }
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selected == language ? Theme.primary : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 20)
        }
    }
    
    private func flagForLanguage(_ language: String) -> String {
        switch language {
        case "English": return "🇬🇧"
        case "Spanish": return "🇪🇸"
        case "French": return "🇫🇷"
        case "German": return "🇩🇪"
        case "Chinese": return "🇨🇳"
        case "Japanese": return "🇯🇵"
        case "Arabic": return "🇸🇦"
        case "Portuguese": return "🇵🇹"
        default: return "🌐"
        }
    }
}

// MARK: - Backup

struct BackupStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 15",
                       title: "Automatic backups",
                       subtitle: "Never lose your data with cloud sync")
            
            Spacer()
            
            Image(systemName: "icloud.and.arrow.up.fill")
                .font(.system(size: 80))
                .foregroundStyle(Theme.heroGradient)
            
            VStack(spacing: 16) {
                Toggle(isOn: $enabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Enable automatic backups")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Sync your data securely to iCloud")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
                
                VStack(spacing: 8) {
                    FeatureItem(icon: "checkmark.shield.fill", text: "End-to-end encrypted")
                    FeatureItem(icon: "arrow.triangle.2.circlepath", text: "Automatic sync across devices")
                    FeatureItem(icon: "externaldrive.fill.badge.timemachine", text: "Full backup history")
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

private struct FeatureItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.accent)
            Text(text)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

// MARK: - Sound Effects

struct SoundEffectsStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 16",
                       title: "Sound & haptics",
                       subtitle: "Enhance your experience with audio feedback")
            
            Spacer()
            
            Image(systemName: "speaker.wave.3.fill")
                .font(.system(size: 80))
                .foregroundStyle(Theme.accent)
            
            VStack(spacing: 20) {
                Toggle(isOn: $enabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Enable sound effects")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Satisfying sounds for completed tasks and achievements")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
                
                if enabled {
                    HStack(spacing: 16) {
                        ForEach(["🔔", "✅", "🎉", "⭐️"], id: \.self) { emoji in
                            Button {
                                // Play sound preview
                            } label: {
                                Text(emoji)
                                    .font(.system(size: 36))
                                    .frame(width: 60, height: 60)
                                    .background(
                                        Circle()
                                            .fill(Theme.primary.opacity(0.15))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Dark Mode

struct DarkModeStep: View {
    @Binding var selected: String
    private let options = ["Auto", "Light", "Dark"]
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 17",
                       title: "Appearance",
                       subtitle: "Choose your preferred color scheme")
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.orange)
                
                Image(systemName: "moon.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.indigo)
            }
            
            VStack(spacing: 16) {
                ForEach(options, id: \.self) { option in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selected = option
                        }
                    } label: {
                        HStack {
                            Image(systemName: iconForOption(option))
                                .font(.system(size: 24))
                                .foregroundStyle(selected == option ? Theme.primary : .secondary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(option)
                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                                Text(descriptionForOption(option))
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: selected == option ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 22))
                                .foregroundStyle(selected == option ? Theme.primary : .secondary)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selected == option ? Theme.primary : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
    
    private func iconForOption(_ option: String) -> String {
        switch option {
        case "Auto": return "circle.lefthalf.filled"
        case "Light": return "sun.max.fill"
        case "Dark": return "moon.fill"
        default: return "circle"
        }
    }
    
    private func descriptionForOption(_ option: String) -> String {
        switch option {
        case "Auto": return "Match system settings"
        case "Light": return "Always use light mode"
        case "Dark": return "Always use dark mode"
        default: return ""
        }
    }
}

// MARK: - Weekly Goals

struct WeeklyGoalsStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 18",
                       title: "Weekly goals",
                       subtitle: "Set and track goals every week")
            
            Spacer()
            
            Image(systemName: "target")
                .font(.system(size: 80))
                .foregroundStyle(Theme.heroGradient)
            
            VStack(spacing: 20) {
                Toggle(isOn: $enabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Enable weekly goals")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Plan your week and track progress toward your goals")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
                
                if enabled {
                    VStack(spacing: 12) {
                        GoalPreview(icon: "briefcase.fill", title: "Career", color: Theme.primary)
                        GoalPreview(icon: "figure.run", title: "Health", color: Theme.accent)
                        GoalPreview(icon: "book.fill", title: "Learning", color: Theme.rose)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

private struct GoalPreview: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                ProgressView(value: 0.6)
                    .tint(color)
            }
            
            Text("60%")
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Work Hours

struct WorkHoursStep: View {
    @Binding var startHour: Int
    @Binding var endHour: Int
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 19",
                       title: "Work hours",
                       subtitle: "When do you typically work?")
            
            Spacer()
            
            Image(systemName: "briefcase.fill")
                .font(.system(size: 80))
                .foregroundStyle(Theme.primary)
            
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start time")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Text(formatHour(startHour))
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .foregroundStyle(Theme.primary)
                            Spacer()
                            Stepper("", value: $startHour, in: 0...23)
                                .labelsHidden()
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("End time")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Text(formatHour(endHour))
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .foregroundStyle(Theme.accent)
                            Spacer()
                            Stepper("", value: $endHour, in: 0...23)
                                .labelsHidden()
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
                
                Text("\(workHoursDuration) hours of work time")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
    
    private var workHoursDuration: Int {
        let diff = endHour - startHour
        return diff > 0 ? diff : (24 + diff)
    }
    
    private func formatHour(_ h: Int) -> String {
        let suffix = h < 12 ? "AM" : "PM"
        let display = h == 0 ? 12 : (h > 12 ? h - 12 : h)
        return "\(display):00 \(suffix)"
    }
}

// MARK: - Break Reminders

struct BreakRemindersStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 20",
                       title: "Break reminders",
                       subtitle: "Take regular breaks to stay fresh and productive")
            
            Spacer()
            
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 80))
                .foregroundStyle(Theme.accent)
            
            VStack(spacing: 20) {
                Toggle(isOn: $enabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Enable break reminders")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Get reminded to take breaks every hour")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
                
                if enabled {
                    VStack(spacing: 12) {
                        BreakTypeCard(icon: "figure.walk", title: "Stretch break", duration: "5 min", color: Theme.accent)
                        BreakTypeCard(icon: "brain.head.profile", title: "Mental break", duration: "10 min", color: Theme.primary)
                        BreakTypeCard(icon: "fork.knife", title: "Lunch break", duration: "30 min", color: Theme.rose)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

private struct BreakTypeCard: View {
    let icon: String
    let title: String
    let duration: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
                .frame(width: 40)
            
            Text(title)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
            
            Spacer()
            
            Text(duration)
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(color.opacity(0.15), in: Capsule())
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Focus Session

struct FocusSessionStep: View {
    @Binding var duration: Int
    private let durations = [15, 25, 30, 45, 60, 90]
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 21",
                       title: "Focus sessions",
                       subtitle: "How long are your ideal focus sessions?")
            
            Spacer()
            
            Image(systemName: "timer")
                .font(.system(size: 80))
                .foregroundStyle(Theme.heroGradient)
            
            VStack(spacing: 16) {
                Text("\(duration) minutes")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                    ForEach(durations, id: \.self) { time in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                duration = time
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Text("\(time)")
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                Text("min")
                                    .font(.system(.caption2, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background {
                                if duration == time {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Theme.heroGradient)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.ultraThinMaterial)
                                }
                            }
                            .foregroundStyle(duration == time ? .white : .primary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(duration == time ? Color.clear : Theme.primary.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Text("Based on the Pomodoro Technique")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Widgets

struct WidgetsStep: View {
    @Binding var enabled: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 22",
                       title: "Home screen widgets",
                       subtitle: "Quick access to your daily overview")
            
            Spacer()
            
            VStack(spacing: 16) {
                // Widget preview
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Theme.primary)
                        Text("Today's Progress")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                        Spacer()
                    }
                    
                    HStack(spacing: 8) {
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Theme.heroGradient)
                                .frame(width: 20, height: 40)
                        }
                        ForEach(0..<2) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 20, height: 40)
                        }
                    }
                    
                    Text("5 of 7 habits completed")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Theme.primary.opacity(0.3), lineWidth: 2)
                )
                .padding(.horizontal, 40)
            }
            
            Toggle(isOn: $enabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Add widgets to home screen")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Text("See your progress at a glance")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Data Sharing

struct DataSharingStep: View {
    @State private var analyticsEnabled: Bool = false
    @State private var crashReportsEnabled: Bool = true
    
    var body: some View {
        VStack(spacing: 24) {
            StepHeader(eyebrow: "Step 23",
                       title: "Help us improve",
                       subtitle: "Anonymous data helps us make the app better")
            
            Spacer()
            
            Image(systemName: "chart.bar.doc.horizontal.fill")
                .font(.system(size: 80))
                .foregroundStyle(Theme.accent)
            
            VStack(spacing: 16) {
                Toggle(isOn: $analyticsEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Anonymous analytics")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Help us understand which features you use most")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
                
                Toggle(isOn: $crashReportsEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Crash reports")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text("Automatically send crash reports to help fix bugs")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Theme.primary))
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.accent)
                        Text("Your personal data is never shared")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "eye.slash.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.accent)
                        Text("All analytics are completely anonymous")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

