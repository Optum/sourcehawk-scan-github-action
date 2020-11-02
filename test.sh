#!/usr/bin/env bash

set -e

# Set up testing environment
ROOT=$(dirname "$(readlink -fm "$0")")
TEST_IMAGE="sourcehawk-scan-github-action:test"
docker build -t "$TEST_IMAGE" .

# Define Tests
TESTS=( "scan-passed" "scan-failed" "scan-error" "scan-custom" "scan-warning" "scan-warning-fail" )

PASSED=()
FAILED=()

echo "Running Tests"
echo "----------------------------------------"

# Execute Tests
for test in "${TESTS[@]}"; do

  echo "[TEST]: ${test}"
  echo "----------------------------------------"

  if ./tests/"${test}".sh "$ROOT" "$TEST_IMAGE"; then
    echo " >> PASSED"
    PASSED+=("${test}")
  else
    echo " >> [ERROR] FAILED"
    FAILED+=("${test}")
  fi
  echo "----------------------------------------"

done

echo "Tests Completed"
echo -n " >> Result: "
[ ${#FAILED[@]} -gt 0 ] && echo "FAILURE " || echo "SUCCESS"
echo " >> Tests: $((${#PASSED[@]}+${#FAILED[@]})), Passed: ${#PASSED[@]}, Failed: ${#FAILED[@]}"
echo "----------------------------------------"
exit ${#FAILED[@]}
