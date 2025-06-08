#!/usr/bin/env bash
set -euo pipefail

echo "🧪 Testing action locally..."

# Check if we're in a GitHub Actions environment
if [ "${GITHUB_ACTIONS:-false}" = "true" ]; then
    echo "ℹ️  Running in GitHub Actions - using action directly"
    exit 0
fi

# For local testing, we need to install clevis first
echo "📦 Installing clevis for local testing..."

# Clean up any existing corrupted file
rm -f /tmp/clevis

echo "Installing clevis..."

# Determine architecture and OS
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Map architecture names
case $ARCH in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    *) echo "❌ Unsupported architecture: $ARCH" && exit 1 ;;
esac

# Map OS names - based on actual release assets
case $OS in
    linux) OS="linux" ;;
    darwin) OS="darwin" ;;
    *) echo "❌ Unsupported OS: $OS" && exit 1 ;;
esac

# Get version to download (use latest if not specified)
if [ -n "${CLEVIS_VERSION:-}" ]; then
    VERSION="$CLEVIS_VERSION"
    echo "Using specified Clevis version: $VERSION"
else
    VERSION=$(curl -s https://api.github.com/repos/jesse-c/clevis/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    if [ -z "$VERSION" ]; then
        echo "❌ Failed to get latest version from GitHub releases"
        exit 1
    fi
    echo "Using latest Clevis version: $VERSION"
fi

# Download pre-built binary
BINARY_NAME="clevis-${OS}-${ARCH}"
DOWNLOAD_URL="https://github.com/jesse-c/clevis/releases/download/${VERSION}/${BINARY_NAME}"

echo "Downloading clevis ${VERSION} for ${ARCH}-${OS}..."
echo "URL: ${DOWNLOAD_URL}"

if curl -L -f -o /tmp/clevis "${DOWNLOAD_URL}"; then
    echo "✓ Downloaded successfully"
else
    echo "❌ Failed to download binary from ${DOWNLOAD_URL}"
    echo "Available assets for ${LATEST_VERSION}:"
    curl -s "https://api.github.com/repos/jesse-c/clevis/releases/latest" | grep '"name"' | grep -v tag_name
    exit 1
fi

chmod +x /tmp/clevis
echo "✓ Downloaded clevis to /tmp/clevis"

# Set path to use temporary clevis
CLEVIS_CMD="/tmp/clevis"

# Verify installation
$CLEVIS_CMD --version

echo "🏃 Running clevis check with test configuration..."

# Run the actual test
if $CLEVIS_CMD --path './tests/test.toml' --verbose check; then
    echo "✅ Test passed - values match as expected"
else
    echo "❌ Test failed - clevis check returned non-zero exit code"
    exit 1
fi

echo "✅ Local action test complete"