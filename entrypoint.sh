#!/bin/sh -l

########################################################################################################3
#
# Docker Entrypoint to run github action .  Script arguments are in the order specified in inputs of
# the "action.yml" file
#
# The "sourcehawk" command is available through the "Dockerfile" base image
#
# Outputs
# -------
# "scan-passed": true / false
#
# @author Brian Wyka
#
########################################################################################################3

# Action Inputs
REPOSITORY_ROOT=${1:-'.'}
CONFIG_FILE=${2:-'sourcehawk.yml'}
OUTPUT_FORMAT=${3:-TEXT}
OUTPUT_FILE=${4:-'sourcehawk-scan-results.txt'}
FAIL_ON_WARNINGS=${5:-false}
FAIL_BUILD=${6:-true}
TAGS=$7

# Global variables
PASSED=false

# Build command options
set -- -c "$CONFIG_FILE" -f "$OUTPUT_FORMAT"
[ "$FAIL_ON_WARNINGS" = true ] && set -- "$@" -w
[ -n "$TAGS" ] && set -- "$@" -t "$TAGS"
set -- "$@" "$REPOSITORY_ROOT"

# Run the scan and output the results
sourcehawk scan "$@" > "$OUTPUT_FILE" && PASSED=true

# Show the scan results
cat "$OUTPUT_FILE"

# Output for github actions
echo "::set-output name=scan-passed::$PASSED"

# Exit cleanly if scan passes
[ "$PASSED" = "true" ] && exit 0

# Exit in error if configured to fail build
[ "$FAIL_BUILD" = "true" ] && exit 1