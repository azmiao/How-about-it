@echo off
title AZMIAO Qsign Deamon
setlocal enabledelayedexpansion
set JAVA_HOME=.\jre
set "txlib_version=8.9.70"
set "host=127.0.0.1"
set "port=9876"

echo ########################################
echo           AZMIAO QSIGN DEAMON
echo                  V1.1.9
echo      Qsign API:http://!host!:!port!
echo      TXlib_version:%txlib_version% 
echo ########################################
timeout /t 3 > nul

:loop
curl.exe -I http://!host!:!port!/register?uin=12345678 >nul 2>nul
if %errorlevel% equ 0 (
    echo Qsign API is running.
    timeout /t 30 /nobreak >nul
    goto loop
) else (
    echo Qsign API is not running, Restarting...
    if defined pid (
      tasklist /fi "PID eq !pid!" | findstr /i "!pid!" >nul
        if %errorlevel% equ 0 (
          taskkill /F /PID !pid!))
    start "AZMIAO Qsign Program" cmd /c "bin\unidbg-fetch-qsign --basePath=txlib\%txlib_version%"
    timeout /t 15 /nobreak >nul
    for /f "tokens=5" %%A in ('netstat -ano ^| findstr ":!port!.*LISTENING"') do (
      set "pid=%%A")
    echo Qsign API running on processes with PID:!pid!.
    goto loop
)
