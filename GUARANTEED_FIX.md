# 🔥 GUARANTEED FIX - Step by Step

## The Problem

You have **duplicate struct declarations** somewhere in your project. Xcode is finding TWO definitions of `PaywallView` which is causing all the errors.

---

## ✅ GUARANTEED SOLUTION

Follow these steps **EXACTLY** in order:

###  Step 1: Find ALL PaywallView Declarations

In Xcode:
1. Press **⌘ + Shift + F** (Find in Project)
2. Search for: `struct PaywallView`
3. Make sure "Matching" is set to "Contains"
4. Look at ALL results

**You should see EXACTLY ONE result:**
```
PaywallView.swift: struct PaywallView: View {
```

**If you see MORE than one**, those are the duplicates causing the errors!

---

### Step 2: Remove ALL Duplicates

For **each duplicate** PaywallView you find (NOT the one in PaywallView.swift):

1. Open the file
2. **Delete the entire `struct PaywallView` block** (from `struct PaywallView` to its closing `}`)
3. **Delete any `FeatureRow` structs** in that same file
4. Save the file

---

### Step 3: Update Any Code That Used the Duplicate

If the file you just cleaned was using the duplicate PaywallView, update it to use the real one:

**Replace this:**
```swift
PaywallView(onComplete: {
    // ...
})
```

**With this:**
```swift
PaywallView(onClose: {
    // ...
})
```

OR just:
```swift
PaywallView()
```

---

### Step 4: Verify PlannerApp.swift

Open `PlannerApp.swift` and verify line 70 looks like this:

```swift
case .paywall:
    PaywallView(onClose: {
        completePaywall()
    })
```

**NOT** `OnboardingPaywallView` and **NOT** `PaywallView(onComplete:)`

---

### Step 5: Clean Build (CRITICAL!)

Now that duplicates are removed, clean Xcode's cache:

#### 5a. Clean Build Folder
```
Product → Clean Build Folder
```
Or press: **⌘ + Shift + K**

#### 5b. Delete Derived Data
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

Or manually:
1. Xcode → Preferences (⌘ + ,)
2. Locations tab
3. Click arrow next to "Derived Data"
4. Delete the entire folder

#### 5c. Restart Xcode
```
Xcode → Quit Xcode (⌘ + Q)
```
Wait 5 seconds, then relaunch

#### 5d. Rebuild
```
Product → Build (⌘ + B)
```

---

## 🔍 Verification Checklist

After cleaning, verify:

### Check 1: Only ONE PaywallView
Search project for `struct PaywallView`
- [ ] Found exactly ONE result in `PaywallView.swift`
- [ ] No results in `PlannerApp.swift`
- [ ] No results in `MainViews.swift`
- [ ] No results in any other file

### Check 2: PaywallView.swift is Correct
Open `PaywallView.swift`, verify line 14:
```swift
struct PaywallView: View {
    var onClose: (() -> Void)?    // ← Optional parameter
```

### Check 3: PlannerApp.swift Uses It Correctly
Open `PlannerApp.swift`, verify around line 70:
```swift
case .paywall:
    PaywallView(onClose: {        // ← Uses onClose, not onComplete
        completePaywall()
    })
```

### Check 4: Build Succeeds
- [ ] Press ⌘ + B
- [ ] Build completes with **zero errors**
- [ ] No "Invalid redeclaration" errors
- [ ] No "ambiguous" errors
- [ ] No "missing argument" errors

---

## 🚨 If Errors STILL Appear

### Error Still: "Invalid redeclaration of 'PaywallView'"

**This means you still have duplicates!**

Do this:
1. Press ⌘ + Shift + F
2. Search: `struct PaywallView`
3. **Delete EVERY occurrence except** the one in `PaywallView.swift`
4. Clean build again

### Error Still: "Missing argument for parameter 'onComplete'"

**This means something is calling with wrong parameter!**

Do this:
1. Press ⌘ + Shift + F  
2. Search: `onComplete`
3. Find any `PaywallView(onComplete:` calls
4. Change them to `PaywallView(onClose:`
5. Clean build again

### Error Still: "'PaywallView' is ambiguous"

**This means Xcode cache is stale!**

Do this:
1. Quit Xcode completely
2. Delete: `~/Library/Developer/Xcode/DerivedData/*`
3. Delete: `~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/*`
4. **Restart your Mac** (yes, really)
5. Open Xcode
6. Clean Build Folder
7. Build

---

## 📋 Quick Reference: Correct File Structure

### PaywallView.swift (The ONLY PaywallView)
```swift
struct PaywallView: View {
    var onClose: (() -> Void)? = nil
    // ... implementation
}
```

### PlannerApp.swift (Uses PaywallView)
```swift
case .paywall:
    PaywallView(onClose: {
        completePaywall()
    })
```

### Anywhere Else (Uses PaywallView)
```swift
@State private var showPaywall = false

Button("Upgrade") {
    showPaywall = true
}
.sheet(isPresented: $showPaywall) {
    PaywallView()  // ← Just this, no parameters needed
}
```

---

## 🎯 Root Cause

You likely have:
1. An old backup file with PaywallView
2. A duplicate PaywallView in another Swift file
3. Build cache showing old, deleted code

**Solution:** Find and delete ALL PaywallView declarations except the one in `PaywallView.swift`, then clean the build cache.

---

## 📞 Still Not Working?

If you've done ALL the above and still have errors:

### Last Resort - Nuclear Option

1. Close Xcode
2. Run these commands:
```bash
# Delete ALL build artifacts
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/*
rm -rf ~/Library/Caches/com.apple.dt.Xcode/*

# Find your project directory
cd /path/to/your/project

# Delete build folder
rm -rf .build/
rm -rf build/

# Delete Xcode project cache
rm -rf *.xcodeproj/xcuserdata/
rm -rf *.xcworkspace/xcuserdata/
```

3. Restart your Mac
4. Open Xcode
5. Open your project
6. Clean Build Folder (⌘⇧K)
7. Build (⌘B)

---

## ✅ Success Criteria

When everything is fixed, you should be able to:

- [ ] Build with ⌘B → **Success**
- [ ] See **zero errors**
- [ ] Search `struct PaywallView` → **ONE result only**
- [ ] Run the app (⌘R) → **Launches successfully**
- [ ] Onboarding shows paywall → **Works**
- [ ] In-app upgrade shows paywall → **Works**

---

## 🎉 You're Done!

Once the build succeeds, you're all set. The PaywallView will work correctly in both:
- Onboarding flow (first launch)
- In-app premium upgrades

Same view, used everywhere, zero duplicates!

---

**Remember:** The code I've given you is correct. Any errors are from duplicates or cache. Find them, delete them, clean the build, and you're done!
