# 🔍 WHICH FILES ARE CAUSING DUPLICATES?

## Current Errors Show:

- "Invalid redeclaration of 'Theme'" ← Multiple files define Theme
- "Invalid redeclaration of 'GlassCard'" ← Multiple files define GlassCard
- "Invalid redeclaration of 'PaperBackground'" ← Multiple files define PaperBackground
- "Invalid redeclaration of 'TrackingData'" ← Multiple files define TrackingData
- "Invalid redeclaration of 'appPageTheme()'" ← Multiple files define appPageTheme

## How to Find Duplicates in Xcode

### Method 1: Build Phases

1. Click the **blue project icon** at top of Project Navigator
2. Select **"RaceTrian"** target (under TARGETS)
3. Click **"Build Phases"** tab
4. Expand **"Compile Sources"**
5. Look for these files:

**Files that might be there (causing duplicates):**
- [ ] CompleteThemeAndViews.swift
- [ ] ThemeFix.swift
- [ ] ThemeAndMissingTypes.swift
- [ ] Theme.swift
- [ ] UIPlaceholders 2.swift
- [ ] UIPlaceholders.swift
- [ ] UIPlaceholders 3.swift
- [ ] MissingViews.swift

**What you should do:**
- ✅ Keep ONLY `CompleteThemeAndViews.swift`
- ❌ Remove ALL others from the list

### Method 2: File Inspector (One by One)

For each file above:

1. Click the file in Project Navigator
2. Press `⌥⌘1` (File Inspector)
3. Look at "Target Membership"
4. Check which targets are checked

**Goal:** Only `CompleteThemeAndViews.swift` should have "RaceTrian" checked.

---

## Action Plan

### Phase 1: Remove All Duplicate Files from iOS Target

Uncheck "RaceTrian" for these files (if they're checked):

- [ ] `ThemeFix.swift`
- [ ] `ThemeAndMissingTypes.swift`
- [ ] `Theme.swift`
- [ ] `UIPlaceholders.swift`
- [ ] `UIPlaceholders 2.swift`
- [ ] `UIPlaceholders 3.swift`
- [ ] `MissingViews.swift`

### Phase 2: Verify CompleteThemeAndViews.swift is in Target

- [ ] `CompleteThemeAndViews.swift` → RaceTrian should be ✅ CHECKED

### Phase 3: Clean and Build iOS App

```
⌘⇧K  (Clean)
⌘B   (Build RaceTrian scheme)
```

### Phase 4: Fix Watch App

Once iOS app builds successfully, we'll fix the Watch app issue.

---

## Quick Test: Are Multiple Files in Target?

Run this test in Xcode:

1. **⌘⇧F** (Find in Project)
2. Search for: `public enum Theme {`
3. Click "Find"
4. Look at results

**If you see multiple files:**
- That confirms duplicates
- All but one need to be removed from target

**If you see only one file:**
- Good! But it might not be in the target
- Check that file's Target Membership

---

## Visual: Build Phases → Compile Sources

This is what you should see:

```
▼ Compile Sources (should have CompleteThemeAndViews.swift)

  ✅ CompleteThemeAndViews.swift        ← KEEP THIS
  ❌ ThemeFix.swift                      ← REMOVE (click -)
  ❌ ThemeAndMissingTypes.swift          ← REMOVE (click -)
  ❌ Theme.swift                         ← REMOVE (click -)
  ❌ UIPlaceholders 2.swift              ← REMOVE (click -)
  
  ... (other files are fine)
```

To remove a file:
1. Click on it in the list
2. Click the **`-`** button at the bottom

This removes it from the build target but doesn't delete the file.

---

## Watch App Issue

The Watch app has 1 issue. Once we fix the iOS app, we'll address it.

Likely causes:
- Watch app is trying to use Theme from iOS files
- Watch app needs its own Theme definition
- Or watch app files have wrong target membership

---

## Next Steps

1. **Go to Build Phases** (Method 1 above)
2. **Find ALL theme-related files** in Compile Sources
3. **Remove all EXCEPT CompleteThemeAndViews.swift**
4. **Clean and Build**
5. **Report back** with results

---

**The key is: ONLY ONE file should define Theme, and it should be in the build target.**
