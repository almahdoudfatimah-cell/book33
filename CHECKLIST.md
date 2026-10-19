# ✅ BUILD FIX CHECKLIST

Print this and check off each item as you complete it!

---

## The 5-Step Fix (2 minutes)

### ☐ STEP 1: Open Xcode
- Open your RaceTrian project in Xcode
- Make sure Project Navigator is visible (left sidebar)

---

### ☐ STEP 2: Go to Build Phases

1. Click the **blue project icon** at top of Project Navigator
2. Select your **RaceTrian target** (under TARGETS)
3. Click **"Build Phases"** tab at the top
4. Expand **"Compile Sources"** (click the triangle)

---

### ☐ STEP 3: Remove These 20 Files

Find and click the **minus (-)** button for each of these files:

#### Views (9 files)
- ☐ `AIPlannerSheet.swift`
- ☐ `AIInsightCard.swift`
- ☐ `AddProjectSheet.swift`
- ☐ `AuthView.swift`
- ☐ `TrainingTrackingView.swift`
- ☐ `AssessmentView.swift`
- ☐ `AppPreferencesSection.swift`
- ☐ `AdditionalFeatureViews.swift`
- ☐ `UsersfatimahDesktopRaceTrianNewProfileView.swift`

#### Models (5 files)
- ☐ `AssessmentModels.swift`
- ☐ `TrainingModels.swift`
- ☐ `TrackingModels.swift`
- ☐ `UserProfile.swift`
- ☐ `ViewHelpers.swift`

#### Services (5 files)
- ☐ `AdditionalViews.swift`
- ☐ `TrainingStore.swift`
- ☐ `TrainingLogView.swift`
- ☐ `AssessmentStore.swift`
- ☐ `WeekTaskStore.swift`

#### App (1 file)
- ☐ `AppDelegate.swift` (if it shows the old path)

**Total removed: ____ / 20**

---

### ☐ STEP 4: Verify New Files Are Added

Still in "Compile Sources", scroll down and verify these files ARE there:

- ☐ `MissingImplementations.swift` ✅
- ☐ `NewProfileView.swift` ✅

If they're missing, click the **plus (+)** button and add them.

---

### ☐ STEP 5: Clean and Build

- ☐ Press **⌘⇧K** to clean
- ☐ Press **⌘B** to build
- ☐ **Success!** 🎉

---

## Quick Troubleshooting

### ❌ Can't find the files in Build Phases?
→ They might already be removed! Just make sure the new files are there (Step 4)

### ❌ New files are missing?
1. In Project Navigator, right-click `MissingImplementations.swift`
2. Choose "Show File Inspector" (or press ⌥⌘1)
3. Check "Target Membership" → ensure RaceTrian is checked ✓

### ❌ Still getting errors?
→ Make sure you removed ALL 20 files from the list above

---

## What You're Doing

You're telling Xcode:
- ❌ "Stop looking for these 20 old files that don't exist"
- ✅ "Use this new MissingImplementations.swift file instead"

That's it! Simple as that.

---

**Print Date:** October 14, 2026  
**Estimated Time:** 2-3 minutes  
**Difficulty:** Easy ⭐
