#!/bin/bash

# fix_duplicates.sh
# A utility script to help identify and fix duplicate code or files in the RaceTrian project

echo "🔍 Scanning for duplicates in RaceTrian project..."
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Try to find the project directory
# First, check if we're in a Services subdirectory
if [[ "$SCRIPT_DIR" == */Services ]]; then
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
else
    # Otherwise, assume we're in the root project directory
    PROJECT_DIR="$SCRIPT_DIR"
fi

# If the user provided a directory as an argument, use that instead
if [ ! -z "$1" ]; then
    PROJECT_DIR="$1"
fi

# Verify the directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Error: Project directory not found: $PROJECT_DIR${NC}"
    echo "Usage: $0 [project_directory]"
    echo "Example: $0 /Users/fatimah/Desktop/RaceTrian"
    exit 1
fi

echo "Project directory: $PROJECT_DIR"
echo ""

# Function to find duplicate Swift files by name
find_duplicate_filenames() {
    echo -e "${YELLOW}Checking for duplicate filenames...${NC}"
    
    # Find all .swift files and check for duplicates
    find "$PROJECT_DIR" -name "*.swift" -type f | 
    awk -F/ '{print $NF}' | 
    sort | 
    uniq -d | 
    while read -r filename; do
        echo -e "${RED}Found duplicate filename: $filename${NC}"
        find "$PROJECT_DIR" -name "$filename" -type f
        echo ""
    done
}

# Function to find potential duplicate struct/class definitions
find_duplicate_definitions() {
    echo -e "${YELLOW}Checking for duplicate struct/class definitions...${NC}"
    
    # Search for struct and class definitions
    grep -r "^struct \|^class \|^enum \|^protocol " "$PROJECT_DIR" --include="*.swift" 2>/dev/null |
    awk -F: '{print $2}' |
    sed 's/^[[:space:]]*//' |
    awk '{print $2}' |
    sort |
    uniq -d |
    while read -r typename; do
        if [ ! -z "$typename" ]; then
            echo -e "${RED}Potential duplicate type: $typename${NC}"
            grep -rn "^struct $typename\|^class $typename\|^enum $typename\|^protocol $typename" "$PROJECT_DIR" --include="*.swift" 2>/dev/null
            echo ""
        fi
    done
}

# Function to find the legacy AuthField struct
find_authfield_duplicates() {
    echo -e "${YELLOW}Checking for AuthField struct duplicates...${NC}"
    
    grep -rn "struct AuthField" "$PROJECT_DIR" --include="*.swift" 2>/dev/null || echo -e "${GREEN}No AuthField duplicates found${NC}"
    echo ""
}

# Function to check for duplicate imports
find_duplicate_imports() {
    echo -e "${YELLOW}Checking for files with duplicate imports...${NC}"
    
    find "$PROJECT_DIR" -name "*.swift" -type f |
    while read -r file; do
        duplicates=$(grep "^import " "$file" 2>/dev/null | sort | uniq -d)
        if [ ! -z "$duplicates" ]; then
            echo -e "${RED}Duplicate imports in: $file${NC}"
            echo "$duplicates"
            echo ""
        fi
    done
}

# Main execution
echo "================================"
echo "Running duplicate checks..."
echo "================================"
echo ""

find_duplicate_filenames
echo ""

find_duplicate_definitions
echo ""

find_authfield_duplicates
echo ""

find_duplicate_imports
echo ""

echo "================================"
echo -e "${GREEN}✅ Duplicate check complete!${NC}"
echo "================================"
