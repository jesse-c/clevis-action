#!/usr/bin/env bash
set -euo pipefail

echo "🧪 Verifying test environment..."

# Check if test files exist
if [[ ! -f "tests/test.toml" ]]; then
    echo "❌ tests/test.toml not found"
    exit 1
fi

if [[ ! -f "tests/test_a.txt" ]]; then
    echo "❌ tests/test_a.txt not found"
    exit 1
fi

if [[ ! -f "tests/test_b.txt" ]]; then
    echo "❌ tests/test_b.txt not found"
    exit 1
fi

echo "✓ tests/test.toml exists"
echo "✓ tests/test_a.txt exists"
echo "✓ tests/test_b.txt exists"
echo "✅ Test environment ready"