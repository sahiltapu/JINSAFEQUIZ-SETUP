@echo off
set "appName=JINSAFEQUIZ.appref-ms"
set "setupFile=%~dp0setup.exe"

call :CheckApplication %appName%
goto :EOF

:CheckApplication
echo Checking if %appName% is present in the system...
set "appLocation="
for /f "delims=" %%A in ('where /R %SystemDrive%\ "%~1" 2^>nul') do (
    set "appLocation=%%A"
    goto :LocationFound
)

:LocationFound
if defined appLocation (
    echo Application is installed at: %appLocation%
    call :CopyToStartupFolder %appLocation%
    echo Application added to startup successfully.
    call :ConfigurePowerSettings
) else (
    echo Application is not installed.
    echo Please install %appName% ...
    call :InstallSetup
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

:InstallSetup
echo Installing setup.exe...
start "" "%setupFile%"
echo Installation started. Waiting for the installation to complete...
timeout /t 30 /nobreak >nul
echo Installation completed.
call :CheckApplication %appName%
goto :EOF

:ConfigurePowerSettings
echo Configuring power settings to open the application on wake-up...
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_SLEEP 4f971e89-eebd-4455-a8de-9e59040e7347 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 %appLocation%
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_SLEEP 4f971e89-eebd-4455-a8de-9e59040e7347 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 %appLocation%
echo Power settings configured successfully.
goto :EOF
