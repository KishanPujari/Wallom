<#
 * @file        enemy.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Enemy AI decision engine for Wallom.
 *              Calculates optimal movement for enemy based on:
 *              player distance, wall collisions, mine danger zones,
 *              and controlled randomness for unpredictability.
 *
 * @notes
 *              - AI uses heuristic scoring (lower score = better move)
 *              - Includes Manhattan distance targeting behavior
 *              - Avoids walls and mine danger zones
 *              - Randomness simulates imperfect enemy behavior
 *
 * @strategy
 *              - Primary: Move toward player
 *              - Avoid: Walls + mine radius
 *              - Secondary: Random deviation for realism
 *
 * @functions
 *              Returns best move as PSCustomObject {x, y}
#>

param (
    [int]$ex,
    [int]$ey,
    [int]$px,
    [int]$py,
    $bombs,
    $walls,
    [int]$size
)

. ".\bin\bomb.ps1"

$moves = @(
    @{x = 0; y = -1 },
    @{x = 0; y = 1 },
    @{x = -1; y = 0 },
    @{x = 1; y = 0 },
    @{x = -1; y = -1 },
    @{x = 1; y = -1 },
    @{x = -1; y = 1 },
    @{x = 1; y = 1 }
)

$best = $null
$bestScore = [int]::MaxValue

foreach ($m in $moves) {
    $nx = $ex + $m.x
    $ny = $ey + $m.y

    if ($nx -lt 0 -or $nx -ge $size -or
        $ny -lt 0 -or $ny -ge $size) {
        continue
    }

    $pos = $ny * $size + $nx

    # Wall = impossible
    if ($walls.Contains($pos)) {
        continue
    }

    # Mine radius = dangerous
    $danger = Test-MineHit `
        -Bombs $bombs `
        -Pos $pos `
        -Size $size

    $dist = [math]::Abs($nx - $px) + [math]::Abs($ny - $py)

    $score = $dist

    if ($danger) {
        $score += 6
    }

    # Slight randomness
    $score += Get-Random -Minimum 0 -Maximum 2

    # Occasional mistake
    if ((Get-Random -Minimum 0 -Maximum 10) -eq 0) {
        $score += 10
    }

    if ($score -lt $bestScore) {
        $bestScore = $score
        $best = [PSCustomObject]@{
            x = $nx
            y = $ny
        }
    }
}
return $best