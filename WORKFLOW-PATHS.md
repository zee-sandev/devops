# Workflow Path Reference

This document provides a quick reference for all workflow paths in the DevOps Central repository.

## 🔄 Current Workflow Paths (V2.1)

### CI/CD Workflows

- **`ci-pipeline.yml`** - Comprehensive CI pipeline
- **`ci-test.yml`** - Standalone testing
- **`ci-lint.yml`** - Code quality and linting

### Deployment Workflows

- **`deploy.yml`** - Tag-based deployment

### Version Management Workflows

- **`version-auto-bump.yml`** - Automatic version calculation and tagging
- **`version-manual-bump.yml`** - Manual tagging with approval workflow
- **`version-pr-auto-tag.yml`** - Auto-tagging on PR merges
- **`version-pr-comment-bump.yml`** - ChatOps PR comment bumping
- **`version-tag-bump.yml`** - Enhanced legacy workflow

### Utility Workflows

- **`main.yml`** - Main coordinator workflow
- **`setup.yml`** - Legacy Node.js and pnpm setup

## 📝 Usage Examples

### Individual Workflows

```yaml
# CI Pipeline
uses: your-org/devops/.github/workflows/ci-pipeline.yml@main

# Manual Version Bump
uses: your-org/devops/.github/workflows/version-manual-bump.yml@main

# Deployment
uses: your-org/devops/.github/workflows/deploy.yml@main

# PR Comment Bumping
uses: your-org/devops/.github/workflows/version-pr-comment-bump.yml@main
```

### Main Coordinator (Recommended)

```yaml
# Single entry point for all workflows
uses: your-org/devops/.github/workflows/main.yml@main
with:
  workflow-type: 'ci' # ci, deploy, tag-auto, tag-manual
```

## 🔄 Migration from Subdirectories

If you were using the previous subdirectory structure, update your workflow references:

### Old Paths (V2.0) → New Paths (V2.1)

```yaml
# CI Workflows
ci/ci.yml → ci-pipeline.yml
ci/test.yml → ci-test.yml
ci/lint-checker.yml → ci-lint.yml

# Deployment Workflows
deployment/deploy.yml → deploy.yml

# Versioning Workflows
versioning/auto-tag-bump.yml → version-auto-bump.yml
versioning/manual-tag-bump.yml → version-manual-bump.yml
versioning/pr-auto-tag.yml → version-pr-auto-tag.yml
versioning/pr-comment-bump.yml → version-pr-comment-bump.yml
versioning/tag-bump.yml → version-tag-bump.yml

# Utility Workflows
utilities/setup.yml → setup.yml
```

## ⚠️ Important Notes

1. **GitHub Actions Requirement**: Reusable workflows MUST be in the top level of `.github/workflows/` directory
2. **Backward Compatibility**: Update all references in consuming repositories
3. **Main Coordinator**: Consider using `main.yml` for new implementations
4. **Naming Convention**: Workflows now use descriptive prefixes (`ci-`, `version-`, etc.)

## 🔧 Composite Actions (Unchanged)

Composite action paths remain the same:

```yaml
# Setup Action
uses: your-org/devops/.github/actions/setup@main

# Shared Actions
uses: your-org/devops/.github/actions/shared/validate-inputs@main@main
uses: your-org/devops/.github/actions/shared/git-setup@main@main
uses: your-org/devops/.github/actions/shared/version-calculator@main@main
uses: your-org/devops/.github/actions/shared/create-tag@main@main
```

---

**Note**: Always replace `your-org/devops` with your actual organization and repository names.
