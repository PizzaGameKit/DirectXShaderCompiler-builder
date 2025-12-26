#!/bin/bash

# Move to script's directory
cd "`dirname "$0"`"

arch=$1

dxcPath="$(cd "./DirectXShaderCompiler" && pwd -P)"

outputFolder="./binaries/linux-$arch"
rm -r -f $outputFolder
mkdir -p $outputFolder

logFolder="./logs/linux-$arch"
rm -r -f $logFolder
mkdir -p $logFolder

buildFolder="build"

dxcBuild="$dxcPath/$buildFolder"

# Generate DXC
echo "Generate DXC"

rm -r -f $dxcBuild

cmake -S $dxcPath -B $dxcBuild -C "$dxcPath/cmake/caches/PredefinedParams.cmake" -DCMAKE_BUILD_TYPE=Release > "$logFolder/dxc.gen.log"

echo -e "\tDone"

# Build DXC
echo "Build DXC"

cmake --build $dxcBuild --target dxc > "$logFolder/dxc.bin.log"

cp -f "$dxcBuild/bin/dxc" "$outputFolder/dxc"
cp -f "$dxcBuild/lib/libdxcompiler.so" "$outputFolder/libdxcompiler.so"

echo -e "\tDone"
