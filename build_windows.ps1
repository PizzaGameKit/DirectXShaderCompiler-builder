$arch = "x64"
$vs_arch = "x86.x64"
$cmake_arch = "x64"

if ($Args[0] -eq "arm64")
{
	$arch = $Args[0]
	$vs_arch = "ARM64"
	$cmake_arch = "ARM64"
}

$dxcPath = Convert-Path -LiteralPath "./DirectXShaderCompiler"

$outputFolder = "./binaries/win-$arch"

Remove-Item $outputFolder -Recurse -ErrorAction SilentlyContinue
if (!(Test-Path -Path $outputFolder)) {New-Item $outputFolder -Type Directory >$null}

$logFolder = "./logs/win-$arch"

Remove-Item $logFolder -Recurse -ErrorAction SilentlyContinue
if (!(Test-Path -Path $logFolder)) {New-Item $logFolder -Type Directory >$null}

$buildFolder = "build"

$dxcBuild = "$dxcPath/$buildFolder"
			
Write-Host "Look for MSBuild with C++ support" -ForegroundColor DarkCyan

	Set-Alias vswhere -Value "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

	$msbuild = vswhere -latest -requires Microsoft.VisualStudio.Component.VC.Tools.$vs_arch -find MSBuild\**\Bin\MSBuild.exe | select-object -first 1
	if (!$msbuild -Or !(Test-Path -Path $msbuild))
	{
		Write-Host "`tNot installed. Build aborted. Please install Visual Studio with the C++ component." -ForegroundColor DarkRed
		Read-Host -Prompt "Press Enter to exit"
		Break
	}
	else
	{
		Write-Host "`tFound at: $msbuild"
		Set-Alias msbuild -Value "$msbuild"
	}
	
Write-Host "Look for CMake support" -ForegroundColor DarkCyan

	if (!(Get-Command "cmake" -errorAction SilentlyContinue))
	{
		$cmake = vswhere -latest -find **\cmake.exe | select-object -first 1
		if (!$cmake -Or !(Test-Path -Path $cmake))
		{
			Write-Host "`tCMake is not installed or not on PATH. Please add it to PATH or install it from the Visual Studio components." -ForegroundColor DarkRed
			Read-Host -Prompt "Press Enter to exit"
			Break
		}
		else
		{
			Write-Host "`tFound at (from Visual Studio): $cmake"
			Set-Alias cmake -Value "$cmake"
		}
	}
	else
	{
		$cmake = (Get-Command "cmake" -errorAction SilentlyContinue).Path
		Write-Host "`tFound at (from PATH): $cmake"
	}

Write-Host "Generate DXC" -ForegroundColor DarkCyan

	Remove-Item $dxcBuild -Recurse -ErrorAction SilentlyContinue
	if (!(Test-Path -Path $dxcBuild)) {New-Item $dxcBuild -Type Directory >$null}

	cmake -S $dxcPath -B $dxcBuild -C "$dxcPath/cmake/caches/PredefinedParams.cmake" -G "Visual Studio 17 2022" -A $cmake_arch -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded | Out-File -FilePath "$logFolder/dxc.gen.log" -Append

	Write-Host "`tDone"

Write-Host "Build DXC" -ForegroundColor DarkCyan

	msbuild $dxcBuild/LLVM.sln /t:"Clang executables\dxc" /p:Configuration="Release" /p:Platform="$cmake_arch" | Out-File -FilePath "$logFolder/dxc.bin.log" -Append

	if (!(Test-Path -Path "$outputFolder")) {New-Item "$outputFolder" -Type Directory >$null}
	Copy-Item -Path "$dxcBuild/Release/bin/dxc.exe" -Destination "$outputFolder/dxc.exe"
	Copy-Item -Path "$dxcBuild/Release/bin/dxcompiler.dll" -Destination "$outputFolder/dxcompiler.dll"
	
	Write-Host "`tDone"

Read-Host -Prompt "All done - Press Enter to exit"