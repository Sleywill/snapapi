# Contributing to SnapAPI SDKs

First off, thank you for considering contributing to SnapAPI! It's people like you that make SnapAPI such a great tool.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct:

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues as you might find that you don't need to create one. When creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** (code snippets, links, etc.)
- **Describe the behavior you observed and what you expected**
- **Include SDK version, language version, and OS**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description of the enhancement**
- **Explain why this would be useful** to most SnapAPI users
- **List any similar features in other projects** if applicable

### Pull Requests

1. **Fork the repo** and create your branch from `main`
2. **If you've added code**, add tests that cover your changes
3. **Ensure the test suite passes**
4. **Make sure your code follows** the existing style
5. **Write a clear commit message**

## Development Setup

### JavaScript/TypeScript SDK

```bash
cd javascript
npm install
npm run build
npm test
```

### Python SDK

```bash
cd python
pip install -e ".[dev]"
pytest
```

### PHP SDK

```bash
cd php
composer install
./vendor/bin/phpunit
```

### Go SDK

```bash
cd go
go mod download
go test ./...
```

### Kotlin SDK

```bash
cd kotlin
./gradlew build
./gradlew test
```

### Swift SDK

```bash
cd swift
swift build
swift test
```

## Style Guides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

### Code Style

Each SDK follows the conventions of its respective language:

- **JavaScript/TypeScript**: ESLint + Prettier
- **Python**: Black + isort + flake8
- **PHP**: PSR-12
- **Go**: gofmt
- **Kotlin**: ktlint
- **Swift**: SwiftLint

### Documentation

- Use clear, concise language
- Include code examples where applicable
- Keep README files up to date
- Document all public APIs

## SDK-Specific Guidelines

### API Consistency

All SDKs should provide a consistent API:

```
client = new SnapAPI(apiKey)
screenshot = client.screenshot(options)
```

### Error Handling

Use consistent error codes across all SDKs:
- `INVALID_URL`
- `INVALID_API_KEY`
- `QUOTA_EXCEEDED`
- `RATE_LIMITED`
- `TIMEOUT`
- `SCREENSHOT_FAILED`

### Testing

- Aim for >80% code coverage
- Include unit tests and integration tests
- Use mocking for API calls in unit tests

## Release Process

1. Update version number in all relevant files
2. Update CHANGELOG.md
3. Create a pull request with the changes
4. After merge, create a GitHub release with release notes
5. Publish to respective package registries

## Questions?

Feel free to open an issue with your question or reach out to us at slwv.dev@gmail.com.

Thank you for contributing!
