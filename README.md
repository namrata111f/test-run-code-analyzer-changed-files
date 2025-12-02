# Test Repository for Changed Files Only Feature

This repository demonstrates and tests the `changed-files-only` feature of the [run-code-analyzer](https://github.com/forcedotcom/run-code-analyzer) GitHub Action.

## What This Repository Does

This repository intentionally contains code with violations to demonstrate how the `changed-files-only` feature works:

- **Existing files** (`existing-code/`) - Contains code with pre-existing violations
- **New files** - Will be added in PRs to test the feature

## Testing the Feature

### Scenario 1: Create a PR with Clean Code

This shows that the quality gate passes when you only modify/add files with no violations.

1. **Create a new branch:**
   ```bash
   git checkout -b test/clean-code
   ```

2. **Add a new clean file:**
   ```bash
   cat > new-clean-file.js << 'EOF'
   // This file has no violations
   const greeting = 'Hello, World!';
   
   function greet(name) {
     return `${greeting} ${name}`;
   }
   
   module.exports = { greet };
   EOF
   git add new-clean-file.js
   git commit -m "Add clean file with no violations"
   git push origin test/clean-code
   ```

3. **Create a Pull Request**

4. **Observe the results:**
   - All Files scan will show violations from `existing-code/`
   - Changed Files Only scan will show **0 violations**
   - Quality gate will **PASS** ✅

### Scenario 2: Create a PR with Violations in Changed Files

This shows that the quality gate catches violations in files you modify.

1. **Create a new branch:**
   ```bash
   git checkout -b test/code-with-violations
   ```

2. **Add a file with violations:**
   ```bash
   cat > new-file-with-violations.js << 'EOF'
   // This file has intentional violations
   var x = 1; // ESLint: Use let/const instead of var
   console.log(x); // ESLint: Unexpected console statement
   
   if (x == 1) { // ESLint: Use === instead of ==
     var y = 2;
   }
   EOF
   git add new-file-with-violations.js
   git commit -m "Add file with violations"
   git push origin test/code-with-violations
   ```

3. **Create a Pull Request**

4. **Observe the results:**
   - All Files scan will show violations from `existing-code/` + new file
   - Changed Files Only scan will show **only the 3-4 violations from the new file**
   - Quality gate will **FAIL** ❌ (demonstrating it catches new violations)

### Scenario 3: Modify Existing File

This shows the feature works when modifying existing files too.

1. **Create a new branch:**
   ```bash
   git checkout -b test/modify-existing
   ```

2. **Modify an existing file:**
   ```bash
   echo "var newBadCode = 'oops';" >> existing-code/legacy-file.js
   git add existing-code/legacy-file.js
   git commit -m "Add more violations to existing file"
   git push origin test/modify-existing
   ```

3. **Create a Pull Request**

4. **Observe the results:**
   - Changed Files Only scan will show violations from the modified file
   - It will include both old violations in that file AND the new one you added

## Understanding the Workflows

This repository includes two workflows:

### 1. `test-changed-files-only.yml`
Runs on every PR and demonstrates the feature in action with:
- Job 1: Scans all files (baseline)
- Job 2: Scans only changed files
- Job 3: Compares both results side-by-side
- Job 4: Demonstrates quality gate with changed files only

### 2. `quality-gate-example.yml`
Shows a realistic quality gate setup that:
- Fails only on Critical/High violations in changed files
- Allows existing violations to remain (doesn't block PRs for legacy issues)
- Perfect for gradually improving code quality

## Expected Results

| Scenario | All Files Violations | Changed Files Violations | Quality Gate |
|----------|---------------------|--------------------------|--------------|
| Add clean file | 15+ (from existing) | 0 | ✅ PASS |
| Add file with violations | 20+ (existing + new) | 3-4 (new only) | ❌ FAIL |
| Modify existing file | 20+ | 10+ (that file's violations) | ❌ FAIL |
| Don't change any code | 15+ | 0 | ✅ PASS |

## Repository Structure

```
test-run-code-analyzer-changed-files/
├── README.md (this file)
├── existing-code/
│   ├── legacy-file.js (has pre-existing violations)
│   ├── old-component.js (has pre-existing violations)
│   └── utils.js (has pre-existing violations)
├── .github/
│   └── workflows/
│       ├── test-changed-files-only.yml (main test workflow)
│       └── quality-gate-example.yml (realistic example)
└── .gitignore
```

## Setup Instructions

1. **Fork or clone this repository**

2. **Enable GitHub Actions:**
   - Go to "Settings" → "Actions" → "General"
   - Ensure "Allow all actions and reusable workflows" is selected

3. **Grant workflow permissions:**
   - Go to "Settings" → "Actions" → "General" → "Workflow permissions"
   - Select "Read and write permissions"
   - Check "Allow GitHub Actions to create and approve pull requests"

4. **Start testing:**
   - Follow one of the scenarios above
   - Create a PR and watch the Actions run

## Key Takeaways

✅ **With `changed-files-only: true`:**
- Quality gates focus on code you're changing
- Pre-existing violations don't block new PRs
- Gradually improve code quality without "big bang" refactoring
- Perfect for legacy codebases

❌ **With `changed-files-only: false` (default):**
- Quality gates check all code
- Any violation in codebase can block PRs
- Better for greenfield projects or already-clean codebases

## Questions or Issues?

If something doesn't work as expected:
1. Check the workflow logs in the "Actions" tab
2. Verify your PR actually has changed files
3. Ensure the `github-token` has proper permissions
4. Review the [main documentation](https://github.com/forcedotcom/run-code-analyzer)

