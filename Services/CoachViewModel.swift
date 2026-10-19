import SwiftUI
import Combine

@MainActor
final class CoachViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isThinking = false
    @Published var errorBanner: String? = nil
    @Published var showWelcome = true

    func send(text: String) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        showWelcome = false
        errorBanner = nil

        let userMsg = ChatMessage(role: .user, content: text)
        messages.append(userMsg)
        isThinking = true

        // Build API messages array
        let apiMessages: [[String: String]] = messages.map { msg in
            ["role": msg.role == .user ? "user" : "assistant", "content": msg.content]
        }

        do {
            let reply = try await CoachService.shared.sendMessages(apiMessages)
            isThinking = false
            messages.append(ChatMessage(role: .assistant, content: reply))
        } catch CoachError.notConfigured {
            isThinking = false
            messages.append(ChatMessage(role: .assistant, content: demoReply(for: text)))
        } catch {
            isThinking = false
            // Fallback to demo mode on any network/auth error
            messages.append(ChatMessage(role: .assistant, content: demoReply(for: text)))
        }
    }

    func clear() {
        messages = []
        showWelcome = true
        errorBanner = nil
    }

    // MARK: - Demo replies (shown until OpenAI is configured)
    private func demoReply(for input: String) -> String {
        let lower = input.lowercased()
        if lower.contains("plan") || lower.contains("day") {
            return "Here's a balanced day 🗓 Start with 20 min of movement at 7am, tackle your most important task at 9am during your best focus window, block lunch 12–1pm as recovery, and finish with a 30-min review at 5pm. 👉 Open your Plan tab and protect that 9am block now."
        } else if lower.contains("habit") {
            return "The secret to lasting habits is tiny wins 🔑 Pick ONE habit to anchor to something you already do — like meditating right after brushing teeth. Track it for 7 days before adding more. 👉 Schedule it in your Plan tab now."
        } else if lower.contains("stress") || lower.contains("overwhelm") {
            return "When overwhelm hits, your brain needs a reset 🧘 Try 4-7-8 breathing: inhale 4 sec, hold 7, exhale 8. Do it twice. Then write the ONE thing that matters most today. 👉 Take that breath — I'll wait."
        } else if lower.contains("sleep") || lower.contains("evening") {
            return "A great evening routine starts 90 min before sleep 🌙 Dim lights, stop screens at 9pm, journal for 10 min, then read something calm. Consistency is everything. 👉 Set a phone alarm for your screen-off time tonight."
        } else if lower.contains("procrastinat") {
            return "Procrastination is usually fear in disguise 🎯 Use the 2-minute rule: if a task takes under 2 min, do it now. For bigger tasks, commit to just 5 minutes — starting is the hardest part. 👉 Pick one task and start a 5-minute timer."
        } else {
            return "I'm here to help you plan smarter, build better habits, and live with more intention ✨ What specific area do you want to improve most? 👉 Tell me your #1 goal this week."
        }
    }
}
