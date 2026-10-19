import SwiftUI

struct CoachView: View {
    @StateObject private var vm = CoachViewModel()
    @ObservedObject private var premium = PremiumStore.shared
    @ObservedObject private var profile = ProfileStore.shared
    @State private var inputText = ""
    @State private var showPaywall = false
    @Environment(\.colorScheme) private var scheme
    @FocusState private var inputFocused: Bool

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning, \(profile.name) ☀️"
        case 12..<17: return "Good afternoon, \(profile.name) 👋"
        case 17..<21: return "Good evening, \(profile.name) 🌆"
        default:      return "Hey, \(profile.name) 🌙"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()

                VStack(spacing: 0) {
                    if vm.showWelcome {
                        welcomeContent
                    } else {
                        chatScrollView
                    }

                    if !premium.isActive {
                        quotaBanner
                    }

                    if let err = vm.errorBanner {
                        ErrorBanner(message: err) { vm.errorBanner = nil }
                    }

                    inputBar
                }
            }
            .navigationTitle(greeting)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !vm.messages.isEmpty {
                        Button { withAnimation { vm.clear() } } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundStyle(Theme.primary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }.appPageTheme()
    }

    // MARK: Quota banner
    private var quotaBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "crown.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Theme.accent)
            Text(premium.coachRemainingToday > 0
                 ? "\(premium.coachRemainingToday) free messages left today"
                 : "Daily limit reached — Go Premium for unlimited")
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundStyle(.primary)
            Spacer()
            Button { showPaywall = true } label: {
                Text("Upgrade")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Theme.heroGradient, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .overlay(Divider().opacity(0.2), alignment: .top)
    }

    // MARK: Welcome screen
    private var welcomeContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                heroSection
                promptGrid
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
        }
    }

    private var heroSection: some View {
        VStack(spacing: 0) {
            // Gradient hero card
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Theme.heroGradient)
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .shadow(color: Theme.primary.opacity(0.45), radius: 24, x: 0, y: 14)

                // Decorative circles
                Circle()
                    .fill(.white.opacity(0.10))
                    .frame(width: 130, height: 130)
                    .offset(x: 220, y: -30)
                Circle()
                    .fill(.white.opacity(0.07))
                    .frame(width: 80, height: 80)
                    .offset(x: 260, y: 30)

                HStack(alignment: .bottom, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("AI Coach")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    // Online indicator
                    HStack(spacing: 5) {
                        Circle().fill(Theme.mint).frame(width: 8, height: 8)
                        Text("Online")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.18), in: Capsule())
                }
                .padding(18)
            }

            // Welcome message bubble below the card
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome to RaceTrian 👋")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    Text("Ask me anything about planning, habits, focus, or wellbeing. I'm here to help you thrive.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
                Spacer(minLength: 30)
            }
            .padding(.top, 14)
        }
    }

    private var promptGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Plan for me CTA
            Button {
                inputText = "Plan my day for me based on my goals and focus style"
                Task { await sendMessage() }
            } label: {
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Color.white.opacity(0.22)).frame(width: 40, height: 40)
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Plan my day for me")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Let the AI build your full daily schedule")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(14)
                .background(Theme.heroGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Theme.primary.opacity(0.35), radius: 14, x: 0, y: 7)
            }
            .buttonStyle(.plain)

            Text("Try asking…")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(CoachPrompts.suggestions) { prompt in
                    PromptChip(prompt: prompt) {
                        inputText = prompt.message
                        Task { await sendMessage() }
                    }
                }
            }
        }
    }

    // MARK: Chat scroll view
    private var chatScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(vm.messages) { msg in
                        MessageBubble(message: msg)
                            .id(msg.id)
                    }
                    if vm.isThinking {
                        ThinkingBubble()
                            .id("thinking")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .onChange(of: vm.messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: vm.isThinking) { _, _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.3)) {
            if vm.isThinking {
                proxy.scrollTo("thinking", anchor: .bottom)
            } else if let last = vm.messages.last {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }

    // MARK: Input bar
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Message your coach…", text: $inputText, axis: .vertical)
                .font(.system(size: 15, design: .rounded))
                .lineLimit(1...4)
                .focused($inputFocused)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                )

            Button {
                Task { await sendMessage() }
            } label: {
                ZStack {
                    Circle()
                        .fill(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isThinking
                              ? AnyShapeStyle(Color.secondary.opacity(0.2))
                              : AnyShapeStyle(Theme.heroGradient))
                        .frame(width: 42, height: 42)
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isThinking)
            .animation(.easeInOut(duration: 0.2), value: inputText.isEmpty)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .overlay(Divider().opacity(0.2), alignment: .top)
    }

    private func sendMessage() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        // Consume a free message slot (gate removed, always allow)
        premium.consumeCoachMessage()

        inputText = ""
        inputFocused = false
        await vm.send(text: text)
    }
}

#Preview { CoachView() }
