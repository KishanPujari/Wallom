<#
 * @file        db.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Persistence layer for Wallom game engine.
 *              Handles loading, saving, and managing game sessions
 *              using a JSON-based lightweight database (database.json).
 *
 * @notes
 *              - Stores multiple game sessions using gameId keys
 *              - Converts JSON objects into safe PowerShell hashtables
 *              - Used by engine.ps1 for real-time state persistence
 *              - Designed to be simple, file-based storage system
 *
 * @functions
 *              Load-DB()           -> Loads database.json into hashtable
 *              Save-DB($db)        -> Writes current DB state to JSON file
 *              Get-OrCreateGame()  -> Initializes or retrieves game session
#>

$script:dbPath = ".\database.json"

function Load-DB {
    if (-not (Test-Path $script:dbPath)) {
        return @{}
    }

    $content = Get-Content $script:dbPath -Raw
    if ([string]::IsNullOrWhiteSpace($content)) {
        return @{}
    }

    $obj = ConvertFrom-Json $content
    $hash = @{}

    foreach ($p in $obj.PSObject.Properties) {
        $hash[$p.Name] = $p.Value
    }
    return $hash
}

function Save-DB($db) {
    $json = ConvertTo-Json -InputObject $db -Depth 20
    Set-Content -Path $script:dbPath -Value $json -Encoding UTF8
}

function Get-OrCreateGame($db, $gameId) {
    if (-not $db.ContainsKey($gameId)) {
        $db[$gameId] = @{
            created = (Get-Date).ToString()
        }
    }
    return $db[$gameId]
}