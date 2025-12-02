#!/bin/bash

# Script to set up the test repository on GitHub
# This automates the steps in SETUP.md

set -e  # Exit on error

echo "🚀 Setting up test repository for changed-files-only feature"
echo ""

# Check if we're in the right directory
if [ ! -f "README.md" ]; then
    echo "❌ Error: Please run this script from the test-run-code-analyzer-changed-files directory"
    exit 1
fi

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
    echo "✅ Git initialized"
else
    echo "✅ Git already initialized"
fi

# Check if remote exists
if git remote | grep -q "origin"; then
    echo "⚠️  Remote 'origin' already exists"
    EXISTING_REMOTE=$(git remote get-url origin)
    echo "   Current origin: $EXISTING_REMOTE"
    read -p "   Do you want to continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
else
    # Get GitHub username
    echo ""
    echo "📝 GitHub Configuration"
    read -p "Enter your GitHub username: " GITHUB_USER
    
    if [ -z "$GITHUB_USER" ]; then
        echo "❌ Error: GitHub username is required"
        exit 1
    fi
    
    REPO_NAME="test-run-code-analyzer-changed-files"
    REMOTE_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"
    
    echo ""
    echo "Will create repository at: $REMOTE_URL"
    echo ""
fi

# Stage all files
echo "📝 Staging files..."
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "✅ No changes to commit (already committed)"
else
    # Create initial commit
    echo "💾 Creating initial commit..."
    git commit -m "Initial commit: Test repository for changed-files-only feature"
    echo "✅ Initial commit created"
fi

echo ""
echo "🌐 Next steps:"
echo ""
echo "Option 1 - Using GitHub CLI (gh):"
echo "   gh repo create $REPO_NAME --public --source=. --remote=origin"
echo "   git push -u origin main"
echo ""
echo "Option 2 - Manually create on GitHub:"
echo "   1. Go to https://github.com/new"
echo "   2. Name: $REPO_NAME"
echo "   3. Choose 'Public'"
echo "   4. Do NOT initialize with README"
echo "   5. Click 'Create repository'"
echo "   6. Then run:"
if [ -z "$GITHUB_USER" ]; then
    echo "      git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
else
    echo "      git remote add origin $REMOTE_URL"
fi
echo "      git branch -M main"
echo "      git push -u origin main"
echo ""

# Check if gh CLI is available
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI (gh) is available"
    echo ""
    read -p "Do you want to create the repository now using GitHub CLI? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 Creating repository on GitHub..."
        
        # Check if already logged in
        if ! gh auth status &> /dev/null; then
            echo "🔐 You need to authenticate with GitHub CLI first"
            echo "   Run: gh auth login"
            exit 1
        fi
        
        # Create repository
        gh repo create $REPO_NAME --public --source=. --remote=origin --description="Test repository for run-code-analyzer changed-files-only feature"
        
        echo "✅ Repository created!"
        echo ""
        echo "📤 Pushing to GitHub..."
        git push -u origin main
        
        echo ""
        echo "✅ Setup complete!"
        echo ""
        echo "🎉 Your test repository is ready at:"
        gh repo view --web
        
        echo ""
        echo "📋 Next steps:"
        echo "   1. Go to Settings → Actions → General"
        echo "   2. Enable 'Read and write permissions'"
        echo "   3. Check 'Allow GitHub Actions to create and approve pull requests'"
        echo "   4. Create a test PR using the instructions in README.md"
    fi
else
    echo "ℹ️  GitHub CLI not found. Install it with:"
    echo "   brew install gh (macOS)"
    echo "   Or visit: https://cli.github.com/"
fi

echo ""
echo "📚 For detailed testing instructions, see:"
echo "   - README.md (overview and test scenarios)"
echo "   - SETUP.md (step-by-step setup guide)"

