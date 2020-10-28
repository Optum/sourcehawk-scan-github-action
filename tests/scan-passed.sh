#!/usr/bin/env bash

set -e

OUTPUT=$(docker run sourcehawk-scan-github-action:test scan)