#!/usr/bin/env bash

clean_download() {
    local url=$1
    local output_location=$2
    local tempdir
    tempdir=$(mktemp -d)
    local downloader_installed=""

    _apt_get_install() {
        local apt_tempdir=$1
        cp -p -R /var/lib/apt/lists "$apt_tempdir"
        apt-get update -y
        apt-get -y install --no-install-recommends wget ca-certificates
    }

    _apt_get_cleanup() {
        local apt_tempdir=$1
        apt-get -y purge wget --auto-remove
        rm -rf /var/lib/apt/lists/*
        rm -r /var/lib/apt/lists
        mv "$apt_tempdir/lists" /var/lib/apt/lists
    }

    _apk_install() {
        local apk_tempdir=$1
        cp -p -R /var/cache/apk "$apk_tempdir"
        apk add --no-cache wget
    }

    _apk_cleanup() {
        apk del wget
    }

    local downloader
    if type curl >/dev/null 2>&1; then
        downloader=curl
    elif type wget >/dev/null 2>&1; then
        downloader=wget
    else
        downloader=""
    fi

    if [ -z "$downloader" ]; then
        if [ -x "/usr/bin/apt-get" ]; then
            _apt_get_install "$tempdir"
        elif [ -x "/sbin/apk" ]; then
            _apk_install "$tempdir"
        else
            echo "distro not supported"
            exit 1
        fi
        downloader="wget"
        downloader_installed="true"
    fi

    if [ "$downloader" = "wget" ]; then
        wget -q "$url" -O "$output_location"
    else
        curl -sfL "$url" -o "$output_location"
    fi

    if [ -n "$downloader_installed" ]; then
        if [ -x "/usr/bin/apt-get" ]; then
            _apt_get_cleanup "$tempdir"
        elif [ -x "/sbin/apk" ]; then
            _apk_cleanup
        fi
    fi
}

ensure_nanolayer() {
    local variable_name=$1
    local required_version=$2

    if [[ $required_version != v* ]]; then
        required_version="v$required_version"
    fi

    local resolved_nanolayer=""
    if [[ -z "${NANOLAYER_FORCE_CLI_INSTALLATION:-}" ]]; then
        if [[ -z "${NANOLAYER_CLI_LOCATION:-}" ]]; then
            if type nanolayer >/dev/null 2>&1; then
                resolved_nanolayer=nanolayer
            fi
        elif [[ -f "$NANOLAYER_CLI_LOCATION" && -x "$NANOLAYER_CLI_LOCATION" ]]; then
            resolved_nanolayer=$NANOLAYER_CLI_LOCATION
        fi

        if [[ -n "$resolved_nanolayer" ]]; then
            local current_version
            current_version=$($resolved_nanolayer --version)
            if [[ $current_version != v* ]]; then
                current_version="v$current_version"
            fi
            if [[ $current_version != "$required_version" ]]; then
                resolved_nanolayer=""
            fi
        fi
    fi

    if [[ -z "$resolved_nanolayer" ]]; then
        if [[ "$(uname -sm)" != "Linux x86_64" && "$(uname -sm)" != "Linux aarch64" ]]; then
            echo "No nanolayer binary for $(uname -sm)"
            exit 1
        fi

        local nanolayer_tempdir
        nanolayer_tempdir=$(mktemp -d -t nanolayer-XXXXXXXXXX)
        clean_up() {
            local exit_code=$?
            rm -rf "$nanolayer_tempdir"
            exit "$exit_code"
        }
        trap clean_up EXIT

        local clib_type=gnu
        if [ -x "/sbin/apk" ]; then
            clib_type=musl
        fi
        local tar_filename="nanolayer-$(uname -m)-unknown-linux-$clib_type.tgz"
        clean_download \
            "https://github.com/devcontainers-extra/nanolayer/releases/download/$required_version/$tar_filename" \
            "$nanolayer_tempdir/$tar_filename"
        tar xfz "$nanolayer_tempdir/$tar_filename" -C "$nanolayer_tempdir"
        chmod a+x "$nanolayer_tempdir/nanolayer"
        resolved_nanolayer="$nanolayer_tempdir/nanolayer"
    fi

    declare -g "$variable_name=$resolved_nanolayer"
}
