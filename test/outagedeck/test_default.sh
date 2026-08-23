#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "outagedeck is installed" outagedeck --version
check "outagedeck status command is available" sh -c "outagedeck help | grep 'outagedeck status'"

reportResults
