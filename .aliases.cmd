@echo off

rem MARK: Navigation
doskey ..=cd ..
doskey ...=cd ../..
doskey ....=cd ../../..
doskey .....=cd ../../../..

rem MARK: dotfiles
if exist "%USERPROFILE%\.dotfiles" doskey dfgit=git --git-dir^="%USERPROFILE%\.dotfiles" --work-tree^="%USERPROFILE%" $*

rem MARK: Git
doskey gitroot=for /f "delims=" %%i in ('git rev-parse --show-toplevel') do cd "%%i"

rem MARK: External apps
DOSKEY google=start "" "https://google.com"
DOSKEY web=start "" "https://%1"

if exist "%USERPROFILE%\.aliases.%COMPUTERNAME%.cmd" (
    call "%USERPROFILE%\.aliases.%COMPUTERNAME%.cmd"
)
if exist "%USERPROFILE%\.aliases.extra.cmd" (
    call "%USERPROFILE%\.aliases.extra.cmd"
)

rem MARK: Linux alternatives

rem systeminfo | find "System Boot Time"
DOSKEY uptime=systeminfo ^| find "System Boot Time"
