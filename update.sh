#!/bin/bash

###############################################################################
###############################################################################
# This script builds Lynx latest development version from source.
# Alternatively, LYNX_VERSION can be used to build a specific version.
#
# A binary file (Lynx.Cli) and some adjacent files are copied to $PWD.
# All those files are required to run Lynx.
#
# The temporary directory Lynx-<branch>-<date> can be deleted
# after the script finishes.
#
# Dependencies: git, make and .NET 9 SDK
#
# License: MIT
# Source: https://github.com/lynx-chess/lynx-tcec/blob/main/update.sh
###############################################################################
###############################################################################

###############################################################################
# Check if LYNX_VERSION is set, otherwise default to 'main' branch
###############################################################################
if [ -n "$LYNX_VERSION" ]; then
    target=$LYNX_VERSION
else
    target="main"
fi

###############################################################################
# Clone the repository to Lynx-$target-$date
###############################################################################
printf -v timestamp '%(%Y-%m-%d_%H-%M-%S)T' -1
sanitized_target=${target//\//-} # Replace '/' with '-'
dirname="Lynx-$sanitized_target-$timestamp"

echo "#### Checking out -> $target"

git clone https://github.com/lynx-chess/Lynx.git $dirname
cd $dirname

git checkout $target
git log -1 --pretty=oneline

###############################################################################
# Verify .NET SDK installation and version chosen by global.json
###############################################################################
dotnet --list-sdks
dotnet --version

###############################################################################
# Build Lynx engine, detecting OS and architecture
###############################################################################
make
EXE=$PWD/artifacts/Lynx/Lynx.Cli
echo "#### Build output -> $EXE"

###############################################################################
# Copy file to original directory
###############################################################################
cp $EXE ..
cp LICENSE ..
cp src/Lynx.Cli/appsettings.json ..

cd ..

###############################################################################
# Set $EXE variable, check version and run bench
###############################################################################
EXE=$PWD/Lynx.Cli
chmod +x $EXE

version=`$EXE "quit"`
version=$(echo "$version" | grep -oP 'Lynx \K[^\s]+')
$EXE "runtimeconfig" "quit"

echo "#### Version -> $version"
echo "#### Final path -> $EXE"

$EXE "bench"
