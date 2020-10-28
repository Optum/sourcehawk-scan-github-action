#!/usr/bin/env bash

set -e

ROOT="$(dirname "$(dirname "$(readlink -fm "$0")")")"

# Set up testing environment
./tests/setup.sh

# Execute tests
"$ROOT/tests/scan-passed.sh"
"$ROOT/tests/scan-failed.sh"
"$ROOT/tests/scan-error.sh"