@echo off
setlocal enabledelayedexpansion

REM SET BALLERINAURL=https://dist.ballerina.io/downloads/1.2.22/ballerina-windows-installer-x64-1.2.22.msi
SET BALLERINAURL=https://dist.ballerina.io/downloads/2201.13.0/ballerina-2201.13.0-swan-lake-windows-x64.msi


REM basefolder
for /F "delims=" %%I in ("%~dp0") do set basefolder=%%~fI


set BINFOLDER=%basefolder%bin\

:STARTBALLERINA
set BALLERINA=%BINFOLDER%bal.bat

IF NOT EXIST "%BALLERINA%" GOTO DOWNLOAD

set PATH=%BINFOLDER%;%PATH%

REM clearing the screen
cls

REM starting the shell with ballerina version
start /B %COMSPEC% /K "%BALLERINA% -v"

exit





:DOWNLOAD
SET /P AREYOUSURE=Ballerina  is missing. Do you want to download it (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END
bitsadmin.exe /transfer "Download Ballerina"  "%BALLERINAURL%" "%basefolder%tmp_ballerina.msi"

IF EXIST "%basefolder%tmp_ballerina.msi" msiexec /a "%basefolder%tmp_ballerina.msi" /qb TARGETDIR="%basefolder%tmp"

IF EXIST "%basefolder%tmp\ballerina\bin\bal.bat" (
xcopy /SQRY "%basefolder%tmp\ballerina\*" %basefolder%
) ELSE (
echo Cannot find bal.bat. Probably msi not extracted
pause
exit
)

del /F "%basefolder%tmp_ballerina.msi"
del /F "%basefolder%tmp\tmp_ballerina.msi"
rmdir /S /Q "%basefolder%tmp\ballerina"

IF EXIST "%BALLERINA%" GOTO STARTBALLERINA




:END
pause