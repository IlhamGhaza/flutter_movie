@echo off
echo Updating SSL certificate hashes...
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Error: PowerShell is not installed or not in PATH.
    echo Please install PowerShell and try again.
    pause
    exit /b 1
)

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0update_certificate_hashes.ps1"

REM Pause to see the output
if "%errorlevel%" NEQ "0" (
    echo.
    echo Error: Failed to update certificate hashes.
    pause
    exit /b 1
) else (
    echo.
    echo Certificate hashes updated successfully!
    pause
)

exit /b 0
