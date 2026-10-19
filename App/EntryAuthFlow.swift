import SwiftUI

struct SignUpView: View {
    var onAuthenticated: (() -> Void)?
    var onShowSignIn: (() -> Void)?
    var onBack: (() -> Void)?

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isSubmitting = false

    var body: some View {
        NavigationStack {
            EntryAuthForm(title: "Create Account", subtitle: "Save your training and sync it across devices") {
                EntryEmailField(email: $email)
                SecureField("Password", text: $password)
                    .textContentType(.newPassword)
                    .entryAuthFieldStyle()
                SecureField("Confirm Password", text: $confirmPassword)
                    .textContentType(.newPassword)
                    .entryAuthFieldStyle()
                EntryAuthError(message: errorMessage)
                EntryAuthSubmitButton(title: "Create Account", isSubmitting: isSubmitting) {
                    Task { await createAccount() }
                }
                Button("Already have an account? Sign In") { onShowSignIn?() }
                    .font(.headline)
            }
            .toolbar {
                if onBack != nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back", systemImage: "chevron.left") { onBack?() }
                    }
                }
            }
        }
    }

    @MainActor
    private func createAccount() async {
        errorMessage = ""
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password can't be empty."
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters."
            return
        }

        isSubmitting = true
        defer { isSubmitting = false }
        do {
            try await AuthManager.shared.signUp(email: normalizedEmail, password: password)
            onAuthenticated?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct SignInView: View {
    var onAuthenticated: (() -> Void)?
    var onShowSignUp: (() -> Void)?
    var onBack: (() -> Void)?

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isSubmitting = false
    @State private var showForgotPassword = false
    @State private var resetInfoMessage = ""

    var body: some View {
        NavigationStack {
            EntryAuthForm(title: "Welcome Back", subtitle: "Sign in to continue your training") {
                EntryEmailField(email: $email)
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .entryAuthFieldStyle()
                
                HStack {
                    Spacer()
                    Button("Forgot password?") {
                        showForgotPassword = true
                    }
                    .font(.footnote)
                }
                
                EntryAuthError(message: errorMessage)
                
                if !resetInfoMessage.isEmpty {
                    Text(resetInfoMessage)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                EntryAuthSubmitButton(title: "Sign In", isSubmitting: isSubmitting) {
                    Task { await signIn() }
                }
                Button("Don't have an account? Sign Up") { onShowSignUp?() }
                    .font(.headline)
            }
            .toolbar {
                if onBack != nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back", systemImage: "chevron.left") { onBack?() }
                    }
                }
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView(onBack: { showForgotPassword = false }, onSent: { email in
                    resetInfoMessage = "If an account exists for \(email), you'll receive a reset email shortly."
                })
            }
        }
    }

    @MainActor
    private func signIn() async {
        errorMessage = ""
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password can't be empty."
            return
        }

        isSubmitting = true
        defer { isSubmitting = false }
        do {
            try await AuthManager.shared.signIn(email: normalizedEmail, password: password)
            onAuthenticated?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct EntryAuthForm<Content: View>: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            PaperBackground()
            ScrollView {
                VStack(spacing: 22) {
                    Image(systemName: "flag.checkered.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Theme.primary)
                    Text(title)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    Text(subtitle)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    content
                }
                .padding(24)
                .frame(maxWidth: 520)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct EntryEmailField: View {
    @Binding var email: String

    var body: some View {
        TextField("Email", text: $email)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .entryAuthFieldStyle()
    }
}

private struct EntryAuthError: View {
    let message: String

    var body: some View {
        if !message.isEmpty {
            Text(message)
                .font(.callout)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        }
    }
}

private struct EntryAuthSubmitButton: View {
    let title: LocalizedStringKey
    let isSubmitting: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isSubmitting {
                    ProgressView().tint(.white)
                } else {
                    Text(title).font(.headline)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Theme.heroGradient, in: Capsule())
        }
        .disabled(isSubmitting)
    }
}

private extension View {
    func entryAuthFieldStyle() -> some View {
        padding()
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.primary.opacity(0.1))
            }
    }
}
// MARK: - Forgot Password View

private struct ForgotPasswordView: View {
    var onBack: (() -> Void)?
    var onSent: ((String) -> Void)?

    @State private var email = ""
    @State private var errorMessage = ""
    @State private var infoMessage = ""
    @State private var isSubmitting = false

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView {
                    VStack(spacing: 18) {
                        Image(systemName: "envelope.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(Theme.primary)
                        Text("Forgot Password")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        Text("Enter your account email and we'll send you a reset link.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 8)

                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .entryAuthFieldStyle()

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.callout)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }
                        if !infoMessage.isEmpty {
                            Text(infoMessage)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        Button(action: { Task { await sendReset() } }) {
                            Group {
                                if isSubmitting {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Send Reset Link").font(.headline)
                                }
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Theme.heroGradient, in: Capsule())
                        }
                        .disabled(isSubmitting)
                    }
                    .padding(24)
                    .frame(maxWidth: 520)
                    .frame(maxWidth: .infinity)
                }
            }
            .toolbar {
                if onBack != nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back", systemImage: "chevron.left") { onBack?() }
                    }
                }
            }
        }
    }

    @MainActor
    private func sendReset() async {
        errorMessage = ""
        infoMessage = ""
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else {
            errorMessage = "Email can't be empty."
            return
        }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            try await AuthManager.shared.resetPassword(email: normalized)
            infoMessage = "If an account exists for \(normalized), you'll receive a reset email shortly."
            onSent?(normalized)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

