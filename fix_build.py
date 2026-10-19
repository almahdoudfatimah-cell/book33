#!/usr/bin/env python3
"""
Automated Xcode Project Fix Script
Removes broken file references from project.pbxproj
"""

import os
import sys
import re
import shutil
from datetime import datetime
from pathlib import Path

def find_xcodeproj():
    """Find the .xcodeproj file in current directory"""
    for item in Path('.').iterdir():
        if item.is_dir() and item.suffix == '.xcodeproj':
            return item
    return None

def main():
    print("🔧 RaceTrian Build Fix Script (Python)")
    print("=" * 50)
    print()
    
    # Find project
    project_dir = find_xcodeproj()
    if not project_dir:
        print("❌ Error: Could not find .xcodeproj file")
        print("   Make sure you're in your project directory")
        return 1
    
    print(f"✅ Found project: {project_dir}")
    
    pbxproj_file = project_dir / "project.pbxproj"
    if not pbxproj_file.exists():
        print("❌ Error: Could not find project.pbxproj")
        return 1
    
    print(f"✅ Found project.pbxproj")
    print()
    
    # Create backup
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = pbxproj_file.with_suffix(f'.pbxproj.backup.{timestamp}')
    shutil.copy2(pbxproj_file, backup_file)
    print(f"✅ Created backup: {backup_file}")
    print()
    
    # Read the file
    with open(pbxproj_file, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.splitlines()
    
    # Files to remove
    files_to_remove = [
        'AIPlannerSheet.swift',
        'AIInsightCard.swift',
        'AddProjectSheet.swift',
        'AuthView.swift',
        'TrainingTrackingView.swift',
        'AssessmentView.swift',
        'AppPreferencesSection.swift',
        'AdditionalFeatureViews.swift',
        'UsersfatimahDesktopRaceTrianNewProfileView.swift',
        'AssessmentModels.swift',
        'TrainingModels.swift',
        'TrackingModels.swift',
        'UserProfile.swift',
        'ViewHelpers.swift',
        'AdditionalViews.swift',
        'TrainingStore.swift',
        'TrainingLogView.swift',
        'AssessmentStore.swift',
        'WeekTaskStore.swift',
        'MissingFilesPlaceholder.swift',
        'ProfileViewStubs.swift',
    ]
    
    print("🗑️  Removing broken file references...")
    print()
    
    # Track file references that will be removed
    file_refs_to_remove = set()
    
    # First pass: identify file references
    for i, line in enumerate(lines):
        for filename in files_to_remove:
            if filename in line and '/Users/fatimah/Desktop/RaceTrian' in line:
                # Extract the file reference ID
                match = re.search(r'([A-F0-9]{24})\s*/\*.*\*/', line)
                if match:
                    file_refs_to_remove.add(match.group(1))
                    print(f"   Found reference to remove: {filename}")
    
    print()
    print(f"✅ Found {len(file_refs_to_remove)} file references to remove")
    print()
    
    # Second pass: remove lines containing these references or paths
    new_lines = []
    removed_count = 0
    
    for line in lines:
        should_keep = True
        
        # Remove lines with old paths
        for filename in files_to_remove:
            if '/Users/fatimah/Desktop/RaceTrian' in line and filename in line:
                should_keep = False
                removed_count += 1
                break
        
        # Remove lines with identified file reference IDs
        for ref_id in file_refs_to_remove:
            if ref_id in line:
                should_keep = False
                removed_count += 1
                break
        
        if should_keep:
            new_lines.append(line)
    
    # Write the modified file
    with open(pbxproj_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(new_lines) + '\n')
    
    print(f"✅ Removed {removed_count} lines from project.pbxproj")
    print()
    
    # Check for PlannerApp.swift
    print("🔍 Checking for PlannerApp.swift...")
    planner_count = sum(1 for line in new_lines if 'PlannerApp.swift' in line)
    
    if planner_count == 0:
        print("⚠️  Warning: PlannerApp.swift not found in project")
        print("   You'll need to add it manually in Xcode")
    else:
        print(f"✅ PlannerApp.swift is in project ({planner_count} references)")
    
    print()
    
    # Clean derived data
    print("🧹 Cleaning Xcode build artifacts...")
    
    derived_data = Path.home() / "Library/Developer/Xcode/DerivedData"
    project_name = project_dir.stem
    
    if derived_data.exists():
        removed_dd = 0
        for item in derived_data.iterdir():
            if item.is_dir() and item.name.startswith(project_name):
                try:
                    shutil.rmtree(item)
                    removed_dd += 1
                except:
                    pass
        
        if removed_dd > 0:
            print(f"✅ Cleaned {removed_dd} derived data folders")
        else:
            print("✅ No stale derived data found")
    
    # Clean module cache
    module_cache = Path.home() / "Library/Developer/Xcode/DerivedData/ModuleCache.noindex"
    if module_cache.exists():
        try:
            shutil.rmtree(module_cache)
            print("✅ Cleaned module cache")
        except:
            print("⚠️  Could not clean module cache (may be in use)")
    
    print()
    print("=" * 50)
    print("✅ Build fix script complete!")
    print("=" * 50)
    print()
    print("📋 Next steps:")
    print()
    print("1. Open your project in Xcode")
    print("2. Product → Clean Build Folder (⌘⇧K)")
    print("3. Product → Build (⌘B)")
    print()
    print("If you still see '_main' error:")
    print("   • Click PlannerApp.swift in Project Navigator")
    print("   • Open File Inspector (⌥⌘1)")
    print("   • Check ✓ 'RaceTrian' under Target Membership")
    print()
    print(f"💾 Backup saved to: {backup_file.name}")
    print()
    print("Good luck! 🚀")
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
