<#
 * @file        splash.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Main entry UI controller for Wallom.
 *              Handles splash screen, logo rendering, main menu navigation,
 *              and routing to game engine and UI modules.
 *
 * @notes
 *              - Acts as the application entry point UI layer
 *              - Loads logo and color system before rendering menu
 *              - Controls navigation between engine, help, credits, and exit
 *              - Uses blocking input loop for menu selection
 *
 * @functions
 *              Show-MainMenu()
 *              Show-InvalidInput()
 *              GoBackToMainMenu()
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

. "./bin/colors.ps1"
. "./bin/ui_logo.ps1"

$Host.UI.RawUI.WindowTitle = "Wallom"

$invalidInput = $null
function Show-MainMenu {
    Write-Host "`r${colorCyan}   ${colorYellow}[*]${colorWhite} Main Menu                      ${colorReset}"
    Write-Host ""
    Write-Host "${colorCyan}   ${colorYellow}[1]${colorWhite} Start Game                    ${colorReset}"
    Write-Host "${colorCyan}   ${colorYellow}[2]${colorWhite} How to Play                   ${colorReset}"
    Write-Host "${colorCyan}   ${colorYellow}[3]${colorWhite} Settings                      ${colorReset}"
    Write-Host "${colorCyan}   ${colorYellow}[4]${colorWhite} Credits                       ${colorReset}"
    Write-Host "${colorCyan}   ${colorYellow}[0]${colorWhite} Exit                          ${colorReset}"
    Write-Host ""
}

function Show-InvalidInput {
    if ($null -ne $invalidInput) {
        Write-Host "${colorRed}[ERROR]: Invalid input ${colorWhite}'$invalidInput'${colorRed}, Option not recognized. Please try again.${colorReset}"
    }
}

function GoBackToMainMenu {
    Write-Host "${colorGray}Press any key to return to menu...${colorReset}"
    [void][System.Console]::ReadKey($true)
    Write-Host ""
}

$running = $true
$firstRun = $true

while ($running) {
    Clear-Host
    Show-Logo
    if ($firstRun) {
        Show-LoadingAnimation
        $firstRun = $false
    }
    Show-MainMenu
    Show-InvalidInput

    $choice = Read-Host "Select"
    
    switch ($choice) {
        "1" {
            ./bin/engine.ps1
            $running = $false
        }

        "2" {
            ./bin/ui_help.ps1
            GoBackToMainMenu
        }

        "3" {
            ./bin/ui_settings.ps1
            GoBackToMainMenu
        }

        "4" {
            ./bin/ui_credits.ps1
            GoBackToMainMenu
        }

        "0" {
            $running = $false
            exit
        }

        default {
            $invalidInput = $choice
        }
    }
}