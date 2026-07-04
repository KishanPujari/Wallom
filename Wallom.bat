:: ============================================
:: @file        Wallom.bat
:: @project     Wallom
:: @author      Kishan Pujari <kishanpujari.dev@gmail.com>
:: @license     MIT
:: @description Launcher script for Wallom terminal game.
::              Starts the PowerShell splash screen and
::              initializes the game environment.
::
:: @notes       - Requires PowerShell installed on system
::              - ExecutionPolicy bypass used for local run
::              - Entry point: bin/splash.ps1
:: ============================================

@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0/bin/splash.ps1"
pause