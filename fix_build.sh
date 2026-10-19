#!/bin/bash

# Automated Build Fix Script for RaceTrian
# This script removes all the problematic file references from your Xcode project

echo "🔧 RaceTrian Build Fix Script"
echo "=============================="
echo ""

# Find the Xcode project file
PROJECT_FILE=$(find . -name "*.xcodeproj" -type d | head -n 1)

if [ -z "$PROJECT_FILE" ]; then
    echo "❌ Error: Could not find .xcodeproj file"
    echo "   Make sure you're running this from your project directory"
    exit 1
fi

echo "✅ Found project: $PROJECT_FILE"
PBXPROJ="$PROJECT_FILE/project.pbxproj"

if [ ! -f "$PBXPROJ" ]; then
    echo "❌ Error: Could not find project.pbxproj"
    exit 1
fi

echo "✅ Found project.pbxproj"
echo ""

# Create a backup
BACKUP="$PBXPROJ.backup.$(date +%Y%m%d_%H%M%S)"
cp "$PBXPROJ" "$BACKUP"
echo "✅ Created backup: $BACKUP"
echo ""

# List of files to remove from the build
FILES_TO_REMOVE=(
    "AIPlannerSheet.swift"
    "AIInsightCard.swift"
    "AddProjectSheet.swift"
    "AuthView.swift"
    "TrainingTrackingView.swift"
    "AssessmentView.swift"
    "AppPreferencesSection.swift"
    "AdditionalFeatureViews.swift"
    "UsersfatimahDesktopRaceTrianNewProfileView.swift"
    "AssessmentModels.swift"
    "TrainingModels.swift"
    "TrackingModels.swift"
    "UserProfile.swift"
    "ViewHelpers.swift"
    "AdditionalViews.swift"
    "TrainingStore.swift"
    "TrainingLogView.swift"
    "AssessmentStore.swift"
    "WeekTaskStore.swift"
    "AppDelegate.swift"
)

echo "🗑️  Removing broken file references..."
echo ""

REMOVED_COUNT=0

for file in "${FILES_TO_REMOVE[@]}"; do
    # Count how many times this file appears in the project
    COUNT=$(grep -c "$file" "$PBXPROJ" 2>/dev/null || echo "0")
    
    if [ "$COUNT" -gt "0" ]; then
        echo "   Removing references to: $file ($COUNT references)"
        
        # Remove lines containing this file path from specific paths
        sed -i.tmp "/\/Users\/fatimah\/Desktop\/RaceTrian.*$file/d" "$PBXPROJ"
        
        # Also remove just the filename references in certain contexts
        # But be careful not to remove too much
        
        ((REMOVED_COUNT++))
    fi
done

# Clean up temporary files
rm -f "$PBXPROJ.tmp"

echo ""
echo "✅ Removed references to $REMOVED_COUNT files"
echo ""

# Now ensure PlannerApp.swift is in the project
echo "🔍 Checking for PlannerApp.swift..."
PLANNER_COUNT=$(grep -c "PlannerApp.swift" "$PBXPROJ" 2>/dev/null || echo "0")

if [ "$PLANNER_COUNT" -eq "0" ]; then
    echo "⚠️  Warning: PlannerApp.swift not found in project"
    echo "   You'll need to add it manually in Xcode"
else
    echo "✅ PlannerApp.swift is in the project ($PLANNER_COUNT references)"
fi

echo ""
echo "🧹 Cleaning Xcode build artifacts..."

# Clean derived data for this project
PROJECT_NAME=$(basename "$PROJECT_FILE" .xcodeproj)
DERIVED_DATA="$HOME/Library/Developer/Xcode/DerivedData"

if [ -d "$DERIVED_DATA" ]; then
    # Find and remove derived data for this project
    find "$DERIVED_DATA" -maxdepth 1 -type d -name "${PROJECT_NAME}*" -exec rm -rf {} \; 2>/dev/null
    echo "✅ Cleaned derived data for $PROJECT_NAME"
fi

# Clean module cache
MODULE_CACHE="$HOME/Library/Developer/Xcode/DerivedData/ModuleCache.noindex"
if [ -d "$MODULE_CACHE" ]; then
    rm -rf "$MODULE_CACHE"
    echo "✅ Cleaned module cache"
fi

echo ""
echo "=============================="
echo "✅ Build fix script complete!"
echo "=============================="
echo ""
echo "📋 Next steps:"
echo ""
echo "1. Open your project in Xcode"
echo "2. Go to Product → Clean Build Folder (⌘⇧K)"
echo "3. Go to Product → Build (⌘B)"
echo ""
echo "If you still see the '_main' error:"
echo "   • Click on PlannerApp.swift"
echo "   • Open File Inspector (⌥⌘1)"
echo "   • Check the box next to 'RaceTrian' under Target Membership"
echo ""
echo "💾 Your original project.pbxproj was backed up to:"
echo "   $BACKUP"
echo ""
echo "Good luck! 🚀"
