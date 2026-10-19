# 🚨 CRITICAL FIX: Undefined symbol: _main

## The Problem

**Error:** `Undefined symbol: _main`  
**Cause:** Your main app file (`PlannerApp.swift`) is NOT included in the build target

This means Xcode can't find the `@main` entry point to start your app.

---

## ✅ THE FIX (1 minute)

### Step 1: Add PlannerApp.swift to Build Target

1. In Xcode Project Navigator, click on **`PlannerApp.swift`**
2. Open the **File Inspector** (right sidebar, or press `⌥⌘1`)
3. Look for **"Target Membership"** section
4. **CHECK the box** next to **"RaceTrian"** (your app target)

That's it! The file is now included in the build.

---

### Step 2: Verify Other Critical Files

While you're at it, make sure these files are ALSO checked in Target Membership:

Essential files that MUST be in target:
- ✅ `PlannerApp.swift` (the @main file)
- ✅ `HomeView.swift`
- ✅ `Theme.swift`
- ✅ `MissingImplementations.swift`
- ✅ `NewProfileView.swift`

Files to REMOVE from target if they appear:
- ❌ `MissingFilesPlaceholder.swift` (duplicate - delete this file entirely)

---

### Step 3: Clean and Build

1. Press **⌘⇧K** (Clean Build Folder)
2. Press **⌘B** (Build)
3. ✅ **Success!**

---

## 🔍 Why This Happened

When you:
- Moved files around
- Renamed files
- Deleted and re-added files
- Fixed previous issues

...Xcode sometimes loses track of which files should be compiled.

The `@main` attribute in `PlannerApp.swift` tells Swift "this is where the app starts," but if that file isn't included in the build, Xcode can't find the entry point.

---

## 📋 Complete Checklist

### Files That MUST Be In Build Target:

**Core App Files:**
- [ ] PlannerApp.swift (contains `@main`)
- [ ] HomeView.swift
- [ ] Theme.swift

**New Implementation Files:**
- [ ] MissingImplementations.swift
- [ ] NewProfileView.swift

**Other Views (check if they exist):**
- [ ] TodayView.swift
- [ ] DiaryView.swift
- [ ] ProfileView.swift
- [ ] ContentView.swift (if exists)

**Models & Stores:**
- [ ] Any custom model files you have
- [ ] ProfileStore.swift (if exists)
- [ ] PremiumStore.swift (if exists)

### Files That Should NOT Be In Build:

- [ ] ❌ MissingFilesPlaceholder.swift (DELETE this file)
- [ ] ❌ Any file names showing in RED in Project Navigator
- [ ] ❌ Any duplicate .swift files
- [ ] ❌ Markdown files (.md)

---

## 🎯 Visual Guide

### What "Target Membership" Looks Like:

When you click on a file and open File Inspector (right sidebar), you'll see:

```
TARGET MEMBERSHIP
☑ RaceTrian          ← This should be CHECKED for Swift files
☐ RaceTrianTests     ← Optional
☐ AppWatch Watch App ← Only for Watch-specific files
```

### For PlannerApp.swift specifically:

```
TARGET MEMBERSHIP
☑ RaceTrian          ← MUST be checked!
```

---

## 🔧 Alternative Fix (If Step 1 Doesn't Work)

### Method 2: Re-add the File to Project

If checking the box doesn't work:

1. In Project Navigator, find `PlannerApp.swift`
2. Right-click → **Delete** → **Remove Reference** (NOT "Move to Trash")
3. Right-click on your project folder → **Add Files to "RaceTrian"...**
4. Navigate to where `PlannerApp.swift` is
5. Select it
6. **IMPORTANT:** Make sure "Add to targets: RaceTrian" is CHECKED
7. Click **Add**

Now the file is properly re-added with correct target membership.

---

## 🆘 Still Getting the Error?

### Check for Multiple @main Attributes

Search your project for `@main`:

1. Press **⌘⇧F** (Find in Project)
2. Search for: `@main`
3. You should see **EXACTLY ONE** result in `PlannerApp.swift`

If you see multiple `@main` attributes, that's a problem! You can only have ONE entry point.

**Keep:** `@main` in `PlannerApp.swift`  
**Delete:** Any other `@main` declarations

---

### Check PlannerApp.swift Content

Open `PlannerApp.swift` and verify it has this structure:

```swift
import SwiftUI

@main
struct RaceTrianApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
```

If it's missing `@main` or has syntax errors, that could cause the issue.

---

## ✅ After the Fix

Once you add `PlannerApp.swift` to the target and build:

- ✅ No more "Undefined symbol: _main" error
- ✅ App compiles successfully
- ✅ App launches and shows your HomeView
- ✅ All features work as expected

---

## 📊 Summary

**The Issue:** Main app file not in build target  
**The Fix:** Check "Target Membership" for PlannerApp.swift  
**Time Required:** 1 minute  
**Difficulty:** Very Easy ⭐

---

**This is the most critical fix - without it, the app literally cannot start!**
