#!/usr/bin/env bash

set -e

echo "Running test: Scan Passed"
echo "-------------------------"

ROOT="$(dirname "$(dirname "$(readlink -fm "$0")")")"

OUTPUT=$(docker run -v "$ROOT:/github/workspace" sourcehawk-scan-github-action:test "tests/scan-passed")
SCAN_EXIT_CODE=$?

if [[ $SCAN_EXIT_CODE -eq 0 ]]; then
  echo " > SCAN_EXIT_CODE: Correct"
else
  echo " > SCAN_EXIT_CODE: Incorrect, expected 0, got $SCAN_EXIT_CODE"
fi

FIRST_LINE=$(echo "$OUTPUT" | head -1 | sed -e 's/[[:space:]]*$//')
EXPECTED="Scan passed without any errors"
if [[ "$FIRST_LINE" = "$EXPECTED" ]]; then
  echo " > SCAN_RESULT_MESSAGE: Correct"
else
  echo " > SCAN_RESULT_MESSAGE: Missing or incorrect, found: [$FIRST_LINE], expected: [$EXPECTED]"
  exit 1
fi

LAST_LINE=$(echo "$OUTPUT" | tail -1 | sed -e 's/[[:space:]]*$//')
EXPECTED="::set-output name=scan-passed::true"
if [[ "$LAST_LINE" = "$EXPECTED" ]]; then
  echo " > GITHUB_ACTION_OUTPUT: Correct"
else
  echo " > GITHUB_ACTION_OUTPUT: Missing scan-passed(true) output"
  exit 1
fi

echo "Test Passed"
echo "-------------------------"