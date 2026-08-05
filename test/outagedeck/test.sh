#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "outagedeck is installed" outagedeck --version

reportResults
