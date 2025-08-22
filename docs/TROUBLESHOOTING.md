# Troubleshooting Guide

This guide helps resolve common issues when consuming DevOps Central workflows from other repositories.

## 🚨 Common Errors and Solutions

### Error 1: Can't find 'action.yml' in consuming repository

**Error Message:**

```
Error: Can't find 'action.yml', 'action.yaml' or 'Dockerfile' under '/home/runner/work/consuming-repo/consuming-repo/.github/actions/setup'
```

**Root Cause:**

- The consuming repository is trying to find actions locally instead of using the remote references
- Missing `@main` tag in action references
- Incorrect workflow consumption syntax

**Solutions:**

#### ✅ **Correct Workflow Consumption**

```yaml
# .github/workflows/ci.yml in consuming repository
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  ci:
    uses: zee-sandev/devops/.github/workflows/ci-pipeline.yml@main
    with:
      node-version: '18'
      pnpm-version: '8'
      run-tests: true
      run-lint: true
      run-build: true
      run-security-audit: true
```

#### ❌ **Incorrect (Will Cause Errors)**

```yaml
# DON'T DO THIS - Missing @main tag
jobs:
  ci:
    uses: zee-sandev/devops/.github/workflows/ci-pipeline.yml

# DON'T DO THIS - Wrong repository path
jobs:
  ci:
    uses: your-org/devops/.github/workflows/ci-pipeline.yml@main

# DON'T DO THIS - Local action reference
jobs:
  ci:
    uses: ./.github/actions/setup
```

### Error 2: Workflow not found

**Error Message:**

```
Error: Workflow 'ci-pipeline.yml' not found in 'zee-sandev/devops'
```

**Root Cause:**

- Incorrect workflow path
- Workflow doesn't exist in the specified branch/tag
- Repository access issues

**Solutions:**

#### ✅ **Verify Workflow Paths**

All workflows are now in the top level of `.github/workflows/`:

- **CI Pipeline**: `zee-sandev/devops/.github/workflows/ci-pipeline.yml@main`
- **CI Test**: `zee-sandev/devops/.github/workflows/ci-test.yml@main`
- **CI Lint**: `zee-sandev/devops/.github/workflows/ci-lint.yml@main`
- **Deploy**: `zee-sandev/devops/.github/workflows/deploy.yml@main`
- **Version Auto Bump**: `zee-sandev/devops/.github/workflows/version-auto-bump.yml@main`
- **Version Manual Bump**: `zee-sandev/devops/.github/workflows/version-manual-bump.yml@main`
- **PR Comment Bump**: `zee-sandev/devops/.github/workflows/version-pr-comment-bump.yml@main`

#### ✅ **Use Main Coordinator (Recommended)**

```yaml
jobs:
  main:
    uses: zee-sandev/devops/.github/workflows/main.yml@main
    with:
      workflow-type: 'ci' # ci, deploy, tag-auto, tag-manual
      node-version: '18'
      pnpm-version: '8'
      run-tests: true
      run-lint: true
      run-build: true
      run-security-audit: true
```

### Error 3: Permission denied

**Error Message:**

```
Error: Resource not accessible by integration
```

**Root Cause:**

- Repository is private and consuming repository doesn't have access
- GitHub Actions token doesn't have sufficient permissions

**Solutions:**

#### ✅ **Public Repository Access**

Ensure the consuming repository can access `zee-sandev/devops`:

- Repository must be public, OR
- Consuming repository must have access to `zee-sandev/devops`

#### ✅ **Token Permissions**

```yaml
# In consuming repository's workflow
permissions:
  contents: read
  actions: read
  pull-requests: write # If using PR comment workflows
```

### Error 4: Input validation errors

**Error Message:**

```
Error: Invalid workflow file: Input 'node-version' is required but was not provided
```

**Root Cause:**

- Missing required inputs
- Incorrect input types

**Solutions:**

#### ✅ **Provide All Required Inputs**

```yaml
jobs:
  ci:
    uses: zee-sandev/devops/.github/workflows/ci-pipeline.yml@main
    with:
      # Required inputs
      node-version: '18' # string
      pnpm-version: '8' # string
      run-tests: true # boolean
      run-lint: true # boolean
      run-build: true # boolean
      run-security-audit: true # boolean
```

#### ✅ **Check Input Types**

All inputs now have proper type specifications:

- **String inputs**: `node-version`, `pnpm-version`, `environment`, `version`
- **Boolean inputs**: `run-tests`, `run-lint`, `run-build`, `force`, `dry-run`

## 🔧 Best Practices

### 1. **Always Use @main Tag**

```yaml
# ✅ Correct
uses: zee-sandev/devops/.github/workflows/ci-pipeline.yml@main

# ❌ Incorrect
uses: zee-sandev/devops/.github/workflows/ci-pipeline.yml
```

### 2. **Use Main Coordinator for Multiple Workflows**

```yaml
# Instead of calling multiple workflows separately
jobs:
  main:
    uses: zee-sandev/devops/.github/workflows/main.yml@main
    with:
      workflow-type: 'ci'
      # All CI inputs in one place
```

### 3. **Check Repository Access**

- Ensure `zee-sandev/devops` is accessible
- Verify the consuming repository has proper permissions
- Check if the repository is public or if you have access

### 4. **Validate Workflow Syntax**

```bash
# In the consuming repository
# Validate your workflow file
gh workflow view .github/workflows/ci.yml
```

## 📋 Quick Reference

### **Workflow Types Available**

- **`ci`**: Full CI pipeline with tests, lint, build, security audit
- **`deploy`**: Tag-based deployment with environment detection
- **`tag-auto`**: Automatic version bumping and tagging
- **`tag-manual`**: Manual version tagging with production approval

### **Common Inputs**

```yaml
# CI Workflows
node-version: '18' # Node.js version
pnpm-version: '8' # pnpm version
run-tests: true # Run test suite
run-lint: true # Run linting
run-build: true # Run build process
run-security-audit: true # Run security audit

# Deployment Workflows
tag: 'dev-v1.2.3' # Tag to deploy

# Versioning Workflows
environment: 'dev' # Target environment (dev, qa, prd)
version: '1.2.3' # Exact version for manual tagging
bump-type: 'patch' # Version bump type (patch, minor, major)
force: false # Force operations
dry-run: false # Run in dry-run mode
```

## 🆘 Getting Help

If you're still experiencing issues:

1. **Check the error message** - Look for specific error details
2. **Verify workflow path** - Ensure you're using the correct repository and path
3. **Check permissions** - Ensure your repository can access `zee-sandev/devops`
4. **Validate syntax** - Use GitHub's workflow validation tools
5. **Check examples** - Review the examples in the `examples/` directory

### **Useful Resources**

- **Examples**: `examples/` directory with working workflow configurations
- **Documentation**: `docs/` directory with detailed guides
- **Workflow Paths**: `WORKFLOW-PATHS.md` for complete reference
- **Validation**: Run `./scripts/validate-workflows.sh` in the DevOps Central repository

---

**Remember**: Always use `@main` tag and ensure your repository has access to `zee-sandev/devops`!
