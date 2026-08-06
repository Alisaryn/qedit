@echo off
setlocal enabledelayedexpansion

rem CE blocks msbuild/dcc32 CLI. Only bds.exe -build works.
rem bds.exe can return non-zero even on success, so verify that it
rem produces a new target. Preserve the previous executable on failure.

rem Locate bds.exe: prefer the BDS env var Embarcadero sets at install,
rem then fall back to common Studio versions (newest first).
set "BDS_EXE="
if defined BDS if exist "%BDS%\bin\bds.exe" set "BDS_EXE=%BDS%\bin\bds.exe"
if not defined BDS_EXE (
    for %%v in (24.0 23.0 22.0 21.0 20.0) do (
        if not defined BDS_EXE (
            if exist "C:\Program Files (x86)\Embarcadero\Studio\%%v\bin\bds.exe" (
                set "BDS_EXE=C:\Program Files (x86)\Embarcadero\Studio\%%v\bin\bds.exe"
            )
        )
    )
)
if not defined BDS_EXE (
    echo [FAIL] bds.exe not found. Set the BDS env var or install RAD Studio.
    exit /b 2
)

set "REPO=%~dp0"
set "TARGET=%REPO%Qedit.exe"
set "BACKUP="

echo === Building Qedit (Qedit.dproj) ===
tasklist /FI "IMAGENAME eq Qedit.exe" 2>nul | findstr /I Qedit.exe >nul
if %ERRORLEVEL%==0 (
    echo [FAIL] Qedit.exe is running. Close it normally before building.
    exit /b 4
)

if exist "%TARGET%" (
    set "BACKUP=%TEMP%\Qedit-build-backup-%RANDOM%-%RANDOM%.exe"
    copy /b "%TARGET%" "!BACKUP!" >nul
    if errorlevel 1 (
        echo [FAIL] Could not preserve the existing Qedit.exe.
        exit /b 3
    )
    del /q "%TARGET%" 2>nul
    if exist "%TARGET%" (
        del /q "!BACKUP!" >nul 2>&1
        echo [FAIL] Could not prepare Qedit.exe for replacement. Check for file locks.
        exit /b 3
    )
)

"%BDS_EXE%" -pDelphi -build "%REPO%Qedit.dproj"

if not exist "%TARGET%" (
    echo [FAIL] Qedit.exe was not produced.
    if defined BACKUP (
        copy /b "!BACKUP!" "%TARGET%" >nul
        if errorlevel 1 (
            echo [FAIL] The previous Qedit.exe is safe at "!BACKUP!" but could not be restored.
            exit /b 5
        )
        del /q "!BACKUP!" >nul 2>&1
        echo [info] Restored the previous Qedit.exe.
    )
    if exist "%REPO%Qedit.err" (
        echo --- Compiler errors ^(Qedit.err^) ---
        findstr /C:"[dcc32 Error]" /C:"[dcc32 Fatal Error]" "%REPO%Qedit.err"
    )
    exit /b 1
)
if defined BACKUP del /q "!BACKUP!" >nul 2>&1
if exist "%REPO%Qedit.err" del /q "%REPO%Qedit.err" >nul 2>&1
echo [OK] Qedit built.
exit /b 0
