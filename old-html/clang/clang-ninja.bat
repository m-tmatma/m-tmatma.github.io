@echo off
set PARAM_ARCH=%1
if "%PARAM_ARCH%" == "x86" (
	set BUILD_ARCH=%PARAM_ARCH%
) else if "%PARAM_ARCH%" == "x64" (
	set BUILD_ARCH=%PARAM_ARCH%
) else (
	goto SHOW_HELP
)

set PARAM_ACTION=%2
if "%PARAM_ACTION%" == "rebuild" (
	set BUILD_ACTION=%PARAM_ACTION%
) else if "%PARAM_ACTION%" == "update" (
	set BUILD_ACTION=%PARAM_ACTION%
) else (
	set BUILD_ACTION=update
)

set ROOTDIR=llvm
set BUILDDIR=build-ninja-%BUILD_ARCH%
set DIR=%~dp0

cd /d %DIR%

if exist %ROOTDIR% (
	svn update  %ROOTDIR%
) else (
	svn co    http://llvm.org/svn/llvm-project/llvm/trunk        %ROOTDIR%
)

if exist %ROOTDIR%\tools\clang (
	svn update  %ROOTDIR%\tools\clang
) else (
	svn co    http://llvm.org/svn/llvm-project/cfe/trunk         %ROOTDIR%\tools\clang
)

if exist %ROOTDIR%\tools\lld (
	svn update  %ROOTDIR%\tools\lld
) else (
	svn co    http://llvm.org/svn/llvm-project/lld/trunk         %ROOTDIR%\tools\lld
)

if exist %ROOTDIR%\tools\polly (
	svn update  %ROOTDIR%\tools\polly
) else (
	svn co    http://llvm.org/svn/llvm-project/polly/trunk       %ROOTDIR%\tools\polly
)

if exist %ROOTDIR%\projects\compiler-rt (
	svn update  %ROOTDIR%\projects\compiler-rt
) else (
	svn co    http://llvm.org/svn/llvm-project/compiler-rt/trunk %ROOTDIR%\projects\compiler-rt
)

if exist %ROOTDIR%\projects\libcxx (
	svn update  %ROOTDIR%\projects\libcxx
) else (
	svn co    http://llvm.org/svn/llvm-project/libcxx/trunk      %ROOTDIR%\projects\libcxx
)


if exist %ROOTDIR%\projects\libcxxabi (
	svn update  %ROOTDIR%\projects\libcxxabi
) else (
	svn co    http://llvm.org/svn/llvm-project/libcxxabi/trunk   %ROOTDIR%\projects\libcxxabi
)

cd %ROOTDIR% || exit /b 1

if "%BUILD_ACTION%" == "rebuild" (
	echo update clean
	if exist %BUILDDIR%     rmdir /s /q %BUILDDIR%
	if exist %BUILDDIR%     rmdir /s /q %BUILDDIR%
	if exist %BUILDDIR%     rmdir /s /q %BUILDDIR%
	if exist %BUILDDIR%     rmdir /s /q %BUILDDIR%
	if exist %BUILDDIR%     rmdir /s /q %BUILDDIR%
	if exist %BUILDDIR%     rmdir /s /q %BUILDDIR%
	if exist %BUILDDIR%     rmdir /s /q %BUILDDIR%
	if exist %BUILDDIR%     rmdir /s /q %BUILDDIR%
	if exist %BUILDDIR%     exit /b 1
	if not exist %BUILDDIR% mkdir %BUILDDIR%
) else if "%BUILD_ACTION%" == "update" (
	echo update build
	if not exist %BUILDDIR% mkdir %BUILDDIR%
)

cd %BUILDDIR%

del /Q LLVM-*.exe

@echo on
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" %BUILD_ARCH%
"C:\Program Files\CMake\bin\cmake.exe" -G Ninja -D CMAKE_INSTALL_PREFIX=c:\clang -D CMAKE_BUILD_TYPE=Release ..
"C:\Program Files (x86)\Ninja\ninja.exe" -v package

cd /d %DIR%

exit /b %ERRORLEVEL%

:SHOW_HELP
	@echo off
	echo clang-ninja.bat ARCH [action]
	echo ARCH
	echo x86: build for x86
	echo x64: build for x64
	echo action
	echo update : update build
	echo rebuild: rebuild
	exit /b 1
