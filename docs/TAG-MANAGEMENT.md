# Tag Management Guide

This guide explains how to use the DevOps central repository's tag management workflows for automated and manual version control across different environments.

## 🏷️ Overview

The DevOps central repository provides three main tag management workflows:

1. **Auto Tag Bump** (`auto-tag-bump.yml`) - Automatic version calculation and tagging
2. **Manual Tag Bump** (`manual-tag-bump.yml`) - Manual version specification with production approval
3. **PR Auto Tag** (`pr-auto-tag.yml`) - Automatic tagging on PR merges
4. **Tag Bump (Legacy)** (`tag-bump.yml`) - Enhanced legacy workflow with new features

## 🎯 Tag Naming Convention

All tags follow the pattern: `{environment}-v{version}`

Examples:

- `dev-v1.0.1` - Development version 1.0.1
- `qa-v1.2.0` - QA/Staging version 1.2.0
- `prd-v2.0.0` - Production version 2.0.0

## 🔄 Workflow Types

### 1. Auto Tag Bump (`auto-tag-bump.yml`)

Automatically calculates the next version based on the latest tag and bump type.

**Use Case:** Continuous integration environments where you want automatic version progression.

```yaml
jobs:
  auto-bump:
    uses: zee-sandev/devops/.github/workflows/auto-tag-bump.yml@main
    with:
      bump-type: 'patch' # patch, minor, or major
      environment: 'dev' # dev, qa, prd
      base-version: '1.0.0' # Starting version if no tags exist
      dry-run: false # Set to true to test without creating tags
```

**Features:**

- ✅ Automatic version calculation
- ✅ Semantic versioning support
- ✅ Dry-run mode for testing
- ✅ Changelog generation
- ✅ Outputs for chaining workflows

### 2. Manual Tag Bump (`manual-tag-bump.yml`)

Allows explicit version specification with production approval workflow.

**Use Case:** When you need precise control over version numbers, especially for production releases.

```yaml
jobs:
  manual-bump:
    uses: zee-sandev/devops/.github/workflows/manual-tag-bump.yml@main
    with:
      environment: 'prd' # dev, qa, prd
      version: '2.1.0' # Exact version to tag
      force: false # Overwrite existing tags
      create-release: true # Create GitHub release
```

**Features:**

- ✅ Exact version specification
- ✅ Production approval workflow
- ✅ Tag existence validation
- ✅ GitHub release creation
- ✅ Comprehensive logging
- ✅ Environment-specific approval gates

### 3. PR Auto Tag (`pr-auto-tag.yml`)

Automatically creates tags when PRs are merged to specific branches.

**Use Case:** Automatic development and QA tagging on code merges.

```yaml
jobs:
  pr-auto-tag:
    uses: zee-sandev/devops/.github/workflows/pr-auto-tag.yml@main
    with:
      target-environment: 'dev' # dev or qa only (not prd for safety)
      bump-type: 'patch' # patch, minor, major
      create-release: true # Create GitHub release
```

**Features:**

- ✅ Automatic on PR merge
- ✅ Safety checks (no production auto-tagging)
- ✅ Release creation
- ✅ Configurable bump types

### 4. Tag Bump Legacy (`tag-bump.yml`)

Enhanced version of the original workflow with backward compatibility.

**Use Case:** Existing workflows that need upgrade without breaking changes.

```yaml
jobs:
  legacy-bump:
    uses: zee-sandev/devops/.github/workflows/tag-bump.yml@main
    with:
      env: 'dev' # Environment
      version: '1.0.0' # Version (ignored if auto-bump is true)
      auto-bump: true # Enable automatic version calculation
      bump-type: 'patch' # Type of bump
      force: false # Force tag creation
```

**Features:**

- ✅ Backward compatibility
- ✅ Auto-bump capability
- ✅ Enhanced validation
- ✅ Production approval
- ✅ Better error handling

## 🚀 Common Usage Patterns

### Pattern 1: Auto Dev Tagging on Main Branch

```yaml
name: Auto Dev Deploy
on:
  push:
    branches: [main]

jobs:
  tag-and-deploy:
    uses: zee-sandev/devops/.github/workflows/pr-auto-tag.yml@main
    with:
      target-environment: 'dev'
      bump-type: 'patch'
      create-release: true
```

### Pattern 2: Manual QA Promotion

```yaml
name: Promote to QA
on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to promote'
        required: true

jobs:
  promote-qa:
    uses: zee-sandev/devops/.github/workflows/manual-tag-bump.yml@main
    with:
      environment: 'qa'
      version: ${{ github.event.inputs.version }}
      create-release: true
```

