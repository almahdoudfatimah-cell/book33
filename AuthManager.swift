//
//  AuthManager.swift
//  RaceTrian
//
//  Created on 10/14/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated: Bool = false
    @Published var isGuest: Bool = true
    @Published var currentEmail: String?
    @Published var currentUser: User?
    
    private init() {
        loadAuthState()
    }
    
    // MARK: - Authentication State
    
    private func loadAuthState() {
        isGuest = UserDefaults.standard.bool(forKey: "isGuestUser")
        currentEmail = UserDefaults.standard.string(forKey: "userEmail")
        isAuthenticated = !isGuest && currentEmail != nil
    }
    
    // MARK: - Sign In
    
    func signIn(email: String, password: String) async throws {
        // TODO: Implement your sign-in logic with backend
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // Store authentication state
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(false, forKey: "isGuestUser")
        
        currentEmail = email
        isGuest = false
        isAuthenticated = true
    }

    func signUp(email: String, password: String) async throws {
        // The backend account-creation request belongs here. Until it is
        // connected, keep local authentication behavior consistent with sign in.
        try await signIn(email: email, password: password)
    }

    // MARK: - Password Reset
    func resetPassword(email: String) async throws {
        // TODO: Integrate with your backend's password reset endpoint.
        // For now, simulate a network call and success response.
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email can't be empty."]) }
        try await Task.sleep(nanoseconds: 600_000_000)
        // In a real implementation, you would not change auth state here.
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        // Clear authentication state
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.set(true, forKey: "isGuestUser")
        
        currentEmail = nil
        isGuest = true
        isAuthenticated = false
        currentUser = nil
    }
    
    // MARK: - Guest Mode
    
    func continueAsGuest() {
        UserDefaults.standard.set(true, forKey: "isGuestUser")
        isGuest = true
        isAuthenticated = false
    }
    
    // MARK: - Reset (Debug)
    
    func resetToOnboarding() {
        // Clear all user data
        signOut()
        
        // Reset onboarding state
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        
        // You might need to trigger a navigation reset in your app
        // This could be done through a notification or a published property
        NotificationCenter.default.post(name: NSNotification.Name("ResetToOnboarding"), object: nil)
    }
}

// MARK: - User Model

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let name: String?
    
    // Add any other user properties you need
}
