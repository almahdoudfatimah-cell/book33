import SwiftUI

// MARK: - Root Tab View with Liquid Glass Design

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Today Tab - Your daily activities and overview
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar.circle.fill")
                }
                .tag(0)
            
            // Plan Tab - Your training schedule and goals
            PlanView()
                .tabItem {
                    Label("Plan", systemImage: "calendar.badge.clock")
                }
                .tag(1)
            
            // More Tab - Profile and additional features
            ProfileView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle.fill")
                }
                .tag(2)
        }
        .tint(Theme.primary)
    }
}

// MARK: - Coach View

struct CoachView: View {
    @StateObject private var viewModel = CoachViewModel()
    @State private var inputText = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Messages
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if viewModel.showWelcome {
                            welcomeCard
                                .padding(.horizontal)
                                .padding(.top)
                        }
                        
                        ForEach(viewModel.messages) { message in
                            MessageRow(message: message)
                                .padding(.horizontal)
                        }
                        
                        if viewModel.isThinking {
                            thinkingIndicator
                                .padding(.horizontal)
                        }
                    }
                }
                
                // Input bar
                inputBar
            }
            .navigationTitle("AI Coach")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.clear()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
    
    private var welcomeCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(Theme.primary)
            
            Text("Your AI Coach")
                .font(.title2.bold())
            
            Text("Ask me anything about planning, habits, focus, or wellness.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var thinkingIndicator: some View {
        HStack(spacing: 8) {
            ProgressView()
                .scaleEffect(0.8)
            Text("Thinking...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Ask your coach...", text: $inputText, axis: .vertical)
                .textFieldStyle(.plain)
                .focused($isInputFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(24)
                .lineLimit(1...5)
            
            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(inputText.isEmpty ? Color.secondary : Theme.primary)
            }
            .disabled(inputText.isEmpty || viewModel.isThinking)
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
    }
    
    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        isInputFocused = false
        
        Task {
            await viewModel.send(text: text)
        }
    }
}

// MARK: - Message Row

struct MessageRow: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.role == .user {
                Spacer(minLength: 40)
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(.body, design: .rounded))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.role == .user
                            ? Theme.primary.opacity(0.2)
                            : Color.secondary.opacity(0.1)
                    )
                    .cornerRadius(16)
                    .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
            }
            
            if message.role == .assistant {
                Spacer(minLength: 40)
            }
        }
    }
}

// MARK: - Progress Tracking View

struct ProgressTrackingView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Your Progress")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Text("Progress tracking coming soon...")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }
}

// MARK: - Paywall View
// Note: The full PaywallView implementation is in PaywallView.swift
// This was removed to avoid duplicate type definitions

#Preview {
    RootTabView()
}
