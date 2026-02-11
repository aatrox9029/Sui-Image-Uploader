@echo off
setlocal

cd /d "%~dp0"
set PORT=5500
set URL=http://localhost:%PORT%/index.html

echo Starting local server in "%CD%"
echo URL: %URL%
echo Press Ctrl+C to stop the server.
echo.

where python >nul 2>&1
if %ERRORLEVEL%==0 (
  start "" %URL%
  python -m http.server %PORT%
  goto :eof
)

where py >nul 2>&1
if %ERRORLEVEL%==0 (
  start "" %URL%
  py -m http.server %PORT%
  goto :eof
)

where node >nul 2>&1
if %ERRORLEVEL%==0 (
  where npx >nul 2>&1
  if %ERRORLEVEL%==0 (
    start "" %URL%
    npx --yes http-server -p %PORT% -c-1 .
    goto :eof
  )
)

echo Could not find Python or Node.js on PATH.
echo Install one of the following, then run this file again:
echo   - Python: https://www.python.org/downloads/
echo   - Node.js: https://nodejs.org/
pause
