@echo off
@rem ---------------------------------------------------------------------------
@rem Purpose:      This sets up a list of ENV VARS for cmd.exe.
@rem Parameters:   -i : Optional. Will install into the registry.
@rem Returns:      0 on success, 1 on failure
@rem Dependencies: none
@rem Notes:        This can be loaded by a call command or loaded into every
@rem               cmd instance by creating the registry:
@rem               - Key: HKEY_CURRENT_USER\Software\Microsoft\Command Processor
@rem               - String Value: AutoRun
@rem               - Set the value to the path of this file.
@rem ---------------------------------------------------------------------------

if "%1" == "-i" (
    echo Installing %~nx0 into cmd.exe Autorun registry...
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

rem MARK: Apache Ant
rem Add the color logger arguments
set ANT_ARGS=-logger org.apache.tools.ant.listener.AnsiColorLogger
rem Load user overrides
set ANT_OPTS=-Dant.logger.defaults=%USERPROFILE%/.config/ant/ant-colors.properties

rem Load aliases
if exist "%USERPROFILE%\.aliases.cmd" (
    call "%USERPROFILE%\.aliases.cmd"
)
