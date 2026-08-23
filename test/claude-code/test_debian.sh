#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "claude is installed" claude --version
check "~/.claude is owned by the current user" test "$(stat -c %u "$HOME/.claude")" = "$(id -u)"
check "~/.local/share/claude is owned by the current user" test "$(stat -c %u "$HOME/.local/share/claude")" = "$(id -u)"

reportResults
