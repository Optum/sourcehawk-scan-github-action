#!/usr/bin/env bash

OUTPUT=$(docker run -v "$1:/github/workspace" "$2" "tests/scan-custom" "sh.yml" "JSON" "sourcehawk-scan-results.json")
SCAN_EXIT_CODE=$?

PASSED=()
FAILED=()

TEST_NAME="SCAN_EXIT_CODE"
if [[ $SCAN_EXIT_CODE -eq 0 ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Incorrect, expected 0, got $SCAN_EXIT_CODE"
  FAILED+=("$TEST_NAME")
fi

TEST_NAME="SCAN_RESULT_MESSAGE"
FIRST_LINE=$(echo "$OUTPUT" | head -1 | sed -e 's/[[:space:]]*$//')
EXPECTED='{"passed":true,"errorCount":0,"warningCount":0,"messages":{},"formattedMessages":[],"passedWithNoWarnings":true}'
if [[ "$FIRST_LINE" = "$EXPECTED" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Missing or incorrect, found: [$FIRST_LINE], expected: [$EXPECTED]"
  FAILED+=("$TEST_NAME")
fi

TEST_NAME="RESULT_FILE"
if [[ -f "sourcehawk-scan-results.json" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Missing result file at path: sourcehawk-scan-results.json"
  FAILED+=("$TEST_NAME")
fi

echo " >> Tests: $((${#PASSED[@]}+${#FAILED[@]})), Passed: ${#PASSED[@]}, Failed: ${#FAILED[@]}"
exit ${#FAILED[@]}
