<#
.SYNOPSIS
    Reinstalls all apps in one go from a snapshot (like `brew bundle`), then optionally re-applies version pins.

.DESCRIPTION
    Input can be:
      - a winget export JSON (installed_apps.json, created by Export-WingetApps.ps1), restored with winget import;
      - a plain text list (*.txt) with one winget Id per line; empty lines and lines starting with # are ignored.
        Note: the `winget list` table (installed_apps.txt) is NOT a valid list: use the JSON or a hand-made Id list.

    Packages listed in -Pin are then reinstalled at the given version and pinned, because winget import
    does not restore pins. Without -Pin nothing is pinned.

.PARAMETER File
    Snapshot file (JSON from Export-WingetApps.ps1 or a text list of winget Ids).

.PARAMETER KeepVersions
    Install the exact versions recorded in the JSON instead of the latest ones.

.PARAMETER Pin
    Hashtable winget Id -> version to install and pin after the restore. Default: none.

.EXAMPLE
    .\Restore-WingetApps.ps1 -File E:\Backup\installed_apps.json

.EXAMPLE
    .\Restore-WingetApps.ps1 -File .\apps.txt

.EXAMPLE
    .\Restore-WingetApps.ps1 -File E:\Backup\installed_apps.json -KeepVersions -Pin @{ 'Publisher.App' = '1.2.3' }

.NOTES
    Already installed apps are skipped (--no-upgrade). Some installers may ask for elevation (UAC).
    Remove a pin later with: winget pin remove -e --id <Id>
#>
param(
    [Parameter(Mandatory)]
    [string]$File,
    [switch]$KeepVersions,
    [hashtable]$Pin = @{}
)

if (-not (Test-Path $File)) { throw "Snapshot not found: $File" }
$common = @('--accept-package-agreements', '--accept-source-agreements')

if ($File -like '*.json') {
    # winget import: one call for the whole snapshot
    $wgArgs = @('import', '-i', $File, '--no-upgrade', '--ignore-unavailable') + $common
    if (-not $KeepVersions) { $wgArgs += '--ignore-versions' }
    winget @wgArgs
}
else {
    # Plain Id list, Brewfile-style
    Get-Content $File | ForEach-Object { $_.Trim() } | Where-Object { $_ -and $_ -notmatch '^#' } |
        ForEach-Object {
            "=== $_ ==="
            winget install -e --id $_ @common
        }
}

# Re-apply pinned versions (winget import does not restore pins)
foreach ($id in $Pin.Keys) {
    $ver = $Pin[$id]
    "=== Pin $id $ver ==="
    winget install -e --id $id --version $ver --force @common
    winget pin add -e --id $id --version $ver
}

if ($Pin.Count) { winget pin list }
