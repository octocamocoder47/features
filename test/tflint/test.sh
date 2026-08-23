#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "something is installed" tflint --version

reportResults
