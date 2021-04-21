#!/usr/bin/env bash

OUTPUT=$(docker run -v "$1:/github/workspace" "$2" "tests/scan-custom" "sh.yml" "JSON" "sourcehawk-scan-results.json" false true "primary")
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

TEST_NAME="SCAN_RESULT_JSON"
OUTPUT_JSON="$(echo "$OUTPUT" | head -n -1 | sed 's/ *$//')"
read -r -d '' EXPECTED_JSON << EOS
{
  "errorCount" : 0,
  "passed" : true,
  "messages" : { },
  "passedWithNoWarnings" : true,
  "warningCount" : 0,
  "formattedMessages" : [ ]
}
EOS
if [[ "$OUTPUT_JSON" == "$EXPECTED_JSON" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Missing or incorrect, found: [$OUTPUT_JSON], expected: [$EXPECTED_JSON]"
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

TEST_NAME="RESULT_FILE"
if [[ -f "sourcehawk-scan-results.json" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Missing result file at path: sourcehawk-scan-results.json"
  FAILED+=("$TEST_NAME")
fi

TEST_NAME="RESULT_FILE_JSON"
OUTPUT_JSON_FILE="$(sed 's/ *$//' "sourcehawk-scan-results.json")"
if [[ "$OUTPUT_JSON_FILE" == "$EXPECTED_JSON" ]]; then
  echo " > $TEST_NAME: Correct"
  PASSED+=("$TEST_NAME")
else
  echo " > $TEST_NAME: Incorrect result file JSON, found: [$OUTPUT_JSON_FILE], expected: [$EXPECTED_JSON]"
  FAILED+=("$TEST_NAME")
fi

echo " >> Tests: $((${#PASSED[@]}+${#FAILED[@]})), Passed: ${#PASSED[@]}, Failed: ${#FAILED[@]}"
exit ${#FAILED[@]}
