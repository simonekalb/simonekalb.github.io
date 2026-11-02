<#
.SYNOPSIS
    Collects read-only diagnostics for crashes of the Windows Settings app (SystemSettings.exe).

.DESCRIPTION
    First-pass triage when Settings (or one of its pages) crashes. The script changes nothing.
    It writes a transcript with:
      - OS build (DisplayVersion, CurrentBuild, UBR)
      - Last Application Error / WER events (ID 1000/1001/1002) for SystemSettings / ImmersiveControlPanel,
        including the faulting module, exception code and offset (the key clue)
      - Explorer policies that hide/block Settings pages (SettingsPageVisibility, NoControlPanel)
      - State of the Settings app package and of any broken AppX package
      - State of key services (AppX, ClipSVC, StateRepository, Windows Update, TokenBroker, UserManager)
      - DISM /ScanHealth and SFC /VERIFYONLY results (no repair)

    Run it from an elevated PowerShell, otherwise the AppX, DISM and SFC checks fail with "Access denied".

.PARAMETER OutFile
    Transcript path. Default: %TEMP%\Get-SettingsCrashDiagnostics_<yyyyMMdd-HHmmss>.log

.EXAMPLE
    .\Get-SettingsCrashDiagnostics.ps1

.EXAMPLE
    .\Get-SettingsCrashDiagnostics.ps1 -OutFile "$env:USERPROFILE\Desktop\settings-crash.log"

.NOTES
    Duration: 5-15 minutes (DISM and SFC).
#>
#Requires -RunAsAdministrator
param(
    [string]$OutFile = (Join-Path ([IO.Path]::GetTempPath()) ('Get-SettingsCrashDiagnostics_{0:yyyyMMdd-HHmmss}.log' -f (Get-Date)))
)

Start-Transcript -Path $OutFile -Force

"=== OS build ==="
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' |
    Select-Object DisplayVersion, CurrentBuild, UBR | Format-Table -AutoSize

"=== Crash events (Application Error / WER) ==="
Get-WinEvent -FilterHashtable @{ LogName = 'Application'; Id = 1000, 1001, 1002 } -MaxEvents 300 -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'SystemSettings|ImmersiveControlPanel' } |
    Select-Object -First 8 | Format-List TimeCreated, Id, Message

"=== Settings policies ==="
foreach ($k in 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer',
               'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer') {
    $k
    Get-ItemProperty $k -ErrorAction SilentlyContinue | Select-Object SettingsPageVisibility, NoControlPanel
}

"=== Settings app package ==="
Get-AppxPackage -AllUsers *ImmersiveControlPanel* | Format-List Name, Version, Status, InstallLocation

"=== Broken AppX packages ==="
Get-AppxPackage -AllUsers | Where-Object { $_.Status -ne 'Ok' } | Format-Table Name, Status -AutoSize

"=== Key services ==="
Get-Service AppXSvc, ClipSVC, StateRepository, wuauserv, TokenBroker, UserManager -ErrorAction SilentlyContinue |
    Format-Table Name, Status, StartType -AutoSize

# Native tools: pipe through Out-String so their output lands in the transcript
"=== Component store health (DISM /ScanHealth) ==="
DISM /Online /Cleanup-Image /ScanHealth | Out-String

"=== System files (SFC /VERIFYONLY, no repair) ==="
sfc /verifyonly | Out-String

Stop-Transcript
