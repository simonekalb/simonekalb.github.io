<#
.SYNOPSIS
    Snapshots the installed apps for a later one-shot reinstall (winget export).

.DESCRIPTION
    Creates two files in -OutDir:
      - installed_apps.json : machine-readable list (winget sources only, with versions).
                              Input for Restore-WingetApps.ps1 / winget import. The "Brewfile" of Windows.
      - installed_apps.txt  : human-readable `winget list` table + `wsl --version` (documentation only).

.PARAMETER OutDir
    Destination folder. Default: the temp folder (%TEMP%). Before a reinstall, pass a folder that
    survives it (USB stick, network share, cloud folder).

.EXAMPLE
    .\Export-WingetApps.ps1

.EXAMPLE
    .\Export-WingetApps.ps1 -OutDir E:\Backup

.NOTES
    Apps not available in a winget source (ARP/MSIX entries such as drivers) are not exported to the JSON.
    Existing files with the same names are overwritten.
#>
param(
    [string]$OutDir = [IO.Path]::GetTempPath()
)

$json = Join-Path $OutDir 'installed_apps.json'
$txt  = Join-Path $OutDir 'installed_apps.txt'

winget export -o $json --include-versions --accept-source-agreements

# Human-readable snapshot; wsl --version prints UTF-16, so capture it as text first
winget list --accept-source-agreements | Out-File $txt -Encoding utf8
(wsl --version 2>$null) -replace "`0", '' | Out-File $txt -Append -Encoding utf8

"Snapshot written:`n  $json`n  $txt"
