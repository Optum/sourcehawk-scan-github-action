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

echo " "
echo -e "\e[1mRunning Github Action Tests\e[0m"
echo "----------------------------------------"

# Execute Tests
for test in "${TESTS[@]}"; do

  echo -e "\e[36m${test}\e[0m"
  echo "----------------------------------------"

  if ./tests/"${test}".sh "$ROOT" "$TEST_IMAGE"; then
    echo -e " >> \e[92mPASSED\e[0m"
    PASSED+=("${test}")
  else
    echo -e " >> \e[31mFAILED\e[0m"
    FAILED+=("${test}")
  fi
  echo "----------------------------------------"

done

echo -e "\e[1mTests Completed\e[0m"
echo -n " >> Result: "
[ ${#FAILED[@]} -gt 0 ] && echo -e "\e[31mFAILURE\e[0m " || echo -e "\e[92mSUCCESS\e[0m"
echo " >> Tests: $((${#PASSED[@]}+${#FAILED[@]})), Passed: ${#PASSED[@]}, Failed: ${#FAILED[@]}"
echo "----------------------------------------"
exit ${#FAILED[@]}
