<#
 * @file        engine.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Core runtime engine for Wallom terminal game.
 *              Handles game loop, player input, enemy AI execution,
 *              bomb mechanics, scoring system, collectible system,
 *              and persistent JSON-based game state storage.
 *
 * @notes
 *              - This file is the main game loop controller
 *              - All gameplay state updates happen here per tick
 *              - Persistence is handled via database.json through db.ps1
 *              - Grid rendering is delegated to grid.ps1
 *              - Enemy AI is delegated to enemy.ps1
 *
 * @functions
 *              IsBlocked()           -> checks wall collision
 *              New-PointPosition()   -> generates collectible position
 *              Print-MapID()         -> prints deterministic map fingerprint
#>

. ".\bin\bomb.ps1"
. ".\bin\colors.ps1"
. ".\bin\db.ps1"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Game ID (Unix Epoch)
$gameId = (Get-Date -UFormat %s).ToString()
$db = Load-DB
if ($null -eq $db) {
    $db = @{}
}
if (-not $db.ContainsKey($gameId)) {
    $db[$gameId] = @{}
}

if (-not $db.ContainsKey($gameId)) {
    $db[$gameId] = @{}
}

$gameState = $db[$gameId]

if ($null -eq $gameState) {
    $gameState = @{}
    $db[$gameId] = $gameState
}

$size = 11
$total = $size * $size

# player (top-left)
$x = 0
$y = 0

# enemy (bottom-right)
$ex = $size - 1
$ey = $size - 1

# Score & Collectible ($)
$score = 0
$point = -1

# bombs
$bombs = New-Object System.Collections.ArrayList

# walls (random, but safe)
$walls = New-Object System.Collections.Generic.List[int]

# Reserved cells that cannot contain walls
$reserved = @(
    # Player
    ($y * $size + $x),               # (0,0)
    ($y * $size + ($x + 1)),         # Right
    (($y + 1) * $size + $x),         # Down
    (($y + 1) * $size + ($x + 1)),   # Down-Right

    # Enemy
    ($ey * $size + $ex),                     # (10,10)
    ($ey * $size + ($ex - 1)),               # Left
    (($ey - 1) * $size + $ex),               # Up
    (($ey - 1) * $size + ($ex - 1))          # Up-Left
)

# Generate random walls
for ($i = 0; $i -lt 18; $i++) {
    do {
        $w = Get-Random -Min 0 -Max $total
    } while (
        $reserved -contains $w -or
        $walls.Contains($w)
    )
    $walls.Add($w)
}

# Sort walls
$walls = [System.Collections.Generic.List[int]](
    $walls | Sort-Object
)

# Freeze initial map state for ID generation
$initialWalls = New-Object System.Collections.Generic.List[int]
$walls | ForEach-Object { $initialWalls.Add($_) }

function IsBlocked($nx, $ny, $size, $walls) {
    $pos = $ny * $size + $nx
    return $walls.Contains($pos)
}

function New-PointPosition {
    param(
        [int]$Size,
        $Walls,
        $Bombs,
        [int]$PlayerPos,
        [int]$EnemyPos
    )

    $total = $Size * $Size
    do {
        $p = Get-Random -Min 0 -Max $total
    } while (
        $Walls.Contains($p) -or
        $p -eq $PlayerPos -or
        $p -eq $EnemyPos -or
        (Get-BombAt -Bombs $Bombs -Pos $p) -ne $null
    )
    return $p
}

function Print-MapID {
    $mapId = ($initialWalls | Where-Object { $_ -ne $null } | ForEach-Object { ([int]$_).ToString("D3") }) -join ""
    Write-Host "$colorWhite|${colorGray}$mapId$colorWhite|"
    Write-Host "$colorWhite+------------------------------------------------------+"
}

