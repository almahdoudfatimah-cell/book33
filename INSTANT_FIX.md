# ⚡ INSTANT FIX - Copy and Paste This

## Run This Command in Terminal:

```bash
cd ~/Desktop/RaceTrian && python3 fix_build.py
```

**That's it!** The script will:
- ✅ Remove all 20 broken file references
- ✅ Clean build cache
- ✅ Create a backup of your project
- ✅ Fix everything automatically

Then in Xcode:
1. Press `⌘⇧K` (Clean)
2. Click `PlannerApp.swift` → File Inspector → Check "RaceTrian" under Target Membership
3. Press `⌘B` (Build)
4. ✅ Done!

---

## If You Don't Have Python:

```bash
cd ~/Desktop/RaceTrian && chmod +x fix_build.sh && ./fix_build.sh
```

---

## What These Scripts Do:

1. **Backup** your project file (so nothing is lost)
2. **Remove** the 20 broken file references from Xcode
3. **Clean** derived data and build cache
4. **Tell you** what to do next

---

## After Running the Script:

You'll see output like:
```
🔧 RaceTrian Build Fix Script
==============================

✅ Found project: ./RaceTrian.xcodeproj
✅ Found project.pbxproj
✅ Created backup: project.pbxproj.backup.20261014_153045

🗑️  Removing broken file references...
   Removing references to: AIPlannerSheet.swift
   Removing references to: TrainingStore.swift
   ... (18 more)

✅ Removed references to 20 files
✅ PlannerApp.swift is in the project
✅ Cleaned derived data
✅ Cleaned module cache

==============================
✅ Build fix script complete!
==============================
```

---

## Then Just:

1. Open Xcode
2. `⌘⇧K` (Clean)
3. Click `PlannerApp.swift`, check the Target Membership box
4. `⌘B` (Build)

**Total time: 1 minute** ⏱️

---

## Why This Works:

The scripts **directly edit your Xcode project file** to remove the broken references. This is the same thing you'd do manually in Xcode, but automated.

After the script runs, Xcode will no longer look for those 20 missing files.

The ONLY manual step is checking the Target Membership box for `PlannerApp.swift` (because that requires Xcode to be open).

---

**Just copy-paste the command above and you're 90% done!** 🚀