### Pattern 3: Production Release with Approval

```yaml
name: Production Release
on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Production version'
        required: true

jobs:
  production-release:
    uses: zee-sandev/devops/.github/workflows/manual-tag-bump.yml@main
    with:
      environment: 'prd'
      version: ${{ github.event.inputs.version }}
      create-release: true
    # This will require manual approval in the 'production-tag-bump' environment
```

### Pattern 4: Feature Branch to QA

```yaml
name: Feature to QA
on:
  pull_request:
    types: [closed]
    branches: [develop]

jobs:
  qa-tag:
    if: github.event.pull_request.merged == true
    uses: zee-sandev/devops/.github/workflows/pr-auto-tag.yml@main
    with:
      target-environment: 'qa'
      bump-type: 'minor' # Features typically bump minor version
```

## 🔒 Environment Protection

### Development Environment

- ✅ No approval required
- ✅ Auto-tagging allowed
- ✅ Force tag overwrite allowed

### QA/Staging Environment

- ✅ Optional approval (configurable)
- ✅ Auto-tagging allowed
- ⚠️ Force tag overwrite with caution

### Production Environment

- 🔒 **Manual approval required**
- ❌ No auto-tagging allowed
- 🚨 Force tag overwrite requires explicit confirmation

## ⚙️ Setup Requirements

### 1. GitHub Environments

Create the following environments in your repository settings:

- `tag-bump` - For general tag operations
- `production-tag-bump` - For production tags with required reviewers

### 2. Environment Configuration

**For `production-tag-bump` environment:**

1. Go to Settings → Environments
2. Click "New environment" or select existing
3. Add "Required reviewers" (1-6 people)
4. Optionally set "Wait timer" for additional safety
5. Enable "Prevent self-review" if desired

### 3. Required Permissions

Ensure the GitHub Actions has the following permissions:

- `contents: write` - To create tags
- `actions: write` - To trigger workflows
- `pull-requests: read` - To read PR information

## 📊 Outputs and Integration

All workflows provide outputs that can be used in subsequent jobs:

```yaml
jobs:
  tag:
    uses: zee-sandev/devops/.github/workflows/manual-tag-bump.yml@main
    with:
      environment: 'dev'
      version: '1.0.0'

  deploy:
    needs: tag
    runs-on: ubuntu-latest
    steps:
      - name: Deploy using created tag
        run: |
          echo "Deploying tag: ${{ needs.tag.outputs.tag-created }}"
          # Add your deployment logic here
```

## 🐛 Troubleshooting

### Common Issues

1. **Tag already exists**

   - Use `force: true` to overwrite
   - Check if the version is correct

2. **Production approval not working**

   - Verify `production-tag-bump` environment exists
   - Ensure required reviewers are configured
   - Check user has necessary permissions

3. **Auto-bump not working**

   - Ensure repository has existing tags
   - Check tag naming convention
   - Verify fetch-depth: 0 in checkout

4. **Workflow not triggering**
   - Check trigger conditions
   - Verify workflow file syntax
   - Ensure proper permissions

### Debug Mode

Enable debug logging by setting repository secrets:

```
ACTIONS_STEP_DEBUG=true
ACTIONS_RUNNER_DEBUG=true
```

## 📚 Best Practices

1. **Use semantic versioning** - Always follow MAJOR.MINOR.PATCH format
2. **Test with dry-run** - Use dry-run mode for testing before real execution
3. **Protect production** - Always require manual approval for production tags
4. **Document releases** - Use create-release option for important versions
5. **Monitor workflows** - Set up notifications for failed tag operations
6. **Version planning** - Plan version numbers across environments consistently

## 🔗 Related Workflows

After tagging, you'll typically want to trigger deployment workflows:

```yaml
# Example: Trigger deployment after tagging
on:
  push:
    tags:
      - 'dev-v*'
      - 'qa-v*'
      - 'prd-v*'

jobs:
  deploy:
    uses: zee-sandev/devops/.github/workflows/deploy.yml@main
    with:
      tag: ${{ github.ref_name }}
```

## 📞 Support

For issues or questions about tag management:

1. Check this documentation
2. Review the [examples](examples/tag-workflows.yml)
3. Create an issue in the DevOps repository
4. Contact the DevOps team

---

**Remember**: Replace `zee-sandev/devops` with your actual organization and repository names!
