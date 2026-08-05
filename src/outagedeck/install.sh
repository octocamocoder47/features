#!/usr/bin/env bash

set -e

source ./library_scripts.sh

# nanolayer is a CLI utility which keeps container layers as small as possible.
# Source: https://github.com/devcontainers-extra/nanolayer
ensure_nanolayer nanolayer_location "v0.5.6"

"$nanolayer_location" \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/gh-release:1" \
    --option repo='outagedeck/cli' \
    --option binaryNames='outagedeck' \
    --option version="$VERSION"

echo 'Done!'
