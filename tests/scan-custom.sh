#!/usr/bin/env bash

set -e

echo "Running test: Scan Custom"
echo "-------------------------"

ROOT="$(dirname "$(dirname "$(readlink -fm "$0")")")"

OUTPUT=$(docker run -v "$ROOT:/github/workspace" sourcehawk-scan-github-action:test "tests/scan-custom" "sh.yml" "JSON" "sourcehawk-scan-results.json")
SCAN_EXIT_CODE=$?

if [[ $SCAN_EXIT_CODE -eq 0 ]]; then
  echo " > SCAN_EXIT_CODE: Correct"
else
  echo " > SCAN_EXIT_CODE: Incorrect, expected 0, got $SCAN_EXIT_CODE"
fi

FIRST_LINE=$(echo "$OUTPUT" | head -1 | sed -e 's/[[:space:]]*$//')
EXPECTED='{"passed":true,"errorCount":0,"warningCount":0,"messages":{},"formattedMessages":[]}'
if [[ "$FIRST_LINE" = "$EXPECTED" ]]; then
  echo " > SCAN_RESULT_MESSAGE: Correct"
else
  echo " > SCAN_RESULT_MESSAGE: Missing or incorrect, found: [$FIRST_LINE], expected: [$EXPECTED]"
  exit 1
fi

if [[ -f "sourcehawk-scan-results.json" ]]; then
  echo " > RESULT_FILE: Correct"
else
  echo " > RESULT_FILE: Missing result file at path: sourcehawk-scan-results.json"
  exit 1
fi

echo "Test Passed"
echo "-------------------------"