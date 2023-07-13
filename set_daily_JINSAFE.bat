@echo off
setlocal

set "appName=JINSAFEQUIZ.appref-ms"

call :CheckApplication %appName%
goto :EOF

:CheckApplication
set "appLocation="
for /f "delims=" %%A in ('where /R %SystemDrive%\ "%~1" 2^>nul') do (
    set "appLocation=%%A"
    goto :LocationFound
)

:LocationFound
if defined appLocation (
    echo Application is installed at: %appLocation%
    call :CopyToStartupFolder %appLocation%
) else (
    echo Application is not installed.
    echo Please install %appName% ...
)

goto :EOF

:CopyToStartupFolder
echo Copying the application to the startup folder...
set "startupFolder=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

xcopy /y "%appLocation%" "%startupFolder%"
if errorlevel 1 (
    echo Error occurred while copying the application.
    echo Please check if the destination folder exists and has proper permissions.
) else (
    echo %~1 copied to the startup folder successfully.
)

goto :EOF
