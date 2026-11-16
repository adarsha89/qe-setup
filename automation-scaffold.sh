
#!/bin/bash

set -e

# ==========================================
# Company Automation Framework Scaffolder
# Compatible with Bash 3.2+
# ==========================================

CLI_NAME="Company Automation Framework Scaffolder"
VERSION="1.0.0"

# ==========================================
# GitHub Repository Mapping
# Replace placeholders with actual GitHub URLs
# ==========================================

FRAMEWORK_REPOS=(
    "GITHUB_API_JAVA_URL"
    "GITHUB_API_TYPESCRIPT_URL"
    "GITHUB_API_JAVA_CUCUMBER_URL"
    "GITHUB_API_TYPESCRIPT_CUCUMBER_URL"
    "GITHUB_WEB_API_JAVA_URL"
    "https://github.com/adarsha89/playwright-automation-using-central-framework"
    "GITHUB_WEB_API_JAVA_CUCUMBER_URL"
    "GITHUB_WEB_API_TYPESCRIPT_CUCUMBER_URL"
)

FRAMEWORK_NAMES=(
    "api-Java"
    "api-Typescript"
    "api-Java-Cucumber"
    "api-Typescript-Cucumber"
    "web-api-Java"
    "web-api-Typescript"
    "web-api-Java-Cucumber"
    "web-api-Typescript-Cucumber"
)

# ==========================================
# Display CLI Header
# ==========================================

show_header() {
    echo ""
    echo "=========================================="
    echo " $CLI_NAME"
    echo " Version: $VERSION"
    echo "=========================================="
    echo ""
}

# ==========================================
# Check Dependencies
# ==========================================

check_dependencies() {

    if ! command -v git >/dev/null 2>&1; then
        echo "ERROR: Git is not installed."
        exit 1
    fi

    echo "Git version: $(git --version)"
}

# ==========================================
# Framework Selection
# ==========================================

select_framework() {

    echo ""
    echo "What type of automation framework do you need?"
    echo ""
    echo "  1) API - Java"
    echo "  2) API - TypeScript"
    echo "  3) API - Java - Cucumber"
    echo "  4) API - TypeScript - Cucumber"
    echo "  5) Web + API - Java"
    echo "  6) Web + API - TypeScript"
    echo "  7) Web + API - Java - Cucumber"
    echo "  8) Web + API - TypeScript - Cucumber"
    echo ""

    while true; do

        read -r -p "Select framework [1-8]: " selection

        if [[ "$selection" =~ ^[1-8]$ ]]; then
            break
        fi

        echo "Invalid selection. Please choose between 1 and 8."
    done

    index=$((selection - 1))

    SELECTED_FRAMEWORK="${FRAMEWORK_NAMES[$index]}"
    SELECTED_REPO="${FRAMEWORK_REPOS[$index]}"
}

# ==========================================
# Project Name
# ==========================================

get_project_name() {

    echo ""

    read -r -p "Enter your project name: " PROJECT_NAME

    if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z0-9._-]+$ ]] ||
       [[ "$PROJECT_NAME" == "." ]] ||
       [[ "$PROJECT_NAME" == ".." ]] ||
       [[ -z "$PROJECT_NAME" ]]; then

        echo "ERROR: Invalid project name."
        exit 1
    fi

    if [[ -e "$PROJECT_NAME" ]]; then
        echo "ERROR: Directory '$PROJECT_NAME' already exists."
        exit 1
    fi
}

# ==========================================
# Clone Framework Repository
# ==========================================

clone_framework() {

    echo ""
    echo "Selected Framework : $SELECTED_FRAMEWORK"
    echo "Repository         : $SELECTED_REPO"
    echo "Project Name       : $PROJECT_NAME"
    echo ""

    if [[ "$SELECTED_REPO" != https://* &&
          "$SELECTED_REPO" != git@* ]]; then

        echo "ERROR: GitHub repository URL is not configured."
        echo "Please update the repository mapping in this CLI."
        exit 1
    fi

    read -r -p "Continue with project creation? (y/n): " confirmation

    if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
        echo "Project creation cancelled."
        exit 0
    fi

    echo ""
    echo "Cloning automation framework..."

    if ! git clone "$SELECTED_REPO" "$PROJECT_NAME"; then
        echo "ERROR: Repository cloning failed."
        exit 1
    fi

    # Remove scaffold repository Git history
    rm -rf "$PROJECT_NAME/.git"

    echo ""
    echo "=========================================="
    echo " Project created successfully!"
    echo "=========================================="
    echo ""
    echo "Framework : $SELECTED_FRAMEWORK"
    echo "Location  : $(pwd)/$PROJECT_NAME"
    echo ""
    echo "Next steps:"
    echo "  cd $PROJECT_NAME"
    echo "  git init"
    echo ""
}

# ==========================================
# Main
# ==========================================

main() {

    show_header

    check_dependencies

    select_framework

    get_project_name

    clone_framework
}

main "$@"
