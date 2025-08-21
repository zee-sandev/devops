# Quick Start Guide

Get up and running with the DevOps central workflows in 5 minutes!

## 🚀 Quick Setup

### 1. Add CI to Your Repository

Create `.github/workflows/ci.yml` in your repository:

```yaml
name: CI
on: [push, pull_request]

jobs:
  ci:
    uses: your-org/devops/.github/workflows/ci.yml@main
    with:
      node-version: '18'
      pnpm-version: '8'
```

### 2. Add Auto-Tagging (Recommended)

Create `.github/workflows/auto-tag.yml` in your repository:

```yaml
name: Auto Tag
on:
  push:
    branches: [main]

jobs:
  auto-tag:
    uses: your-org/devops/.github/workflows/pr-auto-tag.yml@main
    with:
      target-environment: 'dev'
      bump-type: 'patch'
      create-release: true
```

### 3. Add Deployment (Optional)

Create `.github/workflows/deploy.yml` in your repository:

```yaml
name: Deploy
on:
  push:
    tags:
      - 'dev-v*'
      - 'qa-v*'
      - 'prd-v*'

jobs:
  deploy:
    uses: your-org/devops/.github/workflows/deploy.yml@main
    with:
      tag: ${{ github.ref_name }}
```

### 4. Ensure Your package.json Has Required Scripts

```json
{
  "scripts": {
    "test": "your-test-command",
    "lint": "your-lint-command",
    "build": "your-build-command"
  }
}
```

### 5. Commit and Push

```bash
git add .github/workflows/
git commit -m "Add DevOps central workflows"
git push
```

## ✅ That's It!

Your repository now has:

- ✅ Automated testing on every push/PR
- ✅ Automated linting
- ✅ Automated building
- ✅ Security auditing
- ✅ **Automatic version tagging on main branch**
- ✅ **Deployment on tags**
- ✅ Consistent Node.js and pnpm versions
- ✅ Optimized caching
- ✅ **GitHub releases for tagged versions**

## 🔧 Customization

### Change Node.js Version

```yaml
jobs:
  ci:
    uses: your-org/devops/.github/workflows/ci.yml@main
    with:
      node-version: '20' # Use Node.js 20
      pnpm-version: '9' # Use pnpm 9
```

### Disable Certain Steps

```yaml
jobs:
  ci:
    uses: your-org/devops/.github/workflows/ci.yml@main
    with:
      run-security-audit: false # Skip security audit
      run-build: false # Skip build step
```

## 🆘 Need Help?

- 📖 Read the full [README.md](README.md)
- 🔍 Check the [examples/](examples/) folder
- 🐛 Report issues in this repository
- 💬 Contact the DevOps team

## 🎯 Next Steps

1. **Test the workflows** by creating a pull request
2. **Customize** the configuration for your needs
3. **Add deployment** if you need it
4. **Share** with your team!

---

**Remember**: Replace `your-org/devops` with your actual organization and repository names!
