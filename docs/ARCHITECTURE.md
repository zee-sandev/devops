# DevOps Central Architecture

This document describes the architecture and design principles of the DevOps Central repository.

## 🏗️ Overall Architecture

```
devops/
├── .github/
│   ├── actions/
│   │   ├── setup/                 # Node.js + pnpm setup
│   │   └── shared/                # Shared composite actions
│   │       ├── validate-inputs/   # Input validation
│   │       ├── git-setup/         # Git configuration
│   │       ├── version-calculator/# Version calculation
│   │       └── create-tag/        # Tag creation
│   └── workflows/
│       ├── main.yml               # Main coordinator workflow
│       ├── ci/                    # CI/CD workflows
│       │   ├── ci.yml
│       │   ├── test.yml
│       │   └── lint-checker.yml
│       ├── deployment/            # Deployment workflows
│       │   └── deploy.yml
│       ├── versioning/            # Version management
│       │   ├── auto-tag-bump.yml
│       │   ├── manual-tag-bump.yml
│       │   ├── pr-auto-tag.yml
│       │   └── tag-bump.yml
│       └── utilities/             # Utility workflows
│           └── setup.yml
├── config/                        # Configuration files
│   └── defaults.yml
├── docs/                          # Documentation
│   ├── ARCHITECTURE.md
│   ├── QUICKSTART.md
│   └── TAG-MANAGEMENT.md
├── examples/                      # Usage examples
│   ├── complete-workflow.yml
│   ├── consumer-workflow.yml
│   ├── deploy-example.yml
│   └── tag-workflows.yml
├── scripts/                       # Utility scripts
│   └── validate-workflows.sh
├── package.json
└── README.md
```

## 🎯 Design Principles

### 1. **Modularity**

- Workflows are organized by function (CI, deployment, versioning)
- Shared logic is extracted into composite actions
- Each workflow has a single responsibility

### 2. **Reusability**

- Composite actions eliminate code duplication
- Workflows can be called from other repositories
- Consistent interface across all workflows

### 3. **Security**

- Production environments require manual approval
- Input validation prevents injection attacks
- Secrets are properly scoped and managed

### 4. **Maintainability**

- Clear directory structure
- Comprehensive documentation
- Validation scripts for quality assurance

### 5. **Flexibility**

- Configurable inputs for different use cases
- Support for multiple environments
- Optional features that can be enabled/disabled

## 🔄 Workflow Types

### CI Workflows (`ci/`)

Handle continuous integration tasks:

- **`ci.yml`**: Main CI pipeline with configurable steps
- **`test.yml`**: Standalone testing workflow
- **`lint-checker.yml`**: Code quality checks

### Deployment Workflows (`deployment/`)

Handle application deployment:

- **`deploy.yml`**: Tag-based deployment with environment detection

### Versioning Workflows (`versioning/`)

Handle version management and tagging:

- **`auto-tag-bump.yml`**: Automatic version calculation
- **`manual-tag-bump.yml`**: Manual tagging with approval
- **`pr-auto-tag.yml`**: Auto-tagging on PR merges
- **`tag-bump.yml`**: Enhanced legacy workflow

### Utility Workflows (`utilities/`)

Handle setup and maintenance tasks:

- **`setup.yml`**: Legacy Node.js and pnpm setup

## 🧩 Composite Actions

### Setup Action (`setup/`)

Provides Node.js and pnpm setup with caching.

**Features:**

- Node.js installation and configuration
- pnpm installation and store caching
- Dependency installation with CI optimizations

### Shared Actions (`shared/`)

#### `validate-inputs/`

Validates common workflow inputs:

- Environment names (dev, qa, prd)
- Semantic version format
- Node.js and pnpm version validity

#### `git-setup/`

Configures Git for automated operations:

- Repository checkout with configurable depth
- Git user configuration for bot commits
- Consistent Git setup across workflows

#### `version-calculator/`

Calculates next version based on current tags:

- Semantic versioning support
- Environment-specific tag parsing
- Configurable bump types (patch, minor, major)

#### `create-tag/`

Creates and pushes Git tags:

- Tag existence validation
- Force overwrite capability
- Dry-run mode for testing

## 🔀 Data Flow

### 1. Input Validation Flow

```
User Input → validate-inputs → Workflow Logic
```

### 2. CI Flow

```
Code Push → CI Workflow → Setup Action → Tests/Lint/Build → Results
```

### 3. Versioning Flow

```
Trigger → Input Validation → Version Calculation → Tag Creation → Deployment
```

### 4. Deployment Flow

```
Tag Push → Deploy Workflow → Setup Action → Environment Detection → Deployment
```

## 🛡️ Security Architecture

### Environment Protection

- **Development**: No restrictions, auto-deployment allowed
- **Staging**: Optional approval, controlled access
- **Production**: Mandatory approval, restricted access

### Secret Management

- Secrets scoped to appropriate environments
- No hardcoded credentials in workflows
- Proper secret context usage

### Input Validation

- All inputs validated before processing
- Semantic version format enforcement
- Environment name restrictions

## 📊 Configuration Management

### Default Configuration (`config/defaults.yml`)

Centralized configuration for:

- Supported Node.js and pnpm versions
- Environment settings and approval requirements
- Workflow defaults and timeouts
- Security policies

### Runtime Configuration

- Inputs override defaults
- Environment-specific behavior
- Feature toggles for optional functionality

## 🔧 Extensibility

### Adding New Workflows

1. Create workflow file in appropriate category directory
2. Use existing composite actions where possible
3. Follow naming conventions and documentation standards
4. Add validation to `validate-workflows.sh`

### Adding New Actions

1. Create action in `.github/actions/shared/`
2. Define clear inputs and outputs
3. Include comprehensive error handling
4. Document usage in main README

### Adding New Environments

1. Update `config/defaults.yml`
2. Add environment validation in `validate-inputs`
3. Update documentation and examples

## 🚀 Performance Considerations

### Caching Strategy

- Node modules cached between runs
- pnpm store cached globally
- Git history optimized with shallow clones

### Parallel Execution

- Independent jobs run in parallel
- Minimal job dependencies
- Fast feedback on failures

### Resource Optimization

- Appropriate timeouts for each workflow type
- Minimal resource requirements
- Efficient Docker image usage

## 📈 Monitoring and Observability

### Workflow Monitoring

- Comprehensive logging in all steps
- Clear success/failure indicators
- Detailed error messages

### Metrics Collection

- Workflow execution times
- Success/failure rates
- Environment-specific metrics

### Alerting

- Failed deployment notifications
- Security audit failures
- Approval request notifications

## 🔄 Future Enhancements

### Planned Features

- Integration with external monitoring tools
- Advanced security scanning
- Multi-cloud deployment support
- Enhanced notification systems

### Scalability Improvements

- Workflow caching optimization
- Distributed execution support
- Advanced dependency management

---

This architecture provides a solid foundation for scalable, maintainable, and secure DevOps workflows while maintaining flexibility for future enhancements.
