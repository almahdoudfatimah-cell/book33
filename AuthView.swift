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
            AuthFormLayout(title: "Create Account", subtitle: "Save your training and sync it across devices") {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .authFieldStyle()

                SecureField("Password", text: $password)
                    .textContentType(.newPassword)
                    .authFieldStyle()

                SecureField("Confirm Password", text: $confirmPassword)
                    .textContentType(.newPassword)
                    .authFieldStyle()

                AuthErrorMessage(message: errorMessage)

                AuthSubmitButton(title: "Create Account", isSubmitting: isSubmitting) {
                    Task { await createAccount() }
                }

                Button("Already have an account? Sign In") {
                    onShowSignIn?()
                }
                .font(.headline)
            }
            .toolbar { backToolbar }
        }
    }

    @ToolbarContentBuilder
    private var backToolbar: some ToolbarContent {
        if onBack != nil {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back", systemImage: "chevron.left") { onBack?() }
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
    @State private var showForgot = false
    @State private var resetInfoMessage = ""

    var body: some View {
        NavigationStack {
            AuthFormLayout(title: "Welcome Back", subtitle: "Sign in to continue your training") {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .authFieldStyle()

                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .authFieldStyle()

                HStack {
                    Spacer()
                    Button("Forgot password?") { showForgot = true }
                        .font(.footnote)
                }

                AuthErrorMessage(message: errorMessage)

                if !resetInfoMessage.isEmpty {
                    Text(resetInfoMessage)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                AuthSubmitButton(title: "Sign In", isSubmitting: isSubmitting) {
                    Task { await signIn() }
                }

                Button("Don't have an account? Sign Up") {
                    onShowSignUp?()
                }
                .font(.headline)
            }
            .toolbar { backToolbar }
            .sheet(isPresented: $showForgot) {
                ForgotPasswordView(onBack: { showForgot = false }, onSent: { email in
                    resetInfoMessage = "If an account exists for \(email), you'll receive a reset email shortly."
                })
            }
        }
    }

    @ToolbarContentBuilder
    private var backToolbar: some ToolbarContent {
        if onBack != nil {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back", systemImage: "chevron.left") { onBack?() }
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

private struct AuthFormLayout<Content: View>: View {
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

private struct AuthErrorMessage: View {
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

private struct AuthSubmitButton: View {
    let title: LocalizedStringKey
    let isSubmitting: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isSubmitting {
                    ProgressView().tint(.white)
                } else {
                    Text(title)
                        .font(.headline)
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
    func authFieldStyle() -> some View {
        padding()
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.primary.opacity(0.1))
            }
    }
}
