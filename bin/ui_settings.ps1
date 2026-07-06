<#
 * @file        ui_settings.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Interactive settings menu for Wallom.
 *              Allows users to view and modify gameplay configuration
 *              such as bomb limits and mine lifetime.
 *
 * @notes
 *              - UI-only module for editing global configuration
 *              - Reads and modifies values from config.ps1
 *              - Persists changes using Save-Config()
 *              - Supports save, cancel, and per-setting updates
 *
 * @functions
 *              Show-SettingsMenu() -> renders settings UI
#>

. "./bin/ui_logo.ps1"
. "./bin/config.ps1"

function Show-SettingsMenu {
    Clear-Host
    Show-Logo

    Write-Host ""
    Write-Host "${colorYellow}# SETTINGS ${colorReset}"
    Write-Host ""

    Write-Host "${colorWhite}[1] Max Mines         : ${colorGreen}$($Global:Config.Bomb.MaxMines)${colorReset}"
    Write-Host "${colorWhite}[2] Mine Lifetime     : ${colorGreen}$($Global:Config.Bomb.MineLifetime)${colorReset}"
    Write-Host ""
    Write-Host "${colorWhite}[0] Save & Exit"
    Write-Host "${colorWhite}[9] Cancel & Exit"
    Write-Host ""
}

$running = $true

while ($running) {

    Show-SettingsMenu
    $choice = Read-Host "Select option"

    switch ($choice) {
        "1" {
            $newVal = Read-Host "Enter Max Mines (current: $($Global:Config.Bomb.MaxMines))"

            if ($newVal -match '^\d+$' -and [int]$newVal -gt 0) {
                $Global:Config.Bomb.MaxMines = [int]$newVal
            }
            else {
                Write-Host "${colorRed}[ERROR]: Invalid number${colorReset}"
                Start-Sleep -Milliseconds 800
            }
        }

        "2" {
            $newVal = Read-Host "Enter Mine Lifetime (current: $($Global:Config.Bomb.MineLifetime))"

            if ($newVal -match '^\d+$' -and [int]$newVal -gt 0) {
                $Global:Config.Bomb.MineLifetime = [int]$newVal
            }
            else {
                Write-Host "${colorRed}[ERROR]: Invalid number${colorReset}"
                Start-Sleep -Milliseconds 800
            }
        }

        "0" {
            Save-Config
            $running = $false
        }

        "9" {
            $Global:Config = Get-Content $Global:ConfigPath | ConvertFrom-Json
            $running = $false
        }

        default {
            Write-Host "${colorRed}[ERROR]: Invalid input '$choice'${colorReset}"
            Start-Sleep -Milliseconds 800
        }
    }
}