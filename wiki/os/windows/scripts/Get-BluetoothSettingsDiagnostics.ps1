<#
.SYNOPSIS
    Read-only diagnostics for the Bluetooth & devices stack, used when Settings > Bluetooth crashes.

.DESCRIPTION
    Second-pass triage, run after Get-SettingsCrashDiagnostics.ps1 points to the Devices handler
    (faulting module SettingsHandlers_Devices.dll). The script changes nothing. It reports:
      - Whether the session is elevated
      - Bluetooth and device-association services (bthserv, BTAGService, DeviceAssociationService,
        DsmSvc, per-user services such as BluetoothUserService_*), with status and start type
      - All Bluetooth PnP devices (paired devices and their GATT services) and any device not in OK state
      - Settings app package and broken AppX packages
      - Scheduled tasks that launch SystemSettings / ms-settings
      - DISM /ScanHealth and SFC /VERIFYONLY

.PARAMETER OutFile
    Transcript path. Default: %TEMP%\Get-BluetoothSettingsDiagnostics_<yyyyMMdd-HHmmss>.log

.EXAMPLE
    .\Get-BluetoothSettingsDiagnostics.ps1

.NOTES
    Quick manual test before running it (Win + R): ms-settings:about, ms-settings:display, ms-settings:bluetooth.
    If only the Bluetooth page crashes, the Devices handler is the culprit.
#>
#Requires -RunAsAdministrator
param(
    [string]$OutFile = (Join-Path ([IO.Path]::GetTempPath()) ('Get-BluetoothSettingsDiagnostics_{0:yyyyMMdd-HHmmss}.log' -f (Get-Date)))
)

Start-Transcript -Path $OutFile -Force

"=== Admin? ==="
([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

"=== Bluetooth / device services ==="
Get-Service bthserv, BthAvctpSvc, BTAGService, DeviceAssociationService, DsmSvc, DeviceInstall, NcbService, PlugPlay,
    'DeviceAssociationBrokerSvc_*', 'DevicesFlowUserSvc_*', 'BluetoothUserService_*' -ErrorAction SilentlyContinue |
    Format-Table Name, Status, StartType -AutoSize

"=== Bluetooth devices ==="
Get-PnpDevice -Class Bluetooth -ErrorAction SilentlyContinue | Format-Table Status, FriendlyName, InstanceId -AutoSize

"=== Present devices not in OK state ==="
Get-PnpDevice -PresentOnly | Where-Object Status -ne 'OK' | Format-Table Status, Class, FriendlyName -AutoSize

"=== Settings app package ==="
Get-AppxPackage -AllUsers *ImmersiveControlPanel* | Format-List Name, Version, Status
Get-AppxPackage -AllUsers | Where-Object { $_.Status -ne 'Ok' } | Format-Table Name, Status -AutoSize

"=== Scheduled tasks launching Settings ==="
Get-ScheduledTask | Where-Object { ($_.Actions.Execute -join ' ') -match 'SystemSettings|ms-settings' } |
    Format-Table TaskPath, TaskName, State -AutoSize

"=== Component store / system files ==="
DISM /Online /Cleanup-Image /ScanHealth | Out-String
sfc /verifyonly | Out-String

Stop-Transcript
