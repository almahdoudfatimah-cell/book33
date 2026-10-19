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
            VStack(spacing: 24) {
                Text("Create Account")
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
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
                    .multilineTextAlignment(.center)
            }
            
                Button {
                    Task { await createAccount() }
                } label: {
                    if isSubmitting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Create Account")
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
            
            Button("Already have an account? Sign In") {
                onShowSignIn?()
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

#Preview {
    SignUpView()
}
