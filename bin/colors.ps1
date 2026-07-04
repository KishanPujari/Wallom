<#
 * @file        colors.ps1
 * @project     Wallom
 * @author      Kishan Pujari <kishanpujari.dev@gmail.com>
 * @license     MIT
 * @description ANSI color constants used across the Wallom terminal UI.
 *              Provides standardized escape sequences for consistent
 *              rendering of colored text in PowerShell terminal output.
 *
 * @notes
 *              - Uses ANSI escape codes (UTF-8 terminal required)
 *              - Shared across engine, grid, splash, and UI modules
 *              - Must be imported before any UI rendering
 *
 * @constants
 *              colorReset
 *              colorBlue
 *              colorRed
 *              colorPink
 *              colorGray
 *              colorGreen
 *              colorCyan
 *              colorYellow
 *              colorWhite
#>

$colorReset  = "$([char]27)[0m"
$colorBlue   = "$([char]27)[34m"
$colorRed    = "$([char]27)[31m"
$colorPink   = "$([char]27)[95m"
$colorGray   = "$([char]27)[90m"
$colorGreen  = "$([char]27)[32m"
$colorCyan   = "$([char]27)[36m"
$colorYellow = "$([char]27)[33m"
$colorWhite  = "$([char]27)[97m"