# Sourcehawk Scan Github Action

![Latest Version](https://img.shields.io/github/v/tag/optum/sourcehawk-scan-github-action?label=version&sort=semver) 
[![Build Status](https://github.com/optum/sourcehawk-scan-github-action/workflows/CI/badge.svg)](https://github.com/optum/sourcehawk-scan-github-action/actions) 
[![Sourcehawk Scan](https://github.com/optum/sourcehawk-scan-github-action/workflows/Sourcehawk%20Scan/badge.svg)](https://github.com/optum/sourcehawk-scan-github-action/actions)


This action runs a `sourcehawk` scan on the repository source code.

## Inputs

### `repository-root`

The root of the source code to scan

**Default**: `.` (root of the repository)

### `config-file`

The configuration file path (relative path, absolute path, or even URL)

**Default**: `sourcehawk.yml`

### `output-format`

The output format of the scan

**Default**: `TEXT`

**Valid Values**: `TEXT`, `JSON`, `MARKDOWN`

### `output-file`

The configuration file path

**Default**: `sourcehawk-scan-results.txt`

### `fail-on-warnings`

Whether or not to fail the scan if only warnings exist

**Default**: `false`

### `fail-build`

Whether or not to fail the build if the scan fails

**Default**: `true`

## Outputs

### `scan-passed`

Boolean value determining if the scan has passed - `true` if the passed, `false` otherwise

## Example usage

### Basic
The below example accepts all the defaults

```yaml
uses: optum/sourcehawk-scan-github-action@v1
```

### Fail if Warnings Found
Scan will be considered a failure, if warnings are found

```yaml
uses: optum/sourcehawk-scan-github-action@v1
  with:
    fail-on-warnings: true
```

### Custom Configuration File
Provide the location to a configuration file in a custom path

```yaml
uses: optum/sourcehawk-scan-github-action@v1
  with:
    config-file: .sourcehawk/config.yml
```

### JSON Output Format
Output the scan results in `JSON` format

```yaml
uses: optum/sourcehawk-scan-github-action@v1
  with:
    output-format: JSON
    output-file: sourcehawk-scan-results.json
```

## Example Workflow
Below is an example workflow to run a scan on pull requests.  The workflow checks out the source code, runs the scan, 
prints that the scan passed if it was successful, and then archives the scan results file.

```yaml
name: Build
on:
  pull_request:
    branches:
      - main
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Run Sourcehawk Scan
        id: sourcehawk
        uses: optum/sourcehawk-scan-github-action@v1
        with:
          output-format: JSON
          output-file: sourcehawk-scan-results.json
      - name: Determine Sourcehawk Scan Results
        if: steps.sourcehawk.outputs.scan-passed == 'true'
        run: echo "Sourcehawk scan passed!"
      - name: Upload Scan Results
        uses: actions/upload-artifact@v2
        with:
          name: sourcehawk
          path: sourcehawk-scan-results.json
```

## License

The `Dockerfile`, shell scripts, and documentation in the github action are released with the 
[Apache 2.0](https://github.com/Optum/sourcehawk-scan-github-action/blob/main/LICENSE) license.

## Contributing

Please read our [CONTRIBUTING.md](https://github.com/Optum/sourcehawk-scan-github-action/blob/main/CONTRIBUTING.md) for guidelines on contributing to this github action.

### Testing Locally

```sh
./test.sh
```
