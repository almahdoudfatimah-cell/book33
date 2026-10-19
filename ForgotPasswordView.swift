import SwiftUI

struct ForgotPasswordView: View {
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
                            .padding()
                            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.primary.opacity(0.1))
                            }

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

#Preview { ForgotPasswordView() }
