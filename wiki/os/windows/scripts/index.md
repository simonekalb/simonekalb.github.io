---
title: "Windows scripts"
---
{% raw %}

PowerShell scripts for Windows 10/11, grouped by purpose: **Installation**, **Maintenance** and
**Repair**. They are generic: nothing in them is tied to a specific machine, user or device, and
every machine-dependent value is either detected at run time or passed as a parameter.

Each script has full built-in help: `Get-Help .\<Script>.ps1 -Full`.

## Quick start

```powershell
# Allow local scripts for the current user, then unblock the downloaded files
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
Get-ChildItem .\*.ps1 | Unblock-File
```

- **Admin**: scripts marked ✅ declare `#Requires -RunAsAdministrator` and must run in an elevated
  PowerShell (Win + X → Terminal (Admin)).
- **Output files**: scripts that write a log default to the temp folder (`%TEMP%`), with a name made
  of the script name and a timestamp, e.g. `%TEMP%\Repair-WindowsImage_20261102-143000.log`. Related
  files share that name with a suffix (`…_sfc-details.log`, `…_BTHPORT-backup.reg`). Pass `-OutFile`
  (or `-OutDir`) to choose another location. Open the temp folder with `explorer $env:TEMP`.

## Overview

| Category | Script | Admin | Changes the system | Output |
|---|---|---|---|---|
| Installation | [Install-DriverTools.ps1](./Install-DriverTools.ps1) | No | Yes | — |
| Installation | [Restore-WingetApps.ps1](./Restore-WingetApps.ps1) | No | Yes | — |
| Installation | [Remove-OneDrive.ps1](./Remove-OneDrive.ps1) | ✅ | Yes | — |
| Maintenance | [Export-WingetApps.ps1](./Export-WingetApps.ps1) | No | No | `installed_apps.json` + `installed_apps.txt` |
| Maintenance | [Test-WUDriverPolicy.ps1](./Test-WUDriverPolicy.ps1) | Only with `-Set` | Only with `-Set` | — |
| Repair | [Get-SettingsCrashDiagnostics.ps1](./Get-SettingsCrashDiagnostics.ps1) | ✅ | No | log |
| Repair | [Get-BluetoothSettingsDiagnostics.ps1](./Get-BluetoothSettingsDiagnostics.ps1) | ✅ | No | log |
| Repair | [Test-BluetoothAdapterBisect.ps1](./Test-BluetoothAdapterBisect.ps1) | ✅ | Temporarily (~15 s) | log |
| Repair | [Remove-BluetoothDeviceNode.ps1](./Remove-BluetoothDeviceNode.ps1) | ✅ | Yes | — |
| Repair | [Remove-BluetoothPairing.ps1](./Remove-BluetoothPairing.ps1) | ✅ | Yes | log + registry backup |
| Repair | [Repair-WindowsImage.ps1](./Repair-WindowsImage.ps1) | ✅ | Yes | log + SFC details |

## Installation

Scripts for setting up a freshly installed (or reinstalled) Windows.

### Install-DriverTools.ps1
Installs the driver-update tools of the hardware vendors found on the machine.
- Detects the vendors read-only from the CPU manufacturer and the present devices
  (Intel: PCI vendor `8086` / USB vendor `8087`; AMD: AMD CPU or PCI vendor `1002` graphics).
- **Intel** → installs *Intel Driver & Support Assistant* with winget.
- **AMD** → opens the official download page of the *AMD Auto-Detect and Install Tool* (not on winget).
- `-Vendor Intel|AMD` skips detection. With no Intel or AMD hardware it warns and does nothing.

```powershell
.\Install-DriverTools.ps1
.\Install-DriverTools.ps1 -Vendor Intel
```

