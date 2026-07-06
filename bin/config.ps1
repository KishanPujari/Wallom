<#
 * @file        config.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description Global configuration system for Wallom.
 *              Handles persistent gameplay settings loaded from JSON,
 *              including bomb limits, mine lifetime, and future tuning parameters.
 *
 * @notes
 *              - Acts as single source of truth for game settings
 *              - Loads configuration from config.json if available
 *              - Falls back to default values on first run
 *              - Used by engine.ps1, enemy.ps1, and UI modules
 *              - Changes are persisted via Save-Config()
 *
 * @functions
 *              Save-Config() -> writes current configuration to config.json
#>

$Global:ConfigPath = "./config.json"

if (Test-Path $Global:ConfigPath) {
    $Global:Config = Get-Content $Global:ConfigPath | ConvertFrom-Json
}
else {
    $Global:Config = @{
        Bomb = @{
            MaxMines     = 5
            MineLifetime = 5
        }
    }
}

function Save-Config {
    $Global:Config | ConvertTo-Json -Depth 10 | Set-Content $Global:ConfigPath
}