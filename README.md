# Clevis GitHub Action

A GitHub Action for [Clevis](https://github.com/jesse-c/clevis) - "The big linker" that checks if values match between different parts of your codebase.

## What is Clevis?

Clevis is a tool that helps maintain consistency across your codebase by checking that values in different files match. It supports reading from TOML files, YAML files, and specific text spans, making it perfect for ensuring configuration values, version numbers, or other important data stays synchronized.

## Usage

### Basic Example

```yaml
name: Check Links
on: [push, pull_request]

jobs:
  check-links:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: jesse-c/clevis-action@v1
        with:
          config-path: './clevis.toml'
```

### Check a specific link

```yaml
- uses: jesse-c/clevis-action@v1
  with:
    config-path: './clevis.toml'
    command: 'check'
    link-key: 'version-sync'
```

### List all available links

```yaml
- uses: jesse-c/clevis-action@v1
  with:
    config-path: './clevis.toml'
    command: 'list'
    verbose: 'true'
```

### Show values for a specific link

```yaml
- uses: jesse-c/clevis-action@v1
  with:
    config-path: './clevis.toml'
    command: 'show'
    link-key: 'my-link'
    verbose: 'true'
```

### Complete workflow example

```yaml
name: Clevis Link Check
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  check-consistency:
    runs-on: ubuntu-latest
    name: Check codebase consistency
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Check all links
        uses: jesse-c/clevis-action@v1
        id: clevis-check
        with:
          config-path: './clevis.toml'
          verbose: 'true'
      
      - name: Show results
        run: |
          echo "Check result: ${{ steps.clevis-check.outputs.result }}"
          echo "Output:"
          echo "${{ steps.clevis-check.outputs.output }}"
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `config-path` | Path to the Clevis configuration file | No | `./clevis.toml` |
| `link-key` | Specific link key to check (if omitted, checks all links) | No | |
| `command` | Command to run: `check`, `list`, or `show` | No | `check` |
| `verbose` | Enable verbose output | No | `false` |

## Outputs

| Output | Description |
|--------|-------------|
| `result` | Result of the check operation (`true`/`false` for check command) |
| `output` | Full output from the clevis command |

## Configuration File

Create a `clevis.toml` file in your repository to define the links you want to check. Here's an example:

```toml
# Check that package.json version matches Cargo.toml version
[links.version-sync.a]
kind = "toml"
file_path = "Cargo.toml"
key_path = "package.version"

[links.version-sync.b]
kind = "span"
file_path = "package.json"
[links.version-sync.b.start]
line = 3
column = 15
[links.version-sync.b.end]
line = 3
column = 21

# Check that README example matches actual config
[links.readme-example.a]
kind = "toml"
file_path = "config/app.toml"
key_path = "database.host"

[links.readme-example.b]
kind = "span"
file_path = "README.md"
[links.readme-example.b.start]
line = 42
column = 20
[links.readme-example.b.end]
line = 42
column = 35
```

## Supported File Types

- **TOML files**: Read values using key paths (e.g., `package.version`)
- **YAML files**: Read values using key paths (e.g., `metadata.name`)
- **Text spans**: Read specific character ranges from any text file

## Error Handling

The Action will fail if:
- The configuration file is not found or invalid
- Any checked links have mismatched values
- Required inputs are missing (e.g., `link-key` for `show` command)

## Releases

Run manually the `CD` flow. Optionally specify a version.
