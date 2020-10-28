#!/usr/bin/env bash

set -e

# Build the docker image
docker build -t sourcehawk-scan-github-action:test .