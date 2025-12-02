# Setup Instructions

Follow these steps to push this test repository to GitHub and start testing.

## Step 1: Initialize Git Repository

```bash
cd /Users/namrata.gupta/workspace/test-run-code-analyzer-changed-files

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Test repository for changed-files-only feature"
```

## Step 2: Create GitHub Repository

### Option A: Using GitHub CLI (gh)

```bash
# Create a new public repository
gh repo create test-run-code-analyzer-changed-files --public --source=. --remote=origin

# Push to GitHub
git push -u origin main
```

### Option B: Using GitHub Web Interface

1. Go to https://github.com/new
2. Repository name: `test-run-code-analyzer-changed-files`
3. Description: "Test repository for run-code-analyzer changed-files-only feature"
4. Choose: **Public** (so GitHub Actions work without restrictions)
5. Do NOT initialize with README (we already have files)
6. Click "Create repository"

7. Then push your local repository:
```bash
# Add the remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/test-run-code-analyzer-changed-files.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 3: Enable GitHub Actions

1. Go to your repository on GitHub
2. Click on **"Actions"** tab
3. If prompted, click **"I understand my workflows, go ahead and enable them"**

## Step 4: Configure Repository Permissions

1. Go to **Settings** → **Actions** → **General**
2. Under "Workflow permissions":
   - Select **"Read and write permissions"**
   - Check **"Allow GitHub Actions to create and approve pull requests"**
3. Click **"Save"**

## Step 5: Run Your First Test

### Test Scenario 1: Add a Clean File (Quality Gate Should Pass)

```bash
# Create a new branch
git checkout -b test/clean-code

# Create a new file with no violations
cat > clean-example.js << 'EOF'
// Clean code example with no violations
const greeting = 'Hello, World!';

function greet(name) {
  if (!name) {
    throw new Error('Name is required');
  }
  return `${greeting}, ${name}!`;
}

module.exports = { greet };
EOF

# Commit and push
git add clean-example.js
git commit -m "Add clean example file"
git push origin test/clean-code
```

Now create a Pull Request on GitHub:
1. Go to your repository
2. Click "Compare & pull request"
3. Create the PR
4. Watch the Actions run!

**Expected Result:**
- ✅ All Files: ~15-20 violations (from existing code)
- ✅ Changed Files Only: 0 violations
- ✅ Quality Gate: PASS

### Test Scenario 2: Add a File with Violations (Quality Gate Should Fail)

```bash
# Create another branch
git checkout main
git pull origin main
git checkout -b test/code-with-violations

# Create a file with violations
cat > bad-example.js << 'EOF'
// This file has intentional violations
var x = 1; // ESLint: Use let/const
console.log(x); // ESLint: Unexpected console

if (x == 1) { // ESLint: Use ===
  var y = 2;
}
EOF

# Commit and push
git add bad-example.js
git commit -m "Add file with violations for testing"
git push origin test/code-with-violations
```

Create another Pull Request and observe:

**Expected Result:**
- ❌ All Files: ~20-25 violations (existing + new)
- ❌ Changed Files Only: 3-4 violations (only from bad-example.js)
- ❌ Quality Gate: FAIL

### Test Scenario 3: Modify Existing File

```bash
# Create another branch
git checkout main
git pull origin main
git checkout -b test/modify-existing

# Add more violations to an existing file
echo "var newBadCode = 'oops';" >> existing-code/legacy-file.js

# Commit and push
git add existing-code/legacy-file.js
git commit -m "Modify existing file"
git push origin test/modify-existing
```

Create a PR and observe:

**Expected Result:**
- ❌ Changed Files Only: Shows violations from legacy-file.js (both old and new)
- The PR summary will show which violations are in the changed file

## Step 6: Understanding the Workflows

### Workflow 1: `test-changed-files-only.yml`
Runs on every PR with 4 jobs:
1. **Scan All Files** - Baseline scan
2. **Scan Changed Files Only** - New feature in action
3. **Compare Results** - Side-by-side comparison
4. **Quality Gate Demo** - Shows how to use for CI/CD

### Workflow 2: `quality-gate-example.yml`
Shows a realistic quality gate that:
- Fails on Critical (Sev 1) or High (Sev 2) violations
- OR if total violations > 10
- Only checks changed files

## Step 7: View Results

After creating a PR:

1. **Go to PR "Checks" tab** to see workflow runs
2. **Click on a workflow run** to see detailed logs
3. **Check the "Summary" section** to see:
   - Comparison tables
   - Quality gate status
   - Violation breakdowns
4. **Download artifacts** to see full JSON results

## Troubleshooting

### Workflows don't run
- Ensure Actions are enabled (Settings → Actions → General)
- Check that workflows are in `.github/workflows/` directory
- Verify YAML syntax is correct

### Permission errors
- Go to Settings → Actions → General
- Enable "Read and write permissions"
- Enable "Allow GitHub Actions to create and approve pull requests"

### Changed files not detected
- Ensure `github-token: ${{ github.token }}` is in the action config
- Verify you're running on a pull request event (not push to main)
- Check that files were actually changed in your PR

### No violations found
- Verify the `--workspace` argument points to your code
- Check that Code Analyzer supports your file types
- Try running Salesforce Code Analyzer locally first

## Next Steps

Once you've tested the basic scenarios:

1. **Try Different Quality Gate Rules**
   - Edit `.github/workflows/quality-gate-example.yml`
   - Change the conditions (e.g., allow Sev 3, limit total to 5)
   - See how it affects PR checks

2. **Test with Real Code**
   - Replace the sample files with your actual codebase
   - Create a PR with real changes
   - Observe how the feature works with your code

3. **Integrate into Your Workflow**
   - Copy the working configuration to your real repository
   - Adjust quality gate rules to match your team's standards
   - Enable as a required check for PRs

## Getting Help

If something doesn't work:
1. Check the workflow logs in the Actions tab
2. Verify all prerequisites are met
3. Look at the README.md for more examples
4. Check the [main run-code-analyzer documentation](https://github.com/forcedotcom/run-code-analyzer)