$point = New-PointPosition `
    -Size $size `
    -Walls $walls `
    -Bombs $bombs `
    -PlayerPos ($y * $size + $x) `
    -EnemyPos ($ey * $size + $ex)

$gameState.player = @{ x = $x; y = $y }
$gameState.enemy  = @{ x = $ex; y = $ey }
$gameState.score  = $score
$gameState.point  = $point
$gameState.walls = @($walls)
$gameState.bombs = @(
    $bombs | ForEach-Object {
        @{
            Pos   = $_.Pos
            Type  = $_.Type
            Timer = $_.Timer
        }
    }
)

while ($true) {

    Clear-Host

    # Render game world grid
    & (".\bin\grid.ps1") `
    -ox $x `
    -oy $y `
    -ex $ex `
    -ey $ey `
    -bombs $bombs `
    -walls $walls `
    -point $point
    Print-MapID

    Write-Host ""
    Write-Host "${colorYellow}Players: ${colorBlue}O ${colorGray}(YOU) ${colorRed}X ${colorGray}(ENEMY)"
    Write-Host "${colorYellow}Commands: ${colorWhite}U ${colorGray}(UP) ${colorWhite}D ${colorGray}(DOWN) ${colorWhite}L ${colorGray}(LEFT) ${colorWhite}R ${colorGray}(RIGHT) ${colorWhite}UL ${colorGray}(UP-LEFT) "
    Write-Host "    ${colorWhite}UR ${colorGray}(UP-RIGHT) ${colorWhite}DL ${colorGray}(DOWN-LEFT) ${colorWhite}DR ${colorGray}(DOWN-RIGHT)"
    Write-Host "    ${colorPink}X1 ${colorGray}(Mine *) ${colorPink}X2 ${colorGray}(WALL #) ${colorRed}Q ${colorGray}(QUIT)"
    Write-Host "${colorGreen}Score: ${colorWhite}$score"
    Write-Host ""
    $cmd = Read-Host "Move"

    # Player
    $nx = $x
    $ny = $y

    switch ($cmd.ToUpper()) {

        "U" { $ny-- }
        "D" { $ny++ }
        "L" { $nx-- }
        "R" { $nx++ }

        "UL" { $nx--; $ny-- }
        "UR" { $nx++; $ny-- }
        "DL" { $nx--; $ny++ }
        "DR" { $nx++; $ny++ }

        "X1" {

            Add-Bomb `
                -Bombs $bombs `
                -Pos ($y * $size + $x) `
                -Type "X1"

            Update-Bombs `
                -Bombs $bombs `
                -Walls $walls

            continue
        }

        "X2" {

            Add-Bomb `
                -Bombs $bombs `
                -Pos ($y * $size + $x) `
                -Type "X2"

            Update-Bombs `
                -Bombs $bombs `
                -Walls $walls

            continue
        }

        "Q" {
            exit
        }

        default {

            Write-Host "Invalid move"
            Start-Sleep -Milliseconds 500
            continue
        }
    }

    # boundary + wall check
    if ($nx -ge 0 -and $nx -lt $size -and $ny -ge 0 -and $ny -lt $size) {
        if (-not (IsBlocked $nx $ny $size $walls)) {
            $x = $nx; $y = $ny
        }
    }

    $playerPos = $y * $size + $x

    if ($playerPos -eq $point) {
        $score++
        $point = New-PointPosition `
            -Size $size `
            -Walls $walls `
            -Bombs $bombs `
            -PlayerPos $playerPos `
            -EnemyPos ($ey * $size + $ex)
    }

    Update-Bombs `
        -Bombs $bombs `
        -Walls $walls

    # Enemy move
    $best = & (".\bin\enemy.ps1") `
        -ex $ex `
        -ey $ey `
        -px $x `
        -py $y `
        -bombs $bombs `
        -walls $walls `
        -size $size

    if ($null -ne $best) {

        $enemyPos = $best.y * $size + $best.x

        # Enemy walks into a mine
        if (Test-MineHit -Bombs $bombs -Pos $enemyPos -Size $size) {

            $ex = $best.x
            $ey = $best.y

            Clear-Host

            & ".\bin\grid.ps1" `
                -ox $x `
                -oy $y `
                -ex $ex `
                -ey $ey `
                -bombs $bombs `
                -walls $walls
            Print-MapID

            Write-Host ""
            Write-Host "ENEMY TRIGGERED A MINE!"
            Write-Host "LEVEL COMPLETE!"
            exit
        }

        # Normal movement
        $ex = $best.x
        $ey = $best.y
    }

    $db[$gameId] = @{
        created = $db[$gameId].created
        player  = @{ x = $x; y = $y }
        enemy   = @{ x = $ex; y = $ey }
        score   = $score
        point   = $point
        walls   = @($walls)
        bombs   = @(
            $bombs | ForEach-Object {
                @{
                    Pos   = $_.Pos
                    Type  = $_.Type
                    Timer = $_.Timer
                }
            }
        )
    }
    Save-DB $db
}