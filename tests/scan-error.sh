#!/usr/bin/env bash

echo "Running test: Scan Error"
echo "-------------------------"

ROOT="$(dirname "$(dirname "$(readlink -fm "$0")")")"

OUTPUT=$(docker run -v "$ROOT:/github/workspace" sourcehawk-scan-github-action:test "tests/scan-error")
SCAN_EXIT_CODE=$?

if [[ $SCAN_EXIT_CODE -eq 1 ]]; then
  echo " > SCAN_EXIT_CODE: Correct"
else
  echo " > SCAN_EXIT_CODE: Incorrect, expected 1, got $SCAN_EXIT_CODE"
fi

FIRST_LINE=$(echo "$OUTPUT" | head -1 | sed -e 's/[[:space:]]*$//')
EXPECTED="Scan resulted in failure. Error(s): 1, Warning(s): 0"
if [[ "$FIRST_LINE" = "$EXPECTED" ]]; then
  echo " > SCAN_RESULT_MESSAGE: Correct"
else
  echo " > SCAN_RESULT_MESSAGE: Missing or incorrect, found: [$FIRST_LINE], expected: [$EXPECTED]"
  exit 1
fi

SECOND_LINE=$(echo "$OUTPUT" | tail -2 | head -1 | sed -e 's/[[:space:]]*$//')
EXPECTED="[ERROR] sourcehawk.yml :: Configuration file not found"
if [[ "$SECOND_LINE" = "$EXPECTED" ]]; then
  echo " > SCAN_RESULT_ERROR: Correct"
else
  echo " > SCAN_RESULT_ERROR: Missing or incorrect, found: [$SECOND_LINE], expected: [$EXPECTED]"
  exit 1
fi

LAST_LINE=$(echo "$OUTPUT" | tail -1 | sed -e 's/[[:space:]]*$//')
EXPECTED="::set-output name=scan-passed::false"
if [[ "$LAST_LINE" = "$EXPECTED" ]]; then
  echo " > GITHUB_ACTION_OUTPUT: Correct"
else
  echo " > GITHUB_ACTION_OUTPUT: Missing scan-passed(false) output"
  exit 1
fi

echo "Test Passed"
echo "-------------------------"