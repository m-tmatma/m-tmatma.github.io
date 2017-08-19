@echo off
set PARAM_ARCH=%1
if "%PARAM_ARCH%" == "x86" (
	set BUILD_ARCH=%PARAM_ARCH%
) else if "%PARAM_ARCH%" == "x64" (
	set BUILD_ARCH=%PARAM_ARCH%
) else (
	goto SHOW_HELP
)

set ROOTDIR=llvm
set BUILDDIR=build-vs2017-%BUILD_ARCH%
set DIR=%~dp0

cd /d %DIR%

if exist %ROOTDIR% (
	svn update  %ROOTDIR%
	svn update  %ROOTDIR%\tools\clang
	svn update  %ROOTDIR%\tools\lld
	svn update  %ROOTDIR%\tools\polly
	svn update  %ROOTDIR%\projects\compiler-rt
	svn update  %ROOTDIR%\projects\libcxx
	svn update  %ROOTDIR%\projects\libcxxabi
) else (
	svn co    http://llvm.org/svn/llvm-project/llvm/trunk        %ROOTDIR%
	svn co    http://llvm.org/svn/llvm-project/cfe/trunk         %ROOTDIR%\tools\clang
	svn co    http://llvm.org/svn/llvm-project/lld/trunk         %ROOTDIR%\tools\lld
	svn co    http://llvm.org/svn/llvm-project/polly/trunk       %ROOTDIR%\tools\polly
	svn co    http://llvm.org/svn/llvm-project/compiler-rt/trunk %ROOTDIR%\projects\compiler-rt
	svn co    http://llvm.org/svn/llvm-project/libcxx/trunk      %ROOTDIR%\projects\libcxx
	svn co    http://llvm.org/svn/llvm-project/libcxxabi/trunk   %ROOTDIR%\projects\libcxxabi
)

cd %ROOTDIR% || exit /b 1

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
cd %BUILDDIR%

del /Q LLVM-*.exe

@echo on
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" %BUILD_ARCH%
"C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 15 2017" -D CMAKE_INSTALL_PREFIX=c:\clang
"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.com" LLVM.sln  /rebuild "Release|Win32"

exit /b %ERRORLEVEL%

:SHOW_HELP
	@echo off
	echo clang-vs2017.bat ARCH
	echo ARCH
	echo x86: build for x86
	echo x64: build for x64
	exit /b 1
