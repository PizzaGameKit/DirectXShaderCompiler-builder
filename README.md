# DirectXShaderCompiler-builder
This repository uses [Github Actions](https://github.com/PizzaGameKit/DirectXShaderCompiler-builder/actions) to self-build Microsoft's [DirectX Shader Compiler](https://github.com/microsoft/DirectXShaderCompiler) upon triggering a workflow.

_This work is unofficial_. If you are new to **DirectX Shader Compiler**, please refer to [the official distribution](https://github.com/microsoft/DirectXShaderCompiler/releases).

This repository is not meant to be an alternative release source, and therefore we will not propose pre-built binaries in the release section (and we made the build artifacts to expire almost instantly).

The reason is that we do not wish to be an alternative source of binaries, and we want to encourage users to either build their own, or to download binaries only from official sources (for security reason, never trust alternative distributions or .dll files downloaded from random websites).

## Why?
This repository provides a build system and binaries for **[PizzaGameKit](https://github.com/PizzaGameKit)**. It mostly aims at being self-sufficient and having our own mirrors, without the need to fetch any online dependencies.

No source change is made. Current target version is dxc 1.8.2505.1

This repository builds ```win-x64```, ```win-arm64```, ```linux-x64```, ```linux-arm64```, and ```osx``` (as Universal binaries containing both x64 and arm64).

## How to use
This repository is meant to be forked, and then the Github Actions workflow should be run (manually). Once completed, the binaries will be available in the workflow artifacts for download.

Alternatively, you can download the repository (make sure to download each submodules as well, and each of their sub-submodules if any), and run the build scripts corresponding to your system. Binaries will be placed in ```./binaries```. For troubleshooting, check ```./logs```.

## Requirements
For building Windows:

- Visual Studio with the C++ development workload (of the expected target architecture, i.e. x86.x64 or ARM64);
- PowerShell;
- CMake 3.17.2 (or newer).

For building Linux:

- Any C++ build system;
- CMake 3.17.2 (or newer).

For building macOS:

- Any C++ build system (preferably Xcode's);
- CMake 3.17.2 (or newer).

## Licenses

DirectX Shader Compiler abides to [its own set of licenses](https://github.com/PizzaGameKit/DirectXShaderCompiler/blob/main/LICENSE.TXT).

This very repository does nothing fancy and is just a collection of build scripts. You can consider those scripts as public domain.
