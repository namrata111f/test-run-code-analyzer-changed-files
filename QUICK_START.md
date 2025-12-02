# Quick Start Guide

## 🚀 Get Testing in 5 Minutes

### Step 1: Push to GitHub (Choose One)

**Option A - Automated (Recommended):**
```bash
cd /Users/namrata.gupta/workspace/test-run-code-analyzer-changed-files
./setup-github-repo.sh
```

**Option B - Manual:**
```bash
cd /Users/namrata.gupta/workspace/test-run-code-analyzer-changed-files

# Initialize and commit
git init
git add .
git commit -m "Initial commit: Test repository for changed-files-only feature"

# Create repo on GitHub and push
# Replace YOUR_USERNAME with your GitHub username
git remote add origin https://github.com/YOUR_USERNAME/test-run-code-analyzer-changed-files.git
git branch -M main
git push -u origin main
```

### Step 2: Enable Actions & Permissions

1. Go to your repository on GitHub
2. **Settings** → **Actions** → **General**
3. Set **Workflow permissions** to "Read and write permissions"
4. Check "Allow GitHub Actions to create and approve pull requests"
5. Click **Save**

### Step 3: Create Your First Test PR

```bash
# Create a clean file (no violations)
git checkout -b test/clean-code
cat > clean-example.js << 'EOF'
const message = 'Hello, World!';
console.log(message);
EOF

git add clean-example.js
git commit -m "Add clean file for testing"
git push origin test/clean-code
```

Then on GitHub:
1. Click "Compare & pull request"
2. Create the PR
3. Go to "Actions" tab and watch the workflows run!

### What You'll See

**4 Workflow Jobs Will Run:**

1. **📊 Scan All Files** - Shows ~15-20 violations from existing code
2. **🎯 Scan Changed Files Only** - Shows 0 violations (your file is clean!)
3. **📈 Compare Both Modes** - Side-by-side comparison table
4. **✅ Quality Gate Demo** - Passes because no critical violations in changed files

### Expected Output Example

```
╔════════════════════════════════════════════╗
║     COMPARISON RESULTS                     ║
╠════════════════════════════════════════════╣
║ All Files:                                 ║
║   Total Violations: 18                     ║
║   Critical (Sev 1): 0                      ║
║   High (Sev 2): 3                          ║
║                                            ║
║ Changed Files Only:                        ║
║   Total Violations: 0                      ║
║   Critical (Sev 1): 0                      ║
║   High (Sev 2): 0                          ║
║                                            ║
║ Quality Gate: ✅ PASSED                    ║
╚════════════════════════════════════════════╝
```

### Test Scenario 2: PR with Violations

```bash
# Create a file with violations
git checkout main
git pull
git checkout -b test/with-violations

cat > bad-example.js << 'EOF'
var x = 1; // violation
console.log(x); // violation
if (x == 1) { var y = 2; } // violations
EOF

git add bad-example.js
git commit -m "Add file with violations"
git push origin test/with-violations
```

Create PR → You'll see:
- ❌ Changed Files Only: 3-4 violations
- ❌ Quality Gate: **FAILED**

This proves the feature catches new violations!

## 📚 More Information

- **README.md** - Complete overview and test scenarios
- **SETUP.md** - Detailed step-by-step instructions
- **.github/workflows/** - Example workflow configurations

## 🆘 Troubleshooting

**Workflows don't run?**
- Check that Actions are enabled in Settings
- Verify workflow files are in `.github/workflows/`

**Permission errors?**
- Go to Settings → Actions → Enable read/write permissions

**No violations detected?**
- Ensure Code Analyzer can scan JavaScript files
- Check the `--workspace` argument in workflows

## 🎯 What This Proves

✅ The `changed-files-only: true` feature works correctly
✅ Quality gates can focus on new code changes only
✅ Pre-existing violations don't block new PRs
✅ Perfect for legacy codebases!

