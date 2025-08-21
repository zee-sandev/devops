# PR Comment Commands Guide

This guide explains how to use PR comment-based commands for version bumping and other DevOps operations.

## 🚀 Overview

The PR Comment Commands feature allows team members to trigger version bumps and deployments directly from pull request comments using simple slash commands. This provides a ChatOps-style interface for managing releases without leaving GitHub.

## 💬 Available Commands

### `/bump` - Version Bumping

Trigger version bumps with intelligent environment and bump type detection.

#### Syntax

```
/bump [environment] [bump-type] [--flags]
```

#### Examples

**Interactive Mode (Recommended for beginners)**

```
/bump
```

- Shows detected environment and bump type
- Provides options to proceed or customize
- Great for learning the system

**Environment-Specific**

```
/bump dev
/bump qa
/bump prd
```

- Uses auto-detected bump type based on branch name
- Environment can be auto-detected from target branch

**Full Specification**

```
/bump dev patch
/bump qa minor
/bump prd major --force
```

- Explicit control over all parameters
- Use `--force` to overwrite existing tags

**Help**

```
/bump help
```

- Shows comprehensive help message
- Lists all available options and examples

## 🎯 Smart Detection

### Environment Detection

The system automatically detects the target environment based on the PR's base branch:

| Base Branch          | Detected Environment | Description          |
| -------------------- | -------------------- | -------------------- |
| `main`, `master`     | `dev`                | Development releases |
| `develop`            | `dev`                | Development releases |
| `release/*`          | `qa`                 | QA/Staging releases  |
| `staging`            | `qa`                 | QA/Staging releases  |
| `production`, `prod` | `prd`                | Production releases  |

### Bump Type Detection

The system detects bump type from the PR's source branch name:

| Branch Pattern          | Detected Bump Type | Description                      |
| ----------------------- | ------------------ | -------------------------------- |
| `hotfix/*`, `fix/*`     | `patch`            | Bug fixes (1.0.0 → 1.0.1)        |
| `feature/*`, `feat/*`   | `minor`            | New features (1.0.0 → 1.1.0)     |
| `breaking/*`, `major/*` | `major`            | Breaking changes (1.0.0 → 2.0.0) |
| _other_                 | `patch`            | Default fallback                 |

## 🔒 Permission System

### Authorization Levels

The workflow supports multiple authorization mechanisms:

1. **Allowed Users**: Specific GitHub usernames
2. **Allowed Teams**: GitHub team memberships
3. **Repository Access**: Users with write access to the repo

### Configuration

Configure permissions when calling the workflow:

```yaml
uses: your-org/devops/.github/workflows/versioning/pr-comment-bump.yml@main
with:
  allowed-users: 'alice,bob,charlie'
  allowed-teams: 'devops-team,release-managers'
  require-approval: true
```

### Permission Hierarchy

1. **Specific Users** (highest priority)
2. **Team Membership** (medium priority)
3. **Repository Write Access** (fallback)

## 📋 Setup Instructions

### 1. Basic Setup

Add this workflow to your repository:

```yaml
# .github/workflows/pr-commands.yml
name: PR Commands
on:
  issue_comment:
    types: [created]

jobs:
  pr-commands:
    if: github.event.issue.pull_request
    uses: your-org/devops/.github/workflows/versioning/pr-comment-bump.yml@main
    secrets: inherit
```

### 2. Advanced Setup

With specific permissions and features:

```yaml
# .github/workflows/pr-commands.yml
name: PR Commands
on:
  issue_comment:
    types: [created]

jobs:
  pr-commands:
    if: github.event.issue.pull_request
    uses: your-org/devops/.github/workflows/versioning/pr-comment-bump.yml@main
    with:
      allowed-teams: 'devops,release-team'
      require-approval: true
      auto-merge-after-bump: false
    secrets: inherit
```

### 3. Environment Setup

Ensure these environments exist in your repository:

- `tag-bump` - For general version bumps
- `production-tag-bump` - For production bumps (with required reviewers)

## 🔄 Workflow Scenarios

### Scenario 1: Feature Development

**PR**: `feature/user-authentication` → `main`

**Comment**: `/bump`

**Result**:

- Detects: `dev` environment, `minor` bump type
- Prompts: Shows detection and asks for confirmation
- Action: User can proceed or customize

### Scenario 2: Hotfix

**PR**: `hotfix/security-patch` → `main`

**Comment**: `/bump dev patch`

**Result**:

- Immediately bumps dev environment with patch version
- Creates tag like `dev-v1.2.4`
- Posts success message with release link

### Scenario 3: Release Branch

**PR**: `release/v2.1.0` → `main`

**Comment**: `/bump qa`

