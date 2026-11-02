<#
.SYNOPSIS
    Repairs the Windows component store (DISM) and system files (SFC), with an optional offline source.

.DESCRIPTION
    Standard repair sequence for a damaged Windows installation:
      1. DISM /CheckHealth      - quick check of the corruption flag
      2. DISM /ScanHealth       - full scan of the component store (WinSxS)
      3. DISM /RestoreHealth    - repair, from Windows Update or from an install.wim/esd (-Source)
      4. SFC /SCANNOW           - repair protected system files from the (now healthy) store
      5. Extracts the SFC [SR] lines of CBS.log into <transcript name>_sfc-details.log next to the transcript

    If it does not fix the problem, the next step is the in-place repair:
    Win + R -> ms-settings:recovery -> "Fix problems using Windows Update" -> Reinstall now
    (keeps apps, settings and files).

.PARAMETER Source
    Optional repair source, e.g. 'wim:D:\sources\install.wim:6' (mounted ISO, image index 6).
    Get the index with: DISM /Get-WimInfo /WimFile:D:\sources\install.wim
    When set, Windows Update is not used (/LimitAccess).

.PARAMETER OutFile
    Transcript path. Default: %TEMP%\Repair-WindowsImage_<yyyyMMdd-HHmmss>.log

.EXAMPLE
    .\Repair-WindowsImage.ps1

.EXAMPLE
    .\Repair-WindowsImage.ps1 -Source 'wim:D:\sources\install.wim:6'

.NOTES
    Duration: 15-45 minutes. Reboot afterwards.
#>
#Requires -RunAsAdministrator
param(
    [string]$Source,
    [string]$OutFile = (Join-Path ([IO.Path]::GetTempPath()) ('Repair-WindowsImage_{0:yyyyMMdd-HHmmss}.log' -f (Get-Date)))
)

Start-Transcript -Path $OutFile -Force

"=== DISM /CheckHealth ==="
DISM /Online /Cleanup-Image /CheckHealth | Out-String

"=== DISM /ScanHealth ==="
DISM /Online /Cleanup-Image /ScanHealth | Out-String

"=== DISM /RestoreHealth ==="
if ($Source) {
    DISM /Online /Cleanup-Image /RestoreHealth /Source:$Source /LimitAccess | Out-String
} else {
    DISM /Online /Cleanup-Image /RestoreHealth | Out-String
}

"=== SFC /SCANNOW ==="
sfc /scannow | Out-String

# SFC details: only the [SR] (System Repair) lines of CBS.log, named after the transcript
$fullOut = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutFile)
$sfcLog = Join-Path ([IO.Path]::GetDirectoryName($fullOut)) ([IO.Path]::GetFileNameWithoutExtension($fullOut) + '_sfc-details.log')
Select-String -Path "$env:windir\Logs\CBS\CBS.log" -Pattern '\[SR\]' | ForEach-Object Line | Set-Content $sfcLog
"SFC details saved to: $sfcLog"

Stop-Transcript
"Done. Reboot the PC."
