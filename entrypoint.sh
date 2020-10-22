#!/bin/sh -l

# Action Inputs
REPOSITORY_ROOT=${1:-'.'}
CONFIG_FILE=${2:-'sourcehawk.yml'}
OUTPUT_FORMAT=${3:-TEXT}
OUTPUT_FILE=${4:-'sourcehawk-scan-results.txt'}
FAIL_BUILD=${5:-false}

# Run the scan and output the results
sourcehawk scan --verbosity MEDIUM --config-file "$CONFIG_FILE" --output-format "$OUTPUT_FORMAT" "$REPOSITORY_ROOT" > "$OUTPUT_FILE"

# Show the scan results
cat "$OUTPUT_FILE"

# Determine if scan passed
PASSED=false
if [ $? -eq 0 ]; then
  PASSED=true
fi

# Capture exit code
echo "::set-output name=scan-passed::$PASSED"

# Exit cleanly if scan passes
if [ "$PASSED" = "true" ]; then
  exit 0
fi

# Exit in error if configured to fail build
if [ "$FAIL_BUILD" = "true" ]; then
  exit 1
fi