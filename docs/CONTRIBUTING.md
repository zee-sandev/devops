# Contributing to DevOps Central

Thank you for your interest in contributing to DevOps Central! This guide will help you get started with contributing to this repository.

## 🚀 Getting Started

### Prerequisites

- Git
- Node.js 18+ (for testing workflows locally)
- pnpm 8+ (for dependency management)
- Basic understanding of GitHub Actions

### Repository Setup

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your changes
4. Make your changes
5. Test your changes
6. Submit a pull request

## 📁 Project Structure

```
devops/
├── .github/
│   ├── actions/          # Reusable composite actions
│   └── workflows/        # Organized workflow categories
├── config/               # Configuration files
├── docs/                 # Documentation
├── examples/             # Usage examples
├── scripts/              # Utility scripts
└── README.md
```

## 🎯 Contribution Guidelines

### Code Standards

#### Workflow Files

- Use clear, descriptive names for workflows and jobs
- Include comprehensive input validation
- Add helpful descriptions for all inputs
- Use semantic versioning for tags
- Follow the established directory structure

#### Composite Actions

- Create focused, single-purpose actions
- Include comprehensive input/output documentation
- Use consistent naming conventions
- Add proper error handling

#### Documentation

- Keep README.md up to date
- Add examples for new features
- Include architecture documentation for major changes
- Use clear, concise language

### Naming Conventions

#### Files and Directories

- Use kebab-case for file names (`auto-tag-bump.yml`)
- Use descriptive directory names (`versioning/`, `deployment/`)
- Follow GitHub Actions conventions

#### Workflows and Jobs

- Use Title Case for workflow names (`Auto Tag Bump`)
- Use kebab-case for job names (`auto-bump`, `validate-inputs`)
- Use descriptive step names

#### Inputs and Outputs

- Use kebab-case for input/output names
- Include clear descriptions
- Specify reasonable defaults

### Security Guidelines

#### Secrets and Sensitive Data

- Never hardcode secrets or sensitive information
- Use GitHub Secrets or environment variables
- Scope secrets appropriately
- Validate all inputs to prevent injection attacks

#### Permissions

- Use minimal required permissions
- Document permission requirements
- Follow principle of least privilege

### Testing Guidelines

#### Validation

- Run `scripts/validate-workflows.sh` before submitting
- Test workflows in a fork before submitting PR
- Validate YAML syntax
- Check for common security issues

#### Examples

- Provide working examples for new features
- Test examples in real repositories
- Include both simple and complex use cases

## 🔄 Development Workflow

### 1. Planning

- Check existing issues for related work
- Create an issue for significant changes
- Discuss architecture changes with maintainers

### 2. Development

- Create a feature branch from `main`
- Make atomic commits with clear messages
- Follow the coding standards
- Add tests and documentation

### 3. Testing

- Validate workflows using the validation script
- Test in a real repository environment
- Ensure backward compatibility
- Check for performance impact

### 4. Documentation

- Update relevant documentation
- Add examples if applicable
- Update CHANGELOG.md
- Include screenshots if helpful

### 5. Submission

- Create a pull request with clear description
- Reference related issues
- Include testing evidence
- Respond to review feedback

## 📝 Pull Request Process

### PR Requirements

- [ ] Clear title and description
- [ ] Related issue referenced (if applicable)
- [ ] Tests pass
- [ ] Documentation updated
- [ ] Examples provided (if applicable)
- [ ] No breaking changes (unless discussed)

### PR Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing

- [ ] Validated with validation script
- [ ] Tested in real repository
- [ ] Examples work as expected

## Checklist

- [ ] Code follows project standards
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No hardcoded secrets
```

## 🐛 Bug Reports

### Bug Report Template

```markdown
## Bug Description

Clear description of the bug

## Steps to Reproduce

1. Step one
2. Step two
3. etc.

## Expected Behavior

What should happen

## Actual Behavior

What actually happens

## Environment

- Repository: [link]
- Workflow: [name]
- Runner: [ubuntu-latest, etc.]

## Additional Context

Any other relevant information
```

## 💡 Feature Requests

### Feature Request Template

```markdown
## Feature Description

Clear description of the feature

## Use Case

Why is this feature needed?

## Proposed Solution

How should this feature work?

## Alternatives Considered

Other approaches considered

## Additional Context

Any other relevant information
```

## 🏷️ Release Process

### Versioning

- Follow semantic versioning (MAJOR.MINOR.PATCH)
- Tag releases appropriately
- Update CHANGELOG.md
- Create GitHub releases with notes

### Release Types

- **Patch**: Bug fixes, documentation updates
- **Minor**: New features, non-breaking changes
- **Major**: Breaking changes, major architecture updates

## 🤝 Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Follow GitHub's Community Guidelines

### Communication

- Use GitHub Issues for bug reports and feature requests
- Use GitHub Discussions for questions and general discussion
- Be patient with response times
- Provide clear, detailed information

## 🛠️ Development Tools

### Recommended Tools

- **VS Code** with GitHub Actions extension
- **act** for local workflow testing
- **yamllint** for YAML validation
- **shellcheck** for shell script validation

### Useful Commands

```bash
# Validate all workflows
./scripts/validate-workflows.sh

# Test a workflow locally (requires act)
act -j workflow-name

# Lint YAML files
yamllint .github/workflows/

# Check shell scripts
shellcheck scripts/*.sh
```

## 📚 Learning Resources

### GitHub Actions

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Action Creation](https://docs.github.com/en/actions/creating-actions)

### Best Practices

- [Security Hardening](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [Workflow Best Practices](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#about-yaml-syntax-for-workflows)

## 🆘 Getting Help

### Support Channels

1. **GitHub Issues**: For bugs and feature requests
2. **GitHub Discussions**: For questions and general help
3. **Documentation**: Check existing docs first
4. **Examples**: Look at usage examples

### Common Issues

- **Workflow not triggering**: Check trigger conditions
- **Permission denied**: Check repository permissions
- **Validation errors**: Run validation script
- **Syntax errors**: Check YAML syntax

## 🎉 Recognition

Contributors will be recognized in:

- README.md contributors section
- Release notes for significant contributions
- GitHub repository insights

Thank you for contributing to DevOps Central! 🚀
