#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Validating action.yml..."

# Basic YAML validation
if command -v python3 &> /dev/null; then
    if python3 -c "import yaml" 2>/dev/null; then
        python3 -c "import yaml; yaml.safe_load(open('action.yml'))"
        echo "✓ action.yml is valid YAML"
    else
        echo "⚠️  PyYAML not installed, skipping YAML syntax validation"
    fi
else
    echo "⚠️  Python3 not found, skipping YAML syntax validation"
fi

# Check required fields
if ! grep -q "name:" action.yml; then
    echo "❌ Missing 'name' field in action.yml"
    exit 1
fi

if ! grep -q "description:" action.yml; then
    echo "❌ Missing 'description' field in action.yml"
    exit 1
fi

if ! grep -q "runs:" action.yml; then
    echo "❌ Missing 'runs' field in action.yml"
    exit 1
fi

echo "✓ action.yml has required fields"
echo "✅ Validation complete"