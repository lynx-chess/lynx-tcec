#!/bin/bash

############################################################################
############################################################################
# This script will create a directory named Lynx-<version>-linux-x64
# All files inside that directory are required to run Lynx as expected
# Dependencies: wget and unzip
############################################################################
############################################################################

############################################################################
# Check if LYNX_VERSION is set, otherwise default to latest release
############################################################################
if [ -n "$LYNX_VERSION" ]; then
    # Prepend "v" if it is not already present
    if [[ "$LYNX_VERSION" != v* ]]; then
        LYNX_VERSION="v$LYNX_VERSION"
    fi
    lynx_url="https://api.github.com/repos/lynx-chess/Lynx/releases/tags/$LYNX_VERSION"
else
    lynx_url="https://api.github.com/repos/lynx-chess/Lynx/releases/latest"
fi

############################################################################
# Download linux-x64 artifact
############################################################################
download_url=$(curl -s "$lynx_url" | \
    grep -o '"browser_download_url": "[^"]*' | \
    awk -F'"' '{print $4}' | \
    grep 'Lynx-.*-linux-x64.zip')

wget "$download_url"

############################################################################
# Extract artifact to a directory named Lynx-<version>-linux-x64
############################################################################
filename=$(basename "$download_url")
dirname="${filename%.zip}"
mkdir -p "$dirname"
unzip -o "$filename" -d "$dirname"

############################################################################
# Set $EXE variable and run bench
############################################################################
EXE=$PWD/$dirname/Lynx.Cli
echo $EXE

chmod +x $EXE
$EXE "bench"
