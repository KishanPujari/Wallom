<#
 * @file        ui_logo.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Branding and splash animation module for Wallom.
 *              Displays ASCII logo and loading animation during startup.
 *
 * @notes
 *              - Pure UI/branding module (no game logic)
 *              - Used by splash.ps1 during application boot
 *              - Requires colors.ps1 for ANSI styling
 *              - Enhances user experience with animated loading sequence
 *
 * @functions
 *              Show-Logo()             -> renders ASCII game logo
 *              Show-LoadingAnimation() -> displays startup animation frames
 *
 * @visual
 *              Displays "Wallom" ASCII branding with tagline:
 *              Escape. Survive. Repeat. (v1.1.0)
#>

function Show-Logo {
    $logo = @"
$colorGreen __      __  _____  .____    .____    $colorRed  ________      _____   
$colorGreen/  \    /  \/  _  \ |    |   |    |   $colorRed \_____  \    /     \  
$colorGreen\   \/\/   /  /_\  \|    |   |    |   $colorRed  /   |   \  /  \ /  \ 
$colorGreen \        /    |    \    |___|    |___$colorRed /    |    \/    Y    \
$colorGreen  \__/\  /\____|__  /_______ \_______ \$colorRed\_______  /\____|__  /
$colorGreen       \/         \/        \/       \/$colorRed       \/         \/                                                                                                         
"@
    Write-Host $colorGreen
    Write-Host $logo
    Write-Host $colorReset
    Write-Host "                $colorYellow Escape.$colorGreen Survive.$colorRed Repeat. $colorGray (v1.3.0)"
    Write-Host ""
}

function Show-LoadingAnimation {
    $frames = @(
        "Loading                         Starting application...   ",
        "Loading.                        Reading configuration...  ",
        "Loading..                       Verifying assets...       ",
        "Loading...                      Initializing game loop... ",
        "Loading.                        Preparing grid system...  ",
        "Loading..                       Loading player module...  ",
        "Loading...                      Launching main menu...    "
    )

    for ($i = 0; $i -lt 7; $i++) {
        Write-Host "`r$colorGray$($frames[$i % $frames.Count])$colorReset" -NoNewline
        Start-Sleep -Milliseconds 100
    }

    Start-Sleep -Milliseconds 300
    Write-Host "`r                                                                            " -NoNewline
}