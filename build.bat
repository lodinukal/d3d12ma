@echo off
setlocal
cd /D "%~dp0"

:: set from env first
if defined VCVARSALL (
    set VCVARSALL=%VCVARSALL%
)

:: vs2022
if not exist %VCVARSALL% (
    set VCVARSALL="C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat"
)

:: vs2019
if not exist %VCVARSALL% (
    set VCVARSALL="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat"
)

:: vs2017
if not exist %VCVARSALL% (
    set VCVARSALL="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
)

if not exist %VCVARSALL% (
    echo "vcvarsall.bat not found"
    exit /b 1
)

echo using vcvarsall: %VCVARSALL%

if not exist build mkdir build
call :compile x64 d3d12ma_x64
call :compile amd64_x86 d3d12ma_x86
call :compile amd64_arm64 d3d12ma_arm64
exit /b %ERRORLEVEL%

:compile
call %VCVARSALL% %1
:: output pdb to build
call cl /Od /Iinclude src\build.cpp /c /Fo:build\d3d12ma_%1.o /Z7
call lib build\d3d12ma_%1.o /out:lib\%2.lib
exit /b 0