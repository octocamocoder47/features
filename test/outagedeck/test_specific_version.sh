#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "outagedeck version is 0.1.0" sh -c "outagedeck --version | grep '0.1.0'"

reportResults
