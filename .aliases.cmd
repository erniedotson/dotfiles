@echo off
rem ---------------------------------------------------------------------------
rem Purpose:      This sets up a list of aliases for cmd.exe.
rem Parameters:   -i : Optional. Will install into the registry.
rem Returns:      0 on success, 1 on failure
rem Dependencies: none
rem Notes:        This can be loaded by a call command or loaded into every
rem               cmd instance by creating the registry:
rem               - Key: HKEY_CURRENT_USER\Software\Microsoft\Command Processor
rem               - String Value: AutoRun
rem               - Set the value to the path of this file.
rem ---------------------------------------------------------------------------


if "%1" == "-i" (
    echo "Installing cmd.exe aliases into registry..."
    rem  TODO: Get script path instead of assuming USERPROFILE
    reg add "HKCU\Software\Microsoft\Command Processor" /v "AutoRun" /T REG_SZ /d "%~f0" || exit /b 1
    %~f0
)

rem Set HOME variable for better compatiblity when running in Git Bash
if not "%HOME%"=="" (
   if /i NOT "%HOME%"=="%USERPROFILE%" (
       echo WARNING: Variables HOME [%HOME%] and USERPROFILE [%USERPROFILE%] differ.
       echo          Setting HOME to USERPROFILE.
       echo.
   )
)
set HOME=%USERPROFILE%

rem Naviation
doskey ..=cd ..
doskey ...=cd ../..
doskey ....=cd ../../..
doskey .....=cd ../../../..

rem Git
doskey gitroot=for /f "delims=" %%i in ('git rev-parse --show-toplevel') do cd "%%i"

rem dotfiles
if exist "%USERPROFILE%\.dotfiles" doskey dfgit=git --git-dir^="%USERPROFILE%\.dotfiles" --work-tree^="%USERPROFILE%" $*

rem External apps
DOSKEY google=start "" "https://google.com"
DOSKEY web=start "" "https://%1"

if exist "%USERPROFILE%\.aliases.%COMPUTERNAME%.cmd" (
    call "%USERPROFILE%\.aliases.%COMPUTERNAME%.cmd"
)
if exist "%USERPROFILE%\.aliases.extra.cmd" (
    call "%USERPROFILE%\.aliases.extra.cmd"
)
