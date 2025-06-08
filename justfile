# Default recipe - show available commands
default:
    @just --list

# Validate action.yml
validate:
    @./scripts/validate.sh

# Setup test environment
setup-test:
    @./scripts/setup-test.sh

# Run action test
test-action: setup-test
    @./scripts/test-action.sh

# Run all tests
test: validate test-action
    @echo "✅ All tests completed successfully"

# Check if scripts are executable
check-scripts:
    #!/usr/bin/env bash
    for script in scripts/*.sh; do
        if [[ ! -x "$script" ]]; then
            echo "❌ $script is not executable"
            echo "Run: chmod +x scripts/*.sh"
            exit 1
        fi
    done
    echo "✓ All scripts are executable"
