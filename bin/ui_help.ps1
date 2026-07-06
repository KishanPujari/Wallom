<#
 * @file        ui_help.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Gameplay instructions screen for Wallom.
 *              Explains controls, objects, rules, and win conditions
 *              for the terminal-based grid game.
 *
 * @notes
 *              - Requires ui_logo.ps1 for branding header
 *              - Pure informational UI module (no state changes)
 *              - Accessed from splash.ps1 main menu
 *
 * @sections
 *              - Player & enemy overview
 *              - Movement controls
 *              - Game objects legend
 *              - Action commands
 *              - Game rules
 *              - Win condition
#>

. "./bin/ui_logo.ps1"

Clear-Host
Show-Logo

Write-Host ""
Write-Host "${colorYellow}# HOW TO PLAY ${colorReset}"
Write-Host ""

Write-Host "${colorWhite}YOU CONTROL:${colorBlue} O ${colorGray} (Top-Left Player)"
Write-Host "${colorWhite}ENEMY:${colorRed} X ${colorGray} (Bottom-Right AI)"
Write-Host ""

Write-Host "${colorYellow}MOVE CONTROLS:${colorReset}"
Write-Host "${colorWhite}U D L R${colorGray}       = Up, Down, Left, Right"
Write-Host "${colorWhite}UL UR DL DR${colorGray}   = Diagonal movement"
Write-Host ""

Write-Host "${colorYellow}OBJECTS:${colorReset}"
Write-Host "${colorGreen} $ ${colorGray} = Collectible (gives +1 score)"
Write-Host "${colorPink} * ${colorGray} = Mine (X1, duration & limit set in Settings)"
Write-Host "${colorGreen} # ${colorGray} = Wall Bomb (X2, becomes wall after 1 turn)"
Write-Host "${colorGray}####${colorGray} = Wall (blocked tile)"
Write-Host ""

Write-Host "${colorYellow}ACTIONS:${colorReset}"
Write-Host "${colorWhite}X1${colorGray} = Place Mine"
Write-Host "${colorWhite}X2${colorGray} = Place Wall Bomb"
Write-Host "${colorWhite}Q${colorGray}  = Quit Game"
Write-Host ""

Write-Host "${colorYellow}RULES:${colorReset}"
Write-Host "${colorGray}- Collect $ to increase score"
Write-Host "${colorGray}- Enemy dies if it steps on a mine"
Write-Host "${colorGray}- Mines expire based on Settings configuration"
Write-Host "${colorGray}- Max active mines defined in Settings"
Write-Host ""

Write-Host "${colorYellow}WIN CONDITION:${colorReset}"
Write-Host "${colorGray}- Eliminate enemy using mines"
Write-Host ""