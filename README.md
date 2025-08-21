# DevOps Central Repository

A comprehensive, enterprise-ready DevOps platform providing reusable GitHub Actions workflows and composite actions for Node.js and pnpm-based projects. Centrally manage CI/CD pipelines, version control, and deployment automation across multiple repositories with built-in security and approval workflows.

## 🚀 Features

- **🔄 Modular Workflows**: Organized by function (CI, deployment, versioning)
- **🧩 Composite Actions**: Reusable actions eliminate code duplication
- **🛡️ Security First**: Production approval workflows and input validation
- **⚡ Performance Optimized**: Advanced caching and parallel execution
- **📊 Configuration Driven**: Centralized defaults with runtime customization
- **🎯 Enterprise Ready**: Multi-environment support with proper governance

## 📁 Architecture

```
devops/
├── .github/
│   ├── actions/
│   │   ├── setup/                   # Node.js + pnpm setup
│   │   └── shared/                  # Shared composite actions
│   │       ├── validate-inputs/     # Input validation
│   │       ├── git-setup/           # Git configuration
│   │       ├── version-calculator/  # Version calculation
│   │       └── create-tag/          # Tag creation
│   └── workflows/
│       ├── main.yml                 # Main coordinator workflow
│       ├── ci-pipeline.yml          # Full CI pipeline
│       ├── ci-test.yml              # Standalone test workflow
│       ├── ci-lint.yml              # Standalone lint workflow
│       ├── deploy.yml               # Deployment workflow
│       ├── version-pr-auto-tag.yml  # Auto-tag on PR/branch
│       ├── version-manual-bump.yml  # Manual version/tag bump
│       ├── version-pr-comment-bump.yml # PR comment-based version bump
│       └── utilities/               # Utility workflows
├── config/                          # Configuration files
├── docs/                            # Documentation
├── examples/                        # Usage examples
├── scripts/                         # Utility scripts
└── README.md
```

## 🔧 Available Workflows

### 🎯 Main Coordinator (`main.yml`)

The central workflow that coordinates all other workflows based on input type.

```yaml
name: DevOps Pipeline
on: [push, pull_request]

jobs:
  main:
    uses: zee-sandev/devops/.github/workflows/main.yml@main
    with:
      workflow-type: 'ci' # ci, deploy, tag-auto, tag-manual
      environment: 'dev' # dev, qa, prd
      node-version: '18'
      pnpm-version: '8'
```

### 🔄 CI Workflows

#### CI Pipeline (`ci-pipeline.yml`)

Comprehensive CI pipeline with configurable steps.

```yaml
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

#### Individual Components

- **`ci-test.yml`**: Standalone testing workflow
- **`ci-lint.yml`**: Code quality and linting checks

### 🚀 Deployment Workflows

#### Deploy (`deploy.yml`)

Tag-based deployment with automatic environment detection.

```yaml
name: Deploy
on:
  push:
    tags: ['dev-v*', 'qa-v*', 'prd-v*']

jobs:
  deploy:
    uses: zee-sandev/devops/.github/workflows/deploy.yml@main
    with:
      tag: ${{ github.ref_name }}
      node-version: '18'
      pnpm-version: '8'
```

### 🏷️ Versioning Workflows

#### Auto Tag Bump (`version-auto-bump.yml`)

Automatically calculate and create next version tags.

```yaml
jobs:
  auto-tag:
    uses: zee-sandev/devops/.github/workflows/version-auto-bump.yml@main
    with:
      bump-type: 'patch' # patch, minor, major
      environment: 'dev' # dev, qa, prd
      dry-run: false # Set true for testing
```

#### Manual Tag Bump (`version-manual-bump.yml`)

Manual tagging with production approval workflow.

```yaml
jobs:
  manual-tag:
    uses: zee-sandev/devops/.github/workflows/version-manual-bump.yml@main
    with:
      environment: 'prd' # dev, qa, prd
      version: '1.2.3' # Exact version
      create-release: true # Create GitHub release
```

#### PR Auto Tag (`version-pr-auto-tag.yml`)

Automatic tagging when PRs are merged.

```yaml
name: Auto Tag on PR Merge
on:
  push:
    branches: [main]

jobs:
  auto-tag:
    uses: zee-sandev/devops/.github/workflows/version-pr-auto-tag.yml@main
    with:
      target-environment: 'dev'
      bump-type: 'patch'
      create-release: true
```

#### Enhanced Tag Bump (`version-tag-bump.yml`)

Legacy workflow with enhanced features and backward compatibility.

```yaml
jobs:
  tag-bump:
    uses: zee-sandev/devops/.github/workflows/version-tag-bump.yml@main
    with:
      env: 'dev'
      version: '1.0.0' # Ignored if auto-bump is true
      auto-bump: true # Enable automatic versioning
      bump-type: 'patch'
```

#### PR Comment Bump (`version-pr-comment-bump.yml`) 🆕

Interactive version bumping through PR comments with smart detection.

```yaml
# .github/workflows/pr-commands.yml
name: PR Commands
on:
  issue_comment:
    types: [created]

jobs:
  pr-commands:
    if: github.event.issue.pull_request
    uses: zee-sandev/devops/.github/workflows/version-pr-comment-bump.yml@main
    with:
      allowed-teams: 'devops-team,release-managers'
      auto-merge-after-bump: false
    secrets: inherit
