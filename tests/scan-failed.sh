#!/usr/bin/env bash

OUTPUT=$(docker run -v "$1:/github/workspace" "$2" "tests/scan-failed")
SCAN_EXIT_CODE=$?

EST_NAME="SCAN_EXIT_CODE"
if [[ $SCAN_EXIT_CODE -eq 1 ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Incorrect, expected 1, got $SCAN_EXIT_CODE"
  FAILED+=("$TEST_NAME")
fi

TEST_NAME="SCAN_RESULT_MESSAGE"
FIRST_LINE=$(echo "$OUTPUT" | head -1 | sed -e 's/[[:space:]]*$//')
EXPECTED="Scan resulted in failure. Error(s): 1, Warning(s): 0"
if [[ "$FIRST_LINE" = "$EXPECTED" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Missing or incorrect, found: [$FIRST_LINE], expected: [$EXPECTED]"
  FAILED+=("$TEST_NAME")
fi

TEST_NAME="SCAN_RESULT_ERROR"
SECOND_LINE=$(echo "$OUTPUT" | tail -2 | head -1 | sed -e 's/[[:space:]]*$//' | sed 's/\x1b\[[0-9;]*m//g')
EXPECTED="[ERROR] foo.bar :: File not found"
if [[ "$SECOND_LINE" = "$EXPECTED" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Missing or incorrect, found: [$SECOND_LINE], expected: [$EXPECTED]"
  FAILED+=("$TEST_NAME")
fi

TEST_NAME="GITHUB_ACTION_OUTPUT"
LAST_LINE=$(echo "$OUTPUT" | tail -1 | sed -e 's/[[:space:]]*$//')
EXPECTED="::set-output name=scan-passed::false"
if [[ "$LAST_LINE" = "$EXPECTED" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Missing scan-passed(false) output"
  FAILED+=("$TEST_NAME")
fi

echo " >> Tests: $((${#PASSED[@]}+${#FAILED[@]})), Passed: ${#PASSED[@]}, Failed: ${#FAILED[@]}"
exit ${#FAILED[@]}
