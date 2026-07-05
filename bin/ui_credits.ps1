<#
 * @file        ui_credits.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Credits screen UI for Wallom.
 *              Displays project information, author details,
 *              licensing, features overview, and acknowledgements.
 *
 * @notes
 *              - Requires ui_logo.ps1 for branding header
 *              - Pure UI module (no game state interaction)
 *              - Executed from splash.ps1 menu system
 *
 * @sections
 *              - Project title
 *              - License information
 *              - Author details
 *              - Engine overview
 *              - Feature list
 *              - Special thanks
 *              - Repository placeholder
#>

. "./bin/ui_logo.ps1"

Clear-Host
Show-Logo
Write-Host "${colorYellow}# Open Source Terminal Game       ${colorReset}"
Write-Host ""

Write-Host "${colorGreen}License:${colorWhite} MIT License (Open Source)"
Write-Host "${colorGray}Free to use, modify, and distribute"
Write-Host ""

Write-Host "${colorYellow}Created By:${colorReset}"
Write-Host "${colorWhite}Kishan Pujari"
Write-Host ""

Write-Host "${colorYellow}Game Engine:${colorReset}"
Write-Host "${colorGray}PowerShell-based grid simulation engine"
Write-Host ""

Write-Host "${colorYellow}Features:${colorReset}"
Write-Host "${colorGray}- Real-time grid movement system"
Write-Host "${colorGray}- AI enemy path logic"
Write-Host "${colorGray}- Bomb & trap mechanics"
Write-Host "${colorGray}- Persistent JSON game state"
Write-Host "${colorGray}- Procedural map generation"
Write-Host ""

Write-Host "${colorYellow}Special Thanks:${colorReset}"
Write-Host "${colorGray}- Open-source community"
Write-Host "${colorGray}- PowerShell runtime"
Write-Host ""

Write-Host "${colorCyan}Repository:${colorWhite} https://github.com/KishanPujari/wallom"
Write-Host ""