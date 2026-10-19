# TodayView Build Error Fix

## Error: Cannot find 'TodayView' in scope

### Root Cause
The file `TodayView.swift` exists in your project but is **not added to the build target**. This means when `MainViews.swift` and `RootTabView.swift` try to use `TodayView()`, the compiler cannot find it.

---

## ✅ Solution: Add TodayView.swift to Build Target

### Step 1: Select the File
1. In Xcode's **Project Navigator** (left sidebar), find and click on `TodayView.swift`

### Step 2: Open File Inspector
2. Open the **File Inspector** in the right sidebar:
   - Menu: `View → Inspectors → Show File Inspector`
   - Or press: `⌥⌘1` (Option-Command-1)

### Step 3: Check Target Membership
3. In the File Inspector, look for the **Target Membership** section
4. **Check the box** next to your app target (likely named "RaceTrian")

### Step 4: Clean and Build
5. Clean the build folder: `Product → Clean Build Folder` (⇧⌘K)
6. Build the project: `Product → Build` (⌘B)

---

## 🔍 Verify the Fix

After adding the file to the target, the error should disappear. Verify by:

1. **Build the project** (⌘B) - should succeed with no errors
2. **Check the import** - TodayView should now be visible to other files
3. **Run the app** (⌘R) - Today tab should appear correctly

---

## 📋 What TodayView Provides

`TodayView.swift` contains:
- **TodayView**: Main view showing today's activities and stats
- **TodayStatCard**: Glass-effect stat cards (calories, steps, active time)
- **TodayActivityRow**: Individual activity rows with completion status
- **TodayQuickActionButton**: Quick action buttons (Log Workout, Scan Meal, Log Water)
- **WeeklyProgressCard**: Weekly progress visualization

---

## 🔧 Alternative: Verify All Files Are in Target

If the issue persists, check that ALL required files are in the target:

### Required Files (must be checked):
- ✅ `TodayView.swift` ← **This is the one causing the error**
- ✅ `Theme.swift` (provides Theme colors and GlassEffectContainer)
- ✅ `PlanView.swift` (Plan tab view)
- ✅ `ProfileView.swift` (More/Profile tab view)
- ✅ `MainViews.swift` (uses TodayView)
- ✅ `RootTabView.swift` (uses TodayView)

### How to Check All Files:
1. Select your **project** in Project Navigator (top item)
2. Select your **app target** in the project editor
3. Go to **Build Phases** tab
4. Expand **Compile Sources**
5. Verify `TodayView.swift` appears in the list
6. If not, click **+** and add it

---

## ⚠️ If Error Persists After Adding to Target

### Clean Derived Data:
```bash
# Option 1: Using Xcode
# 1. Xcode → Preferences → Locations
# 2. Click arrow next to Derived Data
# 3. Delete the entire DerivedData folder

# Option 2: Using Terminal
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### Full Clean Steps:
1. Close Xcode
2. Delete Derived Data (see above)
3. Reopen Xcode
4. Clean Build Folder (⇧⌘K)
5. Build (⌘B)

---

## 📝 Files Using TodayView

These files reference `TodayView()` and will fail to compile if TodayView.swift is not in the target:

### MainViews.swift (Line 11)
```swift
struct MainTabView: View {
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()  // ← Error here if not in target
                .tabItem {
                    Label("Today", systemImage: "calendar.circle.fill")
                }
```

### RootTabView.swift (Line 106)
```swift
struct RootTabView: View {
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()  // ← Error here if not in target
                .tabItem {
                    Label("Today", systemImage: "calendar.circle.fill")
                }
```

---

## ✨ Expected Result

After adding `TodayView.swift` to the target, your app will have a fully functional Today tab with:

- 📊 **Hero Stats**: Calories, Steps, Active minutes
- 📅 **Today's Schedule**: Time-based activity list
- ⚡ **Quick Actions**: Log Workout, Scan Meal, Log Water
- 📈 **Weekly Progress**: Visual progress bars for the week

---

## 🆘 Still Having Issues?

If you've added the file to the target and still see the error:

1. **Check for typos**: Make sure `struct TodayView: View` exists in TodayView.swift
2. **Check imports**: TodayView.swift should have `import SwiftUI` at the top
3. **Check access control**: `struct TodayView: View` should NOT be marked `private` or `fileprivate`
4. **Restart Xcode**: Sometimes Xcode needs a full restart to pick up changes

---

**The code is correct - you just need to add the file to your build target!** ✅
