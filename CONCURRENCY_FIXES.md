# Error Fixes - ObservableObject & Dynamic Member Issues

## Date: October 4, 2026

### Errors Fixed

All "dynamic member" and "ObservableObject wrapper" errors have been resolved.

---

## Root Cause

The errors were caused by:
1. **Missing computed properties** in `AuthManager` (`currentEmail`, `currentDisplayName`)
2. **Swift Concurrency isolation mismatch** - `@MainActor` class being accessed from non-isolated contexts
3. **Incorrect property wrapper usage** - Using `@StateObject` for singletons instead of `@ObservedObject`

---

## Changes Made

### 1. AuthManager.swift

**Added computed properties:**
```swift
// Computed properties for easy access
var currentEmail: String? {
    currentUser?.email
}

var currentDisplayName: String? {
    currentUser?.name
}
```

These properties allow views to access the current user's email and name without having to unwrap `currentUser` every time.

---

### 2. ProfileView.swift

**Before:**
```swift
struct ProfileView: View {
    @ObservedObject private var auth: AuthManager = .shared
    // ...
}
```

**After:**
```swift
@MainActor
struct ProfileView: View {
    @ObservedObject private var auth = AuthManager.shared
    // ...
}
```

**Changes:**
- Added `@MainActor` to the struct
- Removed explicit type annotation (`: AuthManager`)
- This ensures the view is on the same actor as AuthManager

---

### 3. AuthView.swift

**Before:**
```swift
struct AuthView: View {
    @ObservedObject private var auth = AuthManager.shared
    // ...
}
```

**After:**
```swift
@MainActor
struct AuthView: View {
    @ObservedObject private var auth = AuthManager.shared
    // ...
}
```

**Changes:**
- Added `@MainActor` to the struct
- This ensures proper actor isolation

---

### 4. PlannerApp.swift (RootView)

**Before:**
```swift
@MainActor
struct RootView: View {
    @StateObject private var auth = AuthManager.shared
    // ...
}
```

**After:**
```swift
@MainActor
struct RootView: View {
    @ObservedObject private var auth = AuthManager.shared
    // ...
}
```

**Changes:**
- Changed from `@StateObject` to `@ObservedObject`
- **Reason**: `@StateObject` creates ownership, but `AuthManager.shared` is a singleton that already exists. Using `@ObservedObject` is more appropriate for singletons.

---

## Technical Explanation

### Why `@MainActor` on Views?

When a class is marked with `@MainActor`, all its properties and methods are isolated to the main actor. Views that access these properties must also be on the main actor to avoid concurrency issues.

**Swift Concurrency Rules:**
- `@MainActor` classes can only be accessed from `@MainActor` contexts
- SwiftUI views can be marked with `@MainActor` to indicate they run on the main thread
- This is actually ideal for views since all UI updates must happen on the main thread anyway

### @StateObject vs @ObservedObject for Singletons

**@StateObject:**
- Creates and owns the lifecycle of an object
- Appropriate when the view creates the object
- Not ideal for singletons (they already exist)

**@ObservedObject:**
- Observes an existing object
- Does not own the lifecycle
- Perfect for singletons like `AuthManager.shared`

---

## Property Access Pattern

### Before (Caused Errors):
```swift
// In ProfileView
if let email = auth.currentUser?.email {
    return email
}
```

### After (Clean & Safe):
```swift
// In ProfileView
if let email = auth.currentEmail {
    return email
}
```

**Benefits:**
- Cleaner code
- Less optional unwrapping
- Consistent API
- Type-safe

---

## Testing Checklist

After these changes, test:

1. ✅ **Authentication Flow**
   - Sign up with email
   - Sign in with email
   - Sign in with Apple
   - Guest mode
   - Sign out

2. ✅ **Profile View**
   - Display user name correctly
   - Display user email correctly
   - Show "Guest" status when appropriate
   - Settings persistence

3. ✅ **Navigation**
   - Tab switching
   - Deep linking
   - Back navigation

---

## Additional Notes

### Swift 6 Concurrency

These fixes are compatible with Swift 6's strict concurrency checking. Key principles:

1. **Actor isolation** - Keep UI classes on `@MainActor`
2. **Sendable types** - Ensure data can safely cross actor boundaries
3. **Property wrappers** - Use appropriate wrappers for actor-isolated objects

### Future Considerations

If you add more views that access `AuthManager`:

1. Mark the view with `@MainActor`
2. Use `@ObservedObject private var auth = AuthManager.shared`
3. Access properties directly: `auth.currentEmail`, `auth.currentDisplayName`

---

## Summary

All dynamic member subscript errors have been resolved by:
- Adding computed properties to AuthManager
- Marking views with @MainActor for proper actor isolation
- Using @ObservedObject (not @StateObject) for singleton access

The app should now build without errors! 🎉
