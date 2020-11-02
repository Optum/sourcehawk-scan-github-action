#!/usr/bin/env bash

# FIXME: test is failing

OUTPUT=$(docker run -v "$1:/github/workspace" "$2" "tests/scan-warning")
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
EXPECTED="Scan passed without any errors"
if [[ "$FIRST_LINE" = "$EXPECTED" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Missing or incorrect, found: [$FIRST_LINE], expected: [$EXPECTED]"
  FAILED+=("$TEST_NAME")
fi

TEST_NAME="GITHUB_ACTION_OUTPUT"
LAST_LINE=$(echo "$OUTPUT" | tail -1 | sed -e 's/[[:space:]]*$//')
EXPECTED="::set-output name=scan-passed::true"
if [[ "$LAST_LINE" = "$EXPECTED" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Missing scan-passed(true) output"
  FAILED+=("$TEST_NAME")
fi

echo " >> Tests: $((${#PASSED[@]}+${#FAILED[@]})), Passed: ${#PASSED[@]}, Failed: ${#FAILED[@]}"
exit ${#FAILED[@]}
