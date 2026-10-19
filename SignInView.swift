import SwiftUI

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
            VStack(spacing: 24) {
                Text("Sign In")
                    .font(.largeTitle.bold())
                    .padding(.top, 32)
            
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                
                HStack {
                    Spacer()
                    Button("Forgot password?") { showForgot = true }
                        .font(.footnote)
                }
            
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                }
                
                if !resetInfoMessage.isEmpty {
                    Text(resetInfoMessage)
                        .foregroundColor(.secondary)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    Task { await signIn() }
                } label: {
                    if isSubmitting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Sign In")
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top)
                .disabled(isSubmitting)
                
                Button("Don't have an account? Sign Up") {
                    onShowSignUp?()
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
            .toolbar {
                if onBack != nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back", systemImage: "chevron.left") {
                            onBack?()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showForgot) {
            ForgotPasswordView(onBack: { showForgot = false }, onSent: { email in
                resetInfoMessage = "If an account exists for \(email), you'll receive a reset email shortly."
            })
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

#Preview {
    SignInView()
}
