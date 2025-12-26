#!/bin/bash

# Move to script's directory
cd "`dirname "$0"`"

dxcPath="$(cd "./DirectXShaderCompiler" && pwd -P)"

outputFolder="./binaries/osx"
rm -r -f $outputFolder
mkdir -p $outputFolder

logFolder="./logs/osx"
rm -r -f $logFolder
mkdir -p $logFolder

buildFolder="build"

dxcBuild="$dxcPath/$buildFolder"

# Generate DXC
echo "Generate DXC"

rm -r -f $dxcBuild

cmake -S $dxcPath -B $dxcBuild -C "$dxcPath/cmake/caches/PredefinedParams.cmake" -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_DEPLOYMENT_TARGET="10.15" -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" > "$logFolder/dxc.gen.log"

echo -e "\tDone"

# Build DXC
echo "Build DXC"

cmake --build $dxcBuild --target dxc > "$logFolder/dxc.bin.log"

cp -f "$dxcBuild/bin/dxc" "$outputFolder/dxc"
cp -f "$dxcBuild/lib/libdxcompiler.dylib" "$outputFolder/libdxcompiler.dylib"

echo -e "\tDone"