**Result**:

- Uses `qa` environment with auto-detected `patch` type
- Creates tag like `qa-v2.1.1`
- Ready for QA deployment

### Scenario 4: Production Release

**PR**: `main` → `production`

**Comment**: `/bump prd major`

**Result**:

- Requires manual approval (if configured)
- Creates production tag like `prd-v3.0.0`
- Triggers production deployment

## 💡 Best Practices

### 1. Start with Interactive Mode

New users should start with `/bump` to learn the system:

- Shows what the system detected
- Explains the reasoning
- Provides clear next steps

### 2. Use Descriptive Branch Names

Follow branch naming conventions for better auto-detection:

- `feature/add-user-auth` → `minor` bump
- `hotfix/fix-login-bug` → `patch` bump
- `breaking/new-api-version` → `major` bump

### 3. Environment Progression

Follow a logical environment progression:

1. **Development**: `dev` - For initial testing
2. **QA/Staging**: `qa` - For validation
3. **Production**: `prd` - For live release

### 4. Use Team Permissions

Configure team-based permissions rather than individual users:

```yaml
allowed-teams: 'devops-team,release-managers'
```

### 5. Production Safeguards

Always require approval for production:

```yaml
require-approval: true
```

## 🔧 Advanced Features

### Auto-Merge After Bump

Automatically merge PRs after successful version bumps:

```yaml
with:
  auto-merge-after-bump: true
```

**Use cases**:

- Automated release workflows
- Hotfix deployments
- Development environment updates

### Force Tag Creation

Override existing tags when necessary:

```
/bump dev patch --force
```

**Use cases**:

- Correcting mistakes
- Rebuilding failed releases
- Development environment resets

### Custom Branch Detection

The system works with any branch naming scheme:

| Your Branch             | Auto-Detection | Override          |
| ----------------------- | -------------- | ----------------- |
| `bugfix/issue-123`      | `patch`        | `/bump dev minor` |
| `enhancement/ui-update` | `patch`        | `/bump dev minor` |
| `refactor/code-cleanup` | `patch`        | `/bump dev patch` |

## 🚨 Troubleshooting

### Command Not Recognized

**Problem**: Comment doesn't trigger workflow

**Solutions**:

- Ensure comment starts with `/bump`
- Check that comment is on a pull request (not issue)
- Verify workflow is properly installed

### Permission Denied

**Problem**: "Unauthorized Access" message

**Solutions**:

- Check allowed users/teams configuration
- Verify GitHub team membership
- Confirm repository write access

### Version Bump Failed

**Problem**: Workflow fails during version bump

**Solutions**:

- Check if tag already exists (use `--force` if needed)
- Verify repository permissions for GitHub Actions
- Review workflow logs for specific errors

### Environment Detection Issues

**Problem**: Wrong environment detected

**Solutions**:

- Use explicit environment: `/bump qa minor`
- Check branch naming conventions
- Review detection rules in documentation

## 📊 Examples by Team Role

### Developers

**Daily workflow**:

```
# Feature development
/bump

# Quick hotfix
/bump dev patch

# Check available options
/bump help
```

### Release Managers

**Release workflow**:

```
# Prepare QA release
/bump qa minor

# Production release (with approval)
/bump prd major

# Emergency hotfix
/bump prd patch --force
```

### DevOps Engineers

**Infrastructure updates**:

```
# Infrastructure changes
/bump dev minor

# Configuration updates
/bump qa patch

# Production deployment
/bump prd minor
```

## 🔄 Integration with Other Workflows

### Automatic Deployment

Combine with deployment workflows:

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    tags: ['dev-v*', 'qa-v*', 'prd-v*']

jobs:
  deploy:
    uses: your-org/devops/.github/workflows/deployment/deploy.yml@main
    with:
      tag: ${{ github.ref_name }}
```

### Notification Integration

Add notifications to your workflow:

```yaml
- name: Notify Team
  if: needs.perform-bump.result == 'success'
  uses: slack-actions@v1
  with:
    message: 'Version ${{ needs.perform-bump.outputs.new-tag }} released!'
```

## 📈 Metrics and Monitoring

Track version bump activities:

- **Frequency**: How often are versions bumped?
- **Environments**: Which environments are used most?
- **Users**: Who is performing version bumps?
- **Success Rate**: Are bumps generally successful?

## 🆘 Support

For help with PR comment commands:

1. **Comment `/bump help`** in any PR for quick reference
2. **Check this documentation** for comprehensive guides
3. **Review workflow logs** for detailed error information
4. **Contact DevOps team** for configuration assistance

---

**Pro Tip**: Use `/bump` without parameters first to see what the system detects, then use specific commands for precise control!
