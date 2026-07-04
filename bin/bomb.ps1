<#
 * @file        bomb.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Core gameplay mechanics module for Wallom.
 *              Handles mine placement (X1), wall bombs (X2),
 *              explosion detection, mine lifecycle, and bomb updates.
 *
 * @notes
 *              - X1 = Mine (limited count + timed expiration)
 *              - X2 = Wall generator (converts to wall after 1 turn)
 *              - This module is stateless except for Bomb list mutation
 *
 * @functions
 *              Add-Bomb()       -> places a bomb on the grid
 *              Get-BombAt()     -> retrieves bomb at a position
 *              Test-MineHit()   -> checks mine collision radius
 *              Update-Bombs()   -> advances bomb timers & applies effects
#>

# Mine rules
$MAX_MINES = 5
$MINE_LIFETIME = 8

# Place a bomb
function Add-Bomb {
    param(
        $Bombs,
        [int]$Pos,
        [string]$Type
    )

    $Type = $Type.ToUpper()

    # Limit X1 Mines
    if ($Type -eq "X1") {
        $mineCount = ($Bombs | Where-Object { $_.Type -eq "X1" }).Count
        if ($mineCount -ge $MAX_MINES) {
            return
        }
    }

    $Bombs.Add(@{
        Pos   = $Pos
        Type  = $Type
        Timer = 0
    })
}

# Returns bomb object on a cell (or $null)
function Get-BombAt {
    param(
        $Bombs,
        [int]$Pos
    )

    foreach ($b in $Bombs) {
        if ($b.Pos -eq $Pos) {
            return $b
        }
    }
    return $null
}

# Check if a position is inside an X1 mine radius
function Test-MineHit {
    param(
        $Bombs,
        [int]$Pos,
        [int]$Size
    )

    $x = $Pos % $Size
    $y = [math]::Floor($Pos / $Size)

    foreach ($b in $Bombs) {
        if ($b.Type -ne "X1") {
            continue
        }
        $bx = $b.Pos % $Size
        $by = [math]::Floor($b.Pos / $Size)
        if (
            [math]::Abs($bx - $x) -le 1 -and
            [math]::Abs($by - $y) -le 1
        ) {
            return $true
        }
    }
    return $false
}

# Advance bombs by one turn & X2 becomes wall after one turn
function Update-Bombs {
    param(
        $Bombs,
        $Walls
    )

    # increment timers
    foreach ($b in $Bombs) {
        $b.Timer++
    }

    for ($i = $Bombs.Count - 1; $i -ge 0; $i--) {
        $b = $Bombs[$i]

        # X2 becomes wall after 1 step
        if ($b.Type -eq "X2" -and $b.Timer -ge 1) {
            if (-not $Walls.Contains($b.Pos)) {
                $Walls.Add($b.Pos)
            }
            $Bombs.RemoveAt($i)
            continue
        }

        # X1 mines expire after 5 steps
        if ($b.Type -eq "X1" -and $b.Timer -ge $MINE_LIFETIME) {
            $Bombs.RemoveAt($i)
            continue
        }
    }
}