#!/bin/bash

############################################################################
############################################################################
# This script creates a binary file named Lynx-<version> and some adjacent
# files in the current directory. All those files are required to run Lynx
# as expected, so please keep them next to the binary,
#
# It also creates a temporary directory named Lynx-<branch>-<date>, which
# can be deleted after the script finishes.
#
# All files inside that directory are required to run Lynx as expected
# Dependencies: git, make and .NET SDK
############################################################################
############################################################################

############################################################################
# Check if LYNX_VERSION is set, otherwise default to 'main' branch
############################################################################
if [ -n "$LYNX_VERSION" ]; then
    target=$LYNX_VERSION
else
    target="main"
fi

############################################################################
# Clone the repository to Lynx-$target-$date
############################################################################
printf -v dirname '%(%Y-%m-%d_%H-%M-%S)T' -1
dirname="Lynx-$target-$dirname"

git clone --depth 1 https://github.com/lynx-chess/Lynx.git $dirname
cp $dirname/LICENSE .
cp $dirname/src/Lynx/Lynx.Cli/appsettings.json .

cd $dirname

git checkout $target
git log -1 --pretty=oneline

############################################################################
# Verify .NET SDK installation and version chosen by global.json
############################################################################
dotnet --list-sdks
dotnet --version

############################################################################
# Build Lynx engine, detecting OS and architecture
############################################################################
make

############################################################################
# Extract version, rename to Lynx-<version> and copy to original directory
############################################################################
EXE=$PWD/artifacts/Lynx/Lynx.Cli
echo "#### Build output -> $EXE"

chmod +x $EXE

version=`$EXE "quit"`
version=$(echo "$version" | sed -E 's/Lynx ([^ ]+) .*/Lynx-\1/')
echo "#### Version -> $version"

cp $EXE ../$version
cd ..

EXE=$PWD/$version
echo "#### Final path -> $EXE"
chmod +x $EXE

$EXE "bench"
