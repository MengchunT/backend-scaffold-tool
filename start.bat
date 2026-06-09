@echo off
title Backend Scaffold Tool

echo.
echo =========================================
echo   Backend Scaffold Tool
echo =========================================
echo.

cd /d "%~dp0"

docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker Desktop is not running!
    echo Please start Docker Desktop first.
    pause
    exit /b 1
)

echo [1/3] Starting n8n...
docker-compose up -d
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start n8n!
    echo Please check docker-compose.yml and .env settings.
    pause
    exit /b 1
)

echo [2/3] Waiting for n8n to be ready...
set FORM_URL=http://localhost:5678/form/92cbe7f8-1ea0-412f-89fe-764f476de2de
set /a WAIT=0

:CHECK
timeout /t 2 /nobreak > nul
set /a WAIT+=2

curl -s -o nul -w "%%{http_code}" %FORM_URL% 2>nul | findstr "200" > nul
if %errorlevel% == 0 goto READY

if %WAIT% GEQ 60 (
    echo [WARNING] n8n took too long to start, opening browser anyway...
    goto OPEN
)

echo    Still waiting... (%WAIT%s)
goto CHECK

:READY
echo    n8n is ready! (%WAIT%s)

:OPEN
echo [3/3] Opening form...
start %FORM_URL%

echo.
echo =========================================
echo   Form is now open in your browser!
echo   Fill in the form to generate project.
echo   Press any key to stop n8n when done.
echo =========================================
echo.
pause

echo.
echo Stopping n8n...
docker-compose down

echo.
echo Done. n8n stopped.
timeout /t 2 /nobreak > nul