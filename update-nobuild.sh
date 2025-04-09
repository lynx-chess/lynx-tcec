#!/bin/bash

###############################################################################
###############################################################################
# This script downloads the latest Lynx release from GitHub (lynx-chess/Lynx).
# Alternatively, LYNX_VERSION can be used to download a specific version.
#
# A binary file (Lynx.Cli) and some adjacent files are copied to $PWD.
# All those files are required to run Lynx.
#
# The temporary directory Lynx-<version>-<os>-<arch> can be deleted
# after the script finishes.
#
# Dependencies: curl, wget and unzip
###############################################################################
###############################################################################

###############################################################################
# Check if LYNX_VERSION is set, otherwise default to latest release
###############################################################################
if [ -n "$LYNX_VERSION" ]; then
    # Prepend "v" if it is not already present
    if [[ "$LYNX_VERSION" != v* ]]; then
        LYNX_VERSION="v$LYNX_VERSION"
    fi

    echo "#### Downloading -> $LYNX_VERSION"
    lynx_url="https://api.github.com/repos/lynx-chess/Lynx/releases/tags/$LYNX_VERSION"
else
    echo "#### Downloading -> latest released version"
    lynx_url="https://api.github.com/repos/lynx-chess/Lynx/releases/latest"
fi

###############################################################################
# Download linux-x64 artifact
###############################################################################

download_url=$(curl -s "$lynx_url" | \
    grep -o '"browser_download_url": "[^"]*' | \
    awk -F'"' '{print $4}' | \
    grep 'Lynx-.*-linux-x64.zip')

wget "$download_url"

###############################################################################
# Extract artifact to a directory named Lynx-<version>-linux-x64
###############################################################################
filename=$(basename "$download_url")
dirname="${filename%.zip}"
mkdir -p "$dirname"
unzip -o "$filename" -d "$dirname"

rm $filename

EXE=$PWD/$dirname/Lynx.Cli
echo "#### Downloaded artifact -> $EXE"

###############################################################################
# Copy artifact files to original directory
###############################################################################
cp $dirname/* .

###############################################################################
# Set $EXE variable, check version and run bench
###############################################################################
EXE=$PWD/Lynx.Cli
chmod +x $EXE

version=`$EXE "quit"`
version=$(echo "$version" | grep -oP 'Lynx \K[^\s]+')

echo "#### Version -> $version"
echo "#### Final path -> $EXE"

$EXE "bench"