```

**ChatOps Commands:**

- `/bump` - Interactive mode with smart detection
- `/bump dev patch` - Explicit environment and bump type
- `/bump qa` - Environment with auto-detected bump type
- `/bump help` - Show available commands

**Smart Detection:**

- Environment from target branch (main→dev, release/\*→qa)
- Bump type from source branch (hotfix/*→patch, feature/*→minor)

## 🧩 Composite Actions

### Setup Action (`setup/`)

Reusable Node.js and pnpm setup with caching.

```yaml
- name: Setup Node.js and pnpm
  uses: zee-sandev/devops/.github/actions/setup@main
  with:
    node-version: '18'
    pnpm-version: '8'
```

### Shared Actions (`shared/`)

#### Input Validation (`validate-inputs/`)

```yaml
- name: Validate inputs
  uses: zee-sandev/devops/.github/actions/shared/validate-inputs@main
  with:
    environment: 'dev'
    version: '1.2.3'
```

#### Git Setup (`git-setup/`)

```yaml
- name: Setup Git
  uses: zee-sandev/devops/.github/actions/shared/git-setup@main
  with:
    fetch-depth: 0
```

#### Version Calculator (`version-calculator/`)

```yaml
- name: Calculate next version
  uses: zee-sandev/devops/.github/actions/shared/version-calculator@main
  with:
    environment: 'dev'
    bump-type: 'patch'
```

#### Create Tag (`create-tag/`)

```yaml
- name: Create tag
  uses: zee-sandev/devops/.github/actions/shared/create-tag@main
  with:
    tag-name: 'dev-v1.2.3'
    force: false
```

## 📋 Quick Start

### 1. Basic CI Setup

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  ci:
    uses: zee-sandev/devops/.github/workflows/ci-pipeline.yml@main
    with:
      node-version: '18'
      pnpm-version: '8'
```

### 2. Auto-Tagging Setup

```yaml
# .github/workflows/auto-tag.yml
name: Auto Tag
on:
  push:
    branches: [main]

jobs:
  auto-tag:
    uses: zee-sandev/devops/.github/workflows/version-pr-auto-tag.yml@main
    with:
      target-environment: 'dev'
      bump-type: 'patch'
```

### 3. Full Pipeline Setup

```yaml
# .github/workflows/pipeline.yml
name: Full Pipeline
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  ci:
    uses: zee-sandev/devops/.github/workflows/ci-pipeline.yml@main
    with:
      node-version: '18'
      pnpm-version: '8'

  auto-tag:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    needs: ci
    uses: zee-sandev/devops/.github/workflows/version-pr-auto-tag.yml@main
    with:
      target-environment: 'dev'
      bump-type: 'patch'
```

## 🛡️ Security Features

- **🔒 Production Approval**: Manual approval required for production deployments
- **✅ Input Validation**: All inputs validated before processing
- **🏷️ Environment Protection**: Different approval levels per environment
- **🔐 Secret Management**: Proper secret scoping and context usage

## ⚙️ Configuration

### Environment Setup

Create these environments in your repository settings:

- `tag-bump` - For general tag operations
- `production-tag-bump` - For production tags (with required reviewers)

### Default Configuration

The repository includes `config/defaults.yml` with sensible defaults that can be overridden per workflow call.

## 📚 Documentation

- **[📖 Quick Start Guide](docs/QUICKSTART.md)** - Get started in 5 minutes
- **[🏷️ Tag Management](docs/TAG-MANAGEMENT.md)** - Comprehensive versioning guide
- **[💬 PR Comment Commands](docs/PR-COMMENT-COMMANDS.md)** - ChatOps-style version bumping
- **[🏗️ Architecture](docs/ARCHITECTURE.md)** - System design and principles
- **[🤝 Contributing](docs/CONTRIBUTING.md)** - Contribution guidelines

## 📊 Examples

Check the [`examples/`](examples/) directory for:

- Complete workflow setups
- Consumer repository examples
- Deployment configurations
- Tag management patterns

## 🔧 Development Tools

### Validation Script

```bash
# Validate all workflows
./scripts/validate-workflows.sh
```

### Testing

```bash
# Test workflows locally (requires act)
act -j workflow-name

# Validate YAML
yamllint .github/workflows/
```

## 🚀 Getting Started

1. **Fork/Clone** this repository to your organization
2. **Update references** in examples to point to your repository
3. **Configure environments** in your consuming repositories
4. **Create workflows** using the provided examples
5. **Validate** using the validation script

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](docs/CONTRIBUTING.md) for details on:

- Development workflow
- Coding standards
- Testing requirements
- Pull request process

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📖 Check the [documentation](docs/)
- 🔍 Browse [examples](examples/)
- 🐛 Report issues in this repository
- 💬 Contact the DevOps team

---

**Note**: Replace `zee-sandev/devops` with your actual organization and repository names in all examples.

## 🎉 What's New in V2

- **🏗️ Modular Architecture**: Workflows organized by function
- **🧩 Shared Actions**: Eliminated code duplication
- **🎯 Main Coordinator**: Single entry point for all workflows
- **💬 ChatOps Commands**: PR comment-based version bumping with smart detection
- **🛡️ Enhanced Security**: Better validation and approval processes
- **📊 Configuration Management**: Centralized defaults
- **🔧 Developer Tools**: Validation scripts and testing utilities
