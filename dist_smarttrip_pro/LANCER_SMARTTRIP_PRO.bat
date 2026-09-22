@echo off
title SmartTrip Pro - Comparateur d Hebergements
chcp 65001 > nul
cls
echo ======================================================================
echo    SmartTrip Pro - Version Aboutie et Testable (@OPS)
echo ======================================================================
echo.
echo Demarrage du serveur local et ouverture du navigateur par defaut...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0lancer_smarttrip.ps1"
