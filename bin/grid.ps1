<#
 * @file        grid.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Rendering engine for Wallom terminal grid system.
 *              Responsible for drawing the game board, including:
 *              player, enemy, walls, bombs, and collectible points.
 *
 * @notes
 *              - Pure rendering module (no game state mutation)
 *              - Uses ANSI color definitions from colors.ps1
 *              - Depends on bomb.ps1 for bomb lookup logic
 *              - Grid is fixed-size (11x11)
 *
 * @functions
 *              (none exported) - script executes rendering directly
#>

param (
    [int]$ox,
    [int]$oy,
    [int]$ex,
    [int]$ey,
    $bombs,
    $walls,
    [int]$point
)

. ".\bin\bomb.ps1"
. ".\bin\colors.ps1"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$size = 11
$total = $size * $size

$player = $oy * $size + $ox
$enemy  = $ey * $size + $ex

$wallChar = "####"

Write-Host ("+" + ("----+" * $size))

for ($i = 0; $i -lt $total; $i++) {

    if ($i % $size -eq 0) {
        Write-Host "|" -NoNewline
    }

    $bomb = Get-BombAt -Bombs $bombs -Pos $i

    # PLAYER (BLUE)
    if ($i -eq $player) {
        Write-Host "$colorBlue O $colorReset |" -NoNewline
    }

    # ENEMY (RED)
    elseif ($i -eq $enemy) {
        Write-Host "$colorRed X $colorReset |" -NoNewline
    }

    # BOMBS
    elseif ($null -ne $bomb) {

        if ($bomb.Type -eq "X1") {
            Write-Host "$colorPink * $colorReset |" -NoNewline
        }
        elseif ($bomb.Type -eq "X2") {
            Write-Host "$colorGreen # $colorReset |" -NoNewline
        }
        else {
            Write-Host "? |" -NoNewline
        }
    }

    # POINT
    elseif ($i -eq $point) {
        Write-Host "$colorGreen $ $colorReset |" -NoNewline
    }

    # WALLS (BLOCKY GRAY)
    elseif ($walls.Contains($i)) {
        Write-Host "$colorGray$wallChar$colorReset|" -NoNewline
    }

    # EMPTY CELL
    else {
        Write-Host "    |" -NoNewline
    }

    if (($i + 1) % $size -eq 0) {
        Write-Host ""
        Write-Host ("+" + ("----+" * $size))
    }
}