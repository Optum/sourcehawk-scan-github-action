#!/usr/bin/env bash

set -e

# Set up testing environment
./tests/setup.sh

# Execute tests
./tests/scan-passed.sh
./tests/scan-failed.sh
./tests/scan-error.sh
./tests/scan-custom.sh