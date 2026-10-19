# 🚪 Logout Feature - Implementation Guide

## ✅ Already Implemented!

Your app **already has a fully functional logout feature**. Here's how it works:

---

## 📍 How to Log Out

### For Users:
1. Open the app
2. Go to the **"More"** tab (profile icon at bottom)
3. Scroll to the bottom
4. Tap the **"Sign Out"** button (red button with arrow icon)
5. Confirm by tapping **"Sign Out"** in the dialog
6. You'll be signed out and returned to the login screen

---

## 🔧 How It Works (Technical)

### AuthManager.swift
The logout logic is handled by `AuthManager.shared.signOut()`:

```swift
@MainActor
func signOut() {
    self.currentUser = nil
    self.isSignedIn = false
    self.isGuest = false
    clearUserData()
    print("🟢 AuthManager: User signed out - isSignedIn: \(self.isSignedIn)")
}
```

**What it does:**
- Sets `currentUser` to `nil`
- Sets `isSignedIn` to `false`
- Sets `isGuest` to `false`
- Clears user data from `UserDefaults`
- Logs the action

---

### ProfileView.swift
The UI for logout is in the ProfileView:

```swift
// Sign Out Button
Button {
    showSignOutConfirmation = true
} label: {
    HStack {
        Image(systemName: "rectangle.portrait.and.arrow.right")
            .font(.system(size: 18, weight: .semibold))
        Text("Sign Out")
            .font(.system(size: 17, weight: .semibold, design: .rounded))
    }
    .foregroundStyle(.red)
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
    .background(Color.red.opacity(0.1))
    .clipShape(RoundedRectangle(cornerRadius: 12))
}
```

**Confirmation Dialog:**
```swift
.confirmationDialog(
    "Are you sure you want to sign out?",
    isPresented: $showSignOutConfirmation,
    titleVisibility: .visible
) {
    Button("Sign Out", role: .destructive) {
        withAnimation {
            auth.signOut()
        }
    }
    Button("Cancel", role: .cancel) {}
}
```

---

### PlannerApp.swift (RootView)
When `isSignedIn` changes to `false`, the app automatically transitions back:

```swift
.onChange(of: auth.isSignedIn) { oldValue, isSignedIn in
    print("🔴 RootView: isSignedIn changed from \(oldValue) to \(isSignedIn)")
    
    guard hasCheckedInitialState else {
        print("🔴 RootView: Skipping - initial state not checked yet")
        return
    }
    
    withAnimation(.easeInOut(duration: 0.25)) {
        if isSignedIn {
            phase = .app
            print("🔴 RootView: User signed in - transitioning to app")
        } else {
            // User signed out - go back to intro to restart onboarding
            phase = .intro
            print("🔴 RootView: User signed out - restarting from intro")
        }
    }
}
```

---

## 🎯 Flow Diagram

```
User taps "Sign Out" button
         ↓
Confirmation dialog appears
         ↓
User confirms "Sign Out"
         ↓
AuthManager.signOut() is called
         ↓
• currentUser = nil
• isSignedIn = false
• isGuest = false
• UserDefaults cleared
         ↓
RootView detects isSignedIn = false
         ↓
Animates transition back to .intro phase
         ↓
User sees onboarding/login screen
```

---

## 🧪 Debug Feature (Development Only)

In **DEBUG mode**, there's also a **"Reset to Onboarding"** button that:
- Signs out the user
- Clears the "hasSeenOnboarding" flag
- Returns to the very first onboarding screen

This is useful for testing the onboarding flow.

```swift
#if DEBUG
Button {
    withAnimation {
        auth.resetToOnboarding()
    }
} label: {
    HStack {
        Image(systemName: "arrow.counterclockwise.circle")
        Text("Reset to Onboarding (Debug)")
    }
    .foregroundStyle(.orange)
}
#endif
```

---

## 📱 User Experience

1. **Confirmation Required**: Users must confirm before signing out (prevents accidental logouts)
2. **Smooth Animation**: Transition from app to login is animated
3. **Clear Visual**: Red color and arrow icon make it obvious
4. **Data Cleared**: All user session data is removed
5. **Fresh Start**: Returns to intro/login screen

---

## 🔒 What Gets Cleared

When signing out:
- ✅ Current user object
- ✅ Email and name
- ✅ Sign-in status
- ✅ Guest mode flag
- ✅ UserDefaults user data

What stays (app-level):
- ⚠️ Premium subscription status (handled separately by PremiumStore)
- ⚠️ App settings/preferences (if you want to keep them)

---

## ✨ Customization Options

If you want to customize the logout behavior:

### Option 1: Clear All Data on Logout
Add to `signOut()`:
```swift
@MainActor
func signOut() {
    self.currentUser = nil
    self.isSignedIn = false
    self.isGuest = false
    clearUserData()
    
    // Clear additional data
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    
    print("🟢 AuthManager: User signed out - isSignedIn: \(self.isSignedIn)")
}
```

### Option 2: Skip Onboarding After First Time
Modify `RootView.onChange`:
```swift
} else {
    // User signed out - go directly to account screen
    phase = .account  // Instead of .intro
    print("🔴 RootView: User signed out - showing login")
}
```

### Option 3: Add Logout from Other Screens
Use anywhere in your app:
```swift
@ObservedObject private var auth = AuthManager.shared
@State private var showSignOutConfirmation = false

Button("Sign Out") {
    showSignOutConfirmation = true
}
.confirmationDialog("Are you sure?", isPresented: $showSignOutConfirmation) {
    Button("Sign Out", role: .destructive) {
        auth.signOut()
    }
}
```

---

## 🎉 Summary

Your logout feature is **complete and working**! Users can:
- ✅ Sign out from the More tab
- ✅ Get confirmation before signing out
- ✅ See smooth animations
- ✅ Return to login/onboarding
- ✅ Sign in again with fresh session

No additional code needed - it's ready to use! 🚀
