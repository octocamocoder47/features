#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "tflint version is equal to 0.62.0" sh -c "tflint --version | grep '0.62.0'"

reportResults
