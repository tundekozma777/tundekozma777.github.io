@echo off
setlocal
set "SCRIPT=%~dp0FIX-CHARACTERS.ps1"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"
