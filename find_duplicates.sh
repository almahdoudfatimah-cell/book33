#!/bin/bash

echo "========================================"
echo "Searching for ALL PaywallView declarations"
echo "========================================"
echo ""

echo "Files containing 'struct PaywallView':"
grep -r "struct PaywallView" --include="*.swift" . 2>/dev/null | grep -v "Binary file" | grep -v ".build/"

echo ""
echo "========================================"
echo "Searching for ALL FeatureRow declarations"
echo "========================================"
echo ""

echo "Files containing 'struct FeatureRow' or 'struct.*FeatureRow':"
grep -r "struct.*FeatureRow" --include="*.swift" . 2>/dev/null | grep -v "Binary file" | grep -v ".build/"

echo ""
echo "========================================"
echo "Summary"
echo "========================================"
echo ""
echo "Expected results:"
echo "  - Exactly ONE 'struct PaywallView' in PaywallView.swift"
echo "  - 'private struct FeatureRow' in OnboardingSteps.swift"
echo "  - 'private struct PaywallFeatureRow' in PaywallView.swift"
echo ""
echo "If you see MORE than these, those are the duplicates causing errors!"