### Restore-WingetApps.ps1
Reinstalls all apps in one go from a snapshot, like `brew bundle` on macOS.
- `-File` (required): a JSON created by [Export-WingetApps.ps1](#export-wingetappsps1), restored with
  `winget import`, or a plain text file with one winget Id per line (`#` starts a comment).
- Apps already installed are skipped. By default the latest versions are installed; `-KeepVersions`
  installs the versions recorded in the JSON.
- `-Pin @{ '<Id>' = '<version>' }` reinstalls those packages at the given version and pins them
  (`winget import` does not restore pins). Without `-Pin` nothing is pinned.

```powershell
.\Restore-WingetApps.ps1 -File E:\Backup\installed_apps.json
.\Restore-WingetApps.ps1 -File .\apps.txt
.\Restore-WingetApps.ps1 -File E:\Backup\installed_apps.json -Pin @{ 'Publisher.App' = '1.2.3' }
```

### Remove-OneDrive.ps1
Uninstalls OneDrive and keeps it from coming back.
1. Safety check: stops if Desktop, Documents or Pictures are redirected into OneDrive (Known Folder
   Move): move them back first, or use `-Force`.
2. Stops OneDrive and uninstalls it with winget (fallback: `OneDriveSetup.exe /uninstall`).
3. Sets the policy `DisableFileSyncNGSC = 1`, so updates cannot re-enable it.
4. Hides OneDrive from the Explorer navigation pane.

Undo: set `DisableFileSyncNGSC` to `0` (`HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive`) and run
`winget install -e --id Microsoft.OneDrive`.

## Maintenance

Routine checks and snapshots; they change nothing unless asked.

### Export-WingetApps.ps1
Takes a snapshot of the installed apps, input for [Restore-WingetApps.ps1](#restore-wingetappsps1).
- `installed_apps.json`: `winget export` with versions (only apps available in a winget source).
- `installed_apps.txt`: human-readable `winget list` table plus `wsl --version`, for documentation only
  (not valid as restore input).
- `-OutDir` defaults to `%TEMP%`. **Before reinstalling Windows, save the snapshot somewhere that
  survives the reinstall** (USB stick, network share, cloud folder). Existing files are overwritten.

```powershell
.\Export-WingetApps.ps1 -OutDir E:\Backup
```

### Test-WUDriverPolicy.ps1
Shows whether Windows Update is allowed to install drivers (policy `ExcludeWUDriversInQualityUpdate`
under `HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate`). Read-only by default.
- `-Set Exclude` writes `1` (drivers excluded), `-Set Allow` removes the value. Both need admin.

```powershell
.\Test-WUDriverPolicy.ps1
.\Test-WUDriverPolicy.ps1 -Set Allow
```

## Repair

Troubleshooting and repair. The first five scripts form a path for a **Settings app that crashes**
(especially Settings > Bluetooth); run them in order and stop as soon as the cause is found.

### Get-SettingsCrashDiagnostics.ps1 — step 1
Read-only first triage of `SystemSettings.exe` crashes: OS build, the latest crash events with the
faulting module (the key clue), policies that hide Settings pages, the Settings app package and broken
AppX packages, key services, DISM `/ScanHealth` and SFC `/VERIFYONLY` (no repair). Takes 5–15 minutes.

### Get-BluetoothSettingsDiagnostics.ps1 — step 2
Read-only second pass when step 1 points to the Devices handler (`SettingsHandlers_Devices.dll`):
Bluetooth and device-association services, Bluetooth devices, devices not in OK state, the Settings
package, scheduled tasks that open Settings, DISM/SFC scan.

### Remove-BluetoothDeviceNode.ps1 — step 3
Without parameters lists the Bluetooth device nodes and their instance IDs; with `-InstanceId` removes
them with `pnputil` (including their GATT services). It does **not** unpair: the device usually comes
back after a reboot. Removing a Bluetooth keyboard/mouse disconnects it: keep a USB one at hand.

```powershell
.\Remove-BluetoothDeviceNode.ps1
.\Remove-BluetoothDeviceNode.ps1 -InstanceId 'BTHLE\DEV_AABBCCDDEEFF\8&1A2B3C4D&0&AABBCCDDEEFF'
```

### Test-BluetoothAdapterBisect.ps1 — step 4
Tells an adapter/driver problem apart from a stored-device-data problem: reports the stored pairings,
the adapter driver and the latest crash, then disables the adapter for about 15 seconds, opens
Settings > Bluetooth and checks whether Settings survives. The adapter is always re-enabled.
- Settings survives with the adapter off → adapter or driver problem.
- Settings still crashes → stored device data or the Settings handler.

The adapter is detected automatically (the only Bluetooth device on the USB or PCI bus). If none or
several are found, the script stops before changing anything and lists the candidates: pass one with
`-AdapterInstanceId`.

### Remove-BluetoothPairing.ps1 — step 5
Unpairs devices through the Windows API (`BluetoothRemoveDevice`), one at a time, opening Settings
after each removal and stopping at the first one whose removal fixes the crash (`-NoTest` only unpairs).
- First exports a backup of `HKLM\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters` next to the
  log (restore with `reg import <file>`).
- `-MacAddress` accepts addresses with or without `:`/`-`; default: all classic pairings in the registry.
- Return code `0` = unpaired, `1168` = not found (the stack does not consider the device paired).

```powershell
.\Remove-BluetoothPairing.ps1
.\Remove-BluetoothPairing.ps1 -MacAddress 'aabbccddeeff', '[REDACTED]' -NoTest
```

### Repair-WindowsImage.ps1
Standard repair of a damaged Windows installation: DISM `/CheckHealth` → `/ScanHealth` →
`/RestoreHealth` → SFC `/SCANNOW`, then saves the SFC `[SR]` lines of `CBS.log` next to the log.
Takes 15–45 minutes; reboot afterwards.
- `-Source 'wim:D:\sources\install.wim:6'` repairs from a mounted ISO instead of Windows Update
  (get the image index with `DISM /Get-WimInfo /WimFile:D:\sources\install.wim`).
- If it does not help: in-place repair via `ms-settings:recovery` → *Fix problems using Windows
  Update* → *Reinstall now* (keeps apps, settings and files).

## Tests

Every script is covered by Pester 5 tests (kept in the private repository): each script must parse, have no PSScriptAnalyzer
Error-severity findings, and behave as documented. Every system call is mocked, so running the tests
never changes the machine.


{% endraw %}
