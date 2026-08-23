#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "tflint is installed" tflint --version

reportResults
