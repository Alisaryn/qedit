@echo off
setlocal enabledelayedexpansion

rem CE blocks msbuild/dcc32 CLI. Only bds.exe -build works.
rem bds.exe can return non-zero even on success, so we verify by
rem deleting the target .exe beforehand and checking it reappears.

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

echo === Building Qedit (Qedit.dproj) ===
tasklist /FI "IMAGENAME eq Qedit.exe" 2>nul | findstr /I Qedit.exe >nul
if %ERRORLEVEL%==0 (
    echo [info] Qedit.exe is running — killing it.
    taskkill /F /IM Qedit.exe >nul 2>&1
    rem Wait for OS to release the file handle
    for /L %%i in (1,1,20) do (
        if not exist "%TARGET%" goto :deleted
        del /q "%TARGET%" >nul 2>&1
        if not exist "%TARGET%" goto :deleted
        ping -n 1 127.0.0.1 >nul
    )
)
if exist "%TARGET%" (
    del /q "%TARGET%" 2>nul
    if exist "%TARGET%" (
        echo [FAIL] Could not delete existing Qedit.exe even after kill. Check for file locks.
        exit /b 3
    )
)
:deleted

"%BDS_EXE%" -pDelphi -build "%REPO%Qedit.dproj"

if not exist "%TARGET%" (
    echo [FAIL] Qedit.exe was not produced.
    if exist "%REPO%Qedit.err" (
        echo --- Compiler errors ^(Qedit.err^) ---
        findstr /C:"[dcc32 Error]" /C:"[dcc32 Fatal Error]" "%REPO%Qedit.err"
    )
    exit /b 1
)
echo [OK] Qedit built.
exit /b 0
