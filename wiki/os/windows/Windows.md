---
title: "Windows — Power User Handbook"
---
{% raw %}

Personal reference for installing, configuring, maintaining and troubleshooting Windows machines.
Each part covers one Windows release; chapters are numbered so the document can grow into a handbook.

| | |
|---|---|
| **Scope** | Windows 11 (25H2) on the home fleet — machines: [Machine Fleet](../../machine_fleet.md) · OS map: [Operating Systems](../../operating_systems.md) |
| **Scripts** | [Scripts](./scripts/index.md) — documented PowerShell scripts referenced in this handbook |
| **Related** | [Windows 11 — Clean install](./Windows_Install.md) (clean install procedure) |
| **Conventions** | `Win + R` = Run dialog · **Admin** = elevated Terminal (`Win + X` → *Terminal (Admin)*) · code comments in English |

---

## Table of contents

**Part I — Windows 11**

1. [Installation](#c1)
   1. [Installation media](#c1-1)
   2. [Post-install tweaks](#c1-2)
2. [Applications](#c2)
   1. [Browser](#c2-1)
   2. [System & utilities](#c2-2)
   3. [Terminals & shells](#c2-3)
   4. [Development & editors](#c2-4)
   5. [Network & remote access](#c2-5)
   6. [Security & backup](#c2-6)
   7. [Documents](#c2-7)
   8. [Notes](#c2-8)
   9. [Multimedia](#c2-9)
   10. [Gaming](#c2-10)
3. [Drivers](#c3)
   1. [Driver tools](#c3-1)
   2. [AMD Adrenalin + chipset](#c3-2)
   3. [Intel DSA (Wi-Fi / Bluetooth)](#c3-3)
   4. [Windows Update and drivers](#c3-4)
   5. [Verify installed drivers](#c3-5)
   6. [Apple USB SuperDrive](#c3-6)
4. [Power user cheatsheet](#c4)
   1. [winget: install, upgrade, pin versions, snapshot/restore](#c4-1)
   2. [Settings pages from Run (`ms-settings:`)](#c4-2)
   3. [Classic consoles and shortcuts from Run](#c4-3)
   4. [Repair the OS: DISM, SFC, in-place repair](#c4-4)
5. [Troubleshooting](#c5)
   1. [Method: from crash to root cause](#c5-1)
   2. [Case: Settings › Bluetooth crashes (SettingsHandlers_Devices.dll)](#c5-2)
   3. [Case: OneDrive back after an in-place repair](#c5-3)
6. [Machines running Windows 11](#c6)
   1. [Beelink SER8 (`[REDACTED]`)](#c6-1)
7. [Scripts reference](#c7)

---

# Part I — Windows 11

<a id="c1"></a>
## 1. Installation

<a id="c1-1"></a>
### 1.1 Installation media

| Resource | Link |
|---|---|
| Windows 11 25H2 ISO (x64) | [Download Windows 11 — Microsoft](https://www.microsoft.com/software-download/windows11) |
| Windows 11 ISO (ARM64) | [Download Windows 11 for Arm — Microsoft](https://www.microsoft.com/software-download/windows11arm64) |
| WinUtil (MicroWin debloated ISO) | [GitHub — ChrisTitusTech/winutil](https://github.com/ChrisTitusTech/winutil) |
| Video guide (MicroWin install) | [Chris Titus Tech — YouTube](https://www.youtube.com/watch?v=0PA1wgdMeeI) |
| Rufus (bootable USB) | [rufus.ie](https://rufus.ie) |
| Step-by-step procedure | [Windows 11 — Clean install](./Windows_Install.md) |

<a id="c1-2"></a>
### 1.2 Post-install tweaks

| Tweak | Where | Setting |
|---|---|---|
| WinUtil selection (apps + tweaks) | WinUtil → *Import* | SER8 profile: [SER8_Win_11_Config.json](https://github.com/ChrisTitusTech/winutil) |
| PowerToys Quick Accent | PowerToys → Quick Accent | Activation key: **Left/Right Arrow**; character set: **Italian** only |
| PowerToys settings backup | PowerToys → General → **Backup & restore** | Back up after every change |
| OneDrive removal | [Remove-OneDrive.ps1](./scripts/Remove-OneDrive.ps1) | See [5.3](#c5-3) |

> After an in-place repair (see [4.4](#c4-4)), re-apply the WinUtil profile: some tweaks and removed apps come back.

---

<a id="c2"></a>
## 2. Applications

All apps install with `winget install -e --id <Id>`. Pinned versions are explained in [4.1](#c4-1).

> **Current Version** = installed on `[REDACTED]` (Beelink SER8) on 2026-11-02, from `winget list`. Refresh with `winget list` / `winget upgrade`; *available* = newer version offered by winget.

<a id="c2-1"></a>
### 2.1 Browser

| App | Website | Current Version | winget |
|---|---|---|---|
| Brave Browser | [brave.com](https://brave.com) | 156.1.98.63 | `winget install -e --id Brave.Brave` |

<a id="c2-2"></a>
### 2.2 System & utilities

| App | Website | Current Version | winget |
|---|---|---|---|
| WinUtil (Chris Titus) | [GitHub — ChrisTitusTech/winutil](https://github.com/ChrisTitusTech/winutil) | — (runs online) | not on winget — admin PowerShell: `irm christitus.com/win \| iex` |
| PowerToys | [learn.microsoft.com](https://learn.microsoft.com/windows/powertoys) | 0.102.3001.0 | `winget install -e --id Microsoft.PowerToys` |
| 7-Zip | [7-zip.org](https://www.7-zip.org) | 26.03 (26.05 available) | `winget install -e --id 7zip.7zip` |
| OpenLogi | [openlogi.org](https://openlogi.org) | 0.8.9 | `winget install -e --id AprilNEA.OpenLogi` |
| CPU-Z | [cpuid.com/softwares/cpu-z.html](https://www.cpuid.com/softwares/cpu-z.html) | 3.01 | `winget install -e --id CPUID.CPU-Z` |
| CrystalDiskMark | [crystalmark.info](https://crystalmark.info) | 9.0.3 | `winget install -e --id CrystalDewWorld.CrystalDiskMark` |
| Rufus | [rufus.ie](https://rufus.ie) | 4.15 | `winget install -e --id Rufus.Rufus` |
| Carnac (keystroke visualizer) | [GitHub — Code52/carnac](https://github.com/Code52/carnac) | 2.3.13 | `winget install -e --id code52.Carnac` |

<a id="c2-3"></a>
### 2.3 Terminals & shells

| App | Website | Current Version | winget |
|---|---|---|---|
| Windows Terminal | [GitHub — microsoft/terminal](https://github.com/microsoft/terminal) | 1.24.11911.0 | `winget install -e --id Microsoft.WindowsTerminal` |
| WezTerm | [wezterm.org](https://wezterm.org) | 20240203-110809-5046fc22 | `winget install -e --id wez.wezterm` |
| PowerShell 7 | [GitHub — PowerShell/PowerShell](https://github.com/PowerShell/PowerShell) | 7.6.9.0 | `winget install -e --id Microsoft.PowerShell` |
| WSL | [learn.microsoft.com/windows/wsl](https://learn.microsoft.com/windows/wsl) | 2.7.13.0 (2.7.14 available) · kernel 6.18.33.2-2 | `wsl --install` (or `winget install -e --id Microsoft.WSL`) |

<a id="c2-4"></a>
### 2.4 Development & editors

| App | Website | Current Version | winget |
|---|---|---|---|
| Git | [git-scm.com](https://git-scm.com) | 2.55.0.3 | `winget install -e --id Git.Git` |
| Neovim | [neovim.io](https://neovim.io) | 0.12.5 | `winget install -e --id Neovim.Neovim` |
| Notepad++ | [notepad-plus-plus.org](https://notepad-plus-plus.org) | 8.9.8.1 | `winget install -e --id Notepad++.Notepad++` |
| Claude (desktop) | [claude.ai/download](https://claude.ai/download) | 4.4212.0 | `winget install -e --id Anthropic.Claude` |
| Claude Code | [code.claude.com](https://code.claude.com) | 2.1.302 | `winget install -e --id Anthropic.ClaudeCode` (update: `winget upgrade Anthropic.ClaudeCode`) |

#### 2.4.1 Notepad++ plugins
Install via **Plugins → Plugins Admin** (search by name, tick, Install).

| Plugin | Website | Use |
|---|---|---|
| JsonTools | [GitHub — molsonkiko/JsonToolsNppPlugin](https://github.com/molsonkiko/JsonToolsNppPlugin) | JSON tree view, pretty print / compress, queries, schema validation (recommended) |
| JSON Viewer | [GitHub — NPP-JSONViewer/JSON-Viewer](https://github.com/NPP-JSONViewer/JSON-Viewer) | Lightweight JSON tree view and formatting (alternative) |
| AnotherMarkdown (installed: 0.1.12) | [GitHub — ezyuzin/NppAnotherMarkdown](https://github.com/ezyuzin/NppAnotherMarkdown) | Live Markdown preview in a side panel (WebView2 + markdown-it), synced scrolling, dark-mode CSS, Mermaid / KaTeX / PlantUML. Toggle via the purple Markdown toolbar icon; settings in **Plugins → AnotherMarkdown → Settings** |

<a id="c2-5"></a>
### 2.5 Network & remote access

| App | Website | Current Version | winget |
|---|---|---|---|
| WinSCP | [winscp.net](https://winscp.net) | 6.5.6 | `winget install -e --id WinSCP.WinSCP` |
| PuTTY | [putty.org](https://www.putty.org) | 0.85.0.0 | `winget install -e --id PuTTY.PuTTY` |

<a id="c2-6"></a>
### 2.6 Security & backup

| App | Website | Current Version | winget |
|---|---|---|---|
| Bitwarden | [bitwarden.com](https://bitwarden.com) | 2026.9.0 | `winget install -e --id Bitwarden.Bitwarden` |
| Duplicati (pinned: 2.3.0.4) | [duplicati.com](https://duplicati.com) | 2.3.0.4 (pinned; 2.4.1.0 available) | `winget install -e --id Duplicati.Duplicati --version "2.3.0.4"` then `winget pin add -e --id Duplicati.Duplicati --version "2.3.0.4"` |

> **Duplicati pinned to 2.3.0.4**: newer versions fail to start the TrayIcon. The pin keeps `winget upgrade --all` from updating it.
> - Check pins: `winget pin list`
> - Remove pin (when a fixed release is out): `winget pin remove -e --id Duplicati.Duplicati`
> - Before downgrading, export backup jobs (**Export → To file**): newer versions may upgrade the local database. Config lives in `%LOCALAPPDATA%\Duplicati`.

<a id="c2-7"></a>
### 2.7 Documents

| App | Website | Current Version | winget |
|---|---|---|---|
| SumatraPDF | [sumatrapdfreader.org](https://www.sumatrapdfreader.org) | 3.6.1 | `winget install -e --id SumatraPDF.SumatraPDF` |
| LibreOffice | [libreoffice.org](https://www.libreoffice.org) | 26.8.2.2 | `winget install -e --id TheDocumentFoundation.LibreOffice` |

<a id="c2-8"></a>
### 2.8 Notes

| App | Website | Current Version | winget |
|---|---|---|---|
| Joplin | [joplinapp.org](https://joplinapp.org) | 3.7.22 | `winget install -e --id Joplin.Joplin` |

<a id="c2-9"></a>
### 2.9 Multimedia

| App | Website | Current Version | winget |
|---|---|---|---|
| VLC | [videolan.org](https://www.videolan.org) | 3.0.23 | `winget install -e --id VideoLAN.VLC` |
| OBS Studio | [obsproject.com](https://obsproject.com) | 32.0.1 | `winget install -e --id OBSProject.OBSStudio` |

<a id="c2-10"></a>
### 2.10 Gaming

| App | Website | Current Version | winget |
|---|---|---|---|
| Steam | [store.steampowered.com](https://store.steampowered.com) | 2.10.91.91 | `winget install -e --id Valve.Steam` |
| Xbox | [xbox.com/apps](https://www.xbox.com/apps) | 2609.1001.16.0 | `winget install -e --id 9MV0B5HZVK9Z --source msstore` |
| GOG Galaxy (optional) | [gog.com/galaxy](https://www.gog.com/galaxy) | 2.1.10.56 | `winget install -e --id GOG.Galaxy` |
| Battle.net | [battle.net](https://www.blizzard.com/apps/battle.net/desktop) | Unknown (2.0.0.4232 available) | `winget install -e --id Blizzard.BattleNet` |

---

<a id="c3"></a>
## 3. Drivers

> Machine-specific drivers and local driver archive: [6.1 Beelink SER8](#c6-1). Hardware datasheet: [Beelink SER8 datasheet](../../fleet/ser_8/beelink_ser_8.md).
> ⚠️ On the Beelink SER8, update the BIOS to **V035.P8C0M0C15.16** before installing new AMD drivers (known chipset conflict).

<a id="c3-1"></a>
### 3.1 Driver tools

| App | Website | Current Version | winget |
|---|---|---|---|
| AMD Auto-Detect and Install Tool (chipset + Adrenalin) | [amd.com](https://www.amd.com/en/support/download/drivers.html) | not installed — chipset 6.02.07.2300 (Beelink pack), Adrenalin not installed | not on winget — download from the AMD site |
| Intel Driver & Support Assistant (DSA) | [intel.com](https://www.intel.com/content/www/us/en/support/detect.html) | not installed | `winget install -e --id Intel.IntelDriverAndSupportAssistant` |

Script: [Install-DriverTools.ps1](./scripts/Install-DriverTools.ps1) detects Intel/AMD hardware, then installs DSA and/or opens the AMD download page.

<a id="c3-2"></a>
### 3.2 AMD Adrenalin + chipset
1. Download **AMD Auto-Detect and Install Tool** (~50 MB) from the AMD site and run it.
2. It detects the CPU (Ryzen 7 8745HS) and offers **Chipset** + **AMD Software: Adrenalin Edition** → install both.
3. Adrenalin installer: **Full Install** (or *Minimal* for the driver only) and tick **Factory Reset** to remove the old OEM driver.
4. Reboot.
5. AMD Software → ⚙️ **Settings → System → Software & Driver Updates**: *Check for updates* = **automatic**, branch = **Recommended** (not *Optional*).

Adrenalin auto-updates **graphics only**. For the chipset, re-run the Auto-Detect tool every 2–3 months.

<a id="c3-3"></a>
### 3.3 Intel DSA (Wi-Fi / Bluetooth)
1. Install with winget (see [3.1](#c3-1)).
2. Click the blue Intel tray icon → a local web page scans the PC.
3. It detects the AX200 and offers **Wi-Fi** + **Bluetooth** updates → *Download all* → *Install all*.
4. Reboot. DSA then runs in background and notifies new Intel drivers.

<a id="c3-4"></a>
### 3.4 Windows Update and drivers
- Optional driver updates: **Settings → Windows Update → Advanced options → Optional updates → Driver updates** (manual selection), or `Win + R` → `ms-settings:windowsupdate-optionalupdates`.
- The WinUtil *Security* update preset blocks drivers from Windows Update (policy `ExcludeWUDriversInQualityUpdate = 1`). With vendor tools (AMD, Intel) this is the preferred setup: Windows does not overwrite them with generic drivers.
- Check / change the policy: [Test-WUDriverPolicy.ps1](./scripts/Test-WUDriverPolicy.ps1)

```powershell
# 1 = drivers excluded from Windows Update, key missing = drivers allowed
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate
```

<a id="c3-5"></a>
### 3.5 Verify installed drivers
Device Manager (`devmgmt.msc`) → device → *Properties* → *Driver*:

| Device | Expected |
|---|---|
| Display adapters → AMD Radeon 780M | driver date 2026 (not 2024) |
| Network adapters → Intel Wi-Fi 6 AX200 | version > 22.230 |
| Bluetooth → Intel Wireless Bluetooth | version > 22.230 |

```powershell
# Driver version and date of every present device, newest first
Get-CimInstance Win32_PnPSignedDriver | Where-Object DeviceName |
  Sort-Object DriverDate -Descending | Format-Table DeviceName, DriverVersion, DriverDate -AutoSize
```

<a id="c3-6"></a>
### 3.6 Apple USB SuperDrive
The Apple USB SuperDrive does not accept discs on a non-Mac PC until the Apple driver sends it the enable command. The driver ships with Apple's Boot Camp Support Software.

| Item | Value |
|---|---|
| Driver | Apple ODD driver **3.1.0.0** (2010-05-17) — installed on `[REDACTED]` |
| Installer | `AppleODDInstaller64.exe` (2.3 MB) — local copy: [drivers/apple/AppleODDInstaller64.exe](https://support.apple.com/kb/DL1837) |
| SHA256 | `574903001f28439a7e3a141b8928e584dc7446521ee7487cad41dfb2434c5baf` |
| Source | [Boot Camp Support Software 5.1.5769 — Apple](https://support.apple.com/kb/DL1837) → `BootCamp\Drivers\Apple\AppleODDInstaller64.exe` |

**Install**
1. Connect the SuperDrive **directly** to a USB port of the PC (avoid unpowered hubs: the drive needs full bus power).
2. Run `AppleODDInstaller64.exe` as administrator, accept the license.
3. Unplug and reconnect the drive, insert a disc.

**Verify**

```powershell
# Optical drive seen by Windows + Apple ODD driver package
Get-PnpDevice -Class CDROM | Format-Table Status, FriendlyName -AutoSize
winget list --name "Apple ODD"
```

> Only the ODD installer is needed: do not run the full Boot Camp `Setup.exe` on a non-Mac PC.

---

<a id="c4"></a>
## 4. Power user cheatsheet

<a id="c4-1"></a>
### 4.1 winget: install, upgrade, pin versions, snapshot/restore

#### 4.1.1 Everyday commands

| Task | Command |
|---|---|
| Search a package | `winget search <name>` |
| Package details / available versions | `winget show -e --id <Id>` · `winget show -e --id <Id> --versions` |
| Install (exact id) | `winget install -e --id <Id>` |
| Install a specific version | `winget install -e --id <Id> --version "1.2.3"` |
| List installed packages | `winget list` (filter: `winget list <name>`) |
| Check available upgrades | `winget upgrade` |
| Upgrade everything | `winget upgrade --all` |
| Upgrade one package | `winget upgrade -e --id <Id>` |
| Uninstall | `winget uninstall -e --id <Id>` |
| Export / import installed apps | `winget export -o apps.json` · `winget import -i apps.json` |

#### 4.1.2 Pinning a version
A pin stops `winget upgrade --all` from updating a package (e.g. Duplicati, [2.6](#c2-6)).

| Pin type | Command | Effect |
|---|---|---|
| **Pinning** (default) | `winget pin add -e --id <Id>` | Excluded from `upgrade --all`; still upgradable explicitly with `winget upgrade -e --id <Id>` |
| **Blocking** | `winget pin add -e --id <Id> --blocking` | Never upgraded until the pin is removed |
| **Gating** (version range) | `winget pin add -e --id <Id> --version "2.3.*"` | Upgrades allowed only within the range (e.g. 2.3.x, never 2.4) |

| Manage pins | Command |
|---|---|
| List pins | `winget pin list` |
| Remove a pin | `winget pin remove -e --id <Id>` |
| Remove all pins | `winget pin reset --force` |
| Upgrade including pinned packages | `winget upgrade --all --include-pinned` |

Example — downgrade and freeze a package:

```powershell
# Install the known-good version over the current one, then pin it
winget install -e --id Duplicati.Duplicati --version "2.3.0.4" --force
winget pin add -e --id Duplicati.Duplicati --version "2.3.0.4"
```

#### 4.1.3 Snapshot and restore all apps (the Windows "Brewfile")
`winget export` / `winget import` are the equivalent of `brew bundle dump` / `brew bundle`.

```powershell
# Snapshot (current machine)
winget export -o installed_apps.json --include-versions
# Restore in one go (new machine): latest versions, skip installed and unavailable packages
winget import -i installed_apps.json --ignore-versions --no-upgrade --ignore-unavailable --accept-package-agreements --accept-source-agreements
```

| Option | Effect |
|---|---|
| `--ignore-versions` | Install the latest versions (without it: the exact versions recorded in the JSON) |
| `--no-upgrade` | Skip apps already installed |
| `--ignore-unavailable` | Skip packages no longer available instead of stopping |

- The `winget list` table (`installed_apps.txt`) is **not** valid input: it is a human-readable snapshot only.
- Brewfile-style alternative: a plain text file with one winget Id per line (`#` = comment), installed in a loop.
- `winget import` does **not** restore pins: re-apply them afterwards (e.g. Duplicati, [2.6](#c2-6)).
- The JSON also contains runtimes (VCRedist, .NET, WindowsAppRuntime): harmless, installed or skipped.

Scripts: [Export-WingetApps.ps1](./scripts/Export-WingetApps.ps1) (snapshot JSON + TXT; for this folder: `.\scripts\Export-WingetApps.ps1 -OutDir .`) · [Restore-WingetApps.ps1](./scripts/Restore-WingetApps.ps1) (import from JSON or Id list; re-pin Duplicati with `.\scripts\Restore-WingetApps.ps1 -File .\installed_apps.json -Pin @{ 'Duplicati.Duplicati' = '2.3.0.4' }`). Details of all scripts: [Scripts](./scripts/index.md).

Current snapshot of `[REDACTED]`: [installed_apps.json](./installed_apps.json) · [installed_apps.txt](./installed_apps.txt).

<a id="c4-2"></a>
### 4.2 Settings pages from Run (`ms-settings:`)
`Win + R` → type the URI → Enter. Also works in Terminal: `start ms-settings:bluetooth`.

| Area | URI | Page |
|---|---|---|
| **System** | `ms-settings:display` | Display |
| | `ms-settings:sound` | Sound |
| | `ms-settings:notifications` | Notifications |
| | `ms-settings:powersleep` | Power & sleep |
| | `ms-settings:storagesense` | Storage |
| | `ms-settings:multitasking` | Multitasking |
| | `ms-settings:troubleshoot` | Troubleshoot |
| | `ms-settings:recovery` | Recovery (reset, in-place repair) |
| | `ms-settings:activation` | Activation |
| | `ms-settings:about` | About (device specs, rename PC) |
| **Devices** | `ms-settings:bluetooth` | Bluetooth & devices |
| | `ms-settings:printers` | Printers & scanners |
| | `ms-settings:mousetouchpad` | Mouse |
| | `ms-settings:typing` | Typing |
| | `ms-settings:autoplay` | AutoPlay |
| **Network** | `ms-settings:network-status` | Network status |
| | `ms-settings:network-wifi` | Wi-Fi |
| | `ms-settings:network-ethernet` | Ethernet |
| | `ms-settings:network-vpn` | VPN |
| | `ms-settings:network-proxy` | Proxy |
| **Personalization** | `ms-settings:personalization` | Personalization |
| | `ms-settings:personalization-background` | Background |
| | `ms-settings:colors` | Colors / dark mode |
| | `ms-settings:taskbar` | Taskbar |
| | `ms-settings:lockscreen` | Lock screen |
| **Apps** | `ms-settings:appsfeatures` | Installed apps |
| | `ms-settings:defaultapps` | Default apps |
| | `ms-settings:startupapps` | Startup apps |
| | `ms-settings:optionalfeatures` | Optional features |
| **Accounts** | `ms-settings:yourinfo` | Your info |
| | `ms-settings:signinoptions` | Sign-in options |
| **Time & language** | `ms-settings:dateandtime` | Date & time |
| | `ms-settings:regionlanguage` | Language & region |
| **Gaming** | `ms-settings:gaming-gamemode` | Game Mode |
| **Privacy & security** | `ms-settings:privacy` | Privacy & security |
| | `ms-settings:privacy-microphone` | Microphone permissions |
| | `ms-settings:privacy-webcam` | Camera permissions |
| | `ms-settings:windowsdefender` | Windows Security |
| | `ms-settings:developers` | For developers |
| **Windows Update** | `ms-settings:windowsupdate` | Windows Update |
| | `ms-settings:windowsupdate-history` | Update history |
| | `ms-settings:windowsupdate-options` | Advanced options |
| | `ms-settings:windowsupdate-optionalupdates` | Optional updates (drivers) |

> Troubleshooting trick: if Settings crashes, open single pages with these URIs to isolate the broken one (see [5.2](#c5-2)).

<a id="c4-3"></a>
### 4.3 Classic consoles and shortcuts from Run

| Command | Tool |
|---|---|
| `devmgmt.msc` | Device Manager |
| `diskmgmt.msc` | Disk Management |
| `services.msc` | Services |
| `eventvwr.msc` | Event Viewer |
| `taskschd.msc` | Task Scheduler |
| `compmgmt.msc` | Computer Management |
| `gpedit.msc` | Local Group Policy Editor (Pro) |
| `secpol.msc` | Local Security Policy (Pro) |
| `regedit` | Registry Editor |
| `msconfig` | System Configuration (boot options) |
| `msinfo32` | System Information |
| `resmon` · `perfmon` | Resource Monitor · Performance Monitor |
| `winver` | Windows version / build |
| `control` | Control Panel |
| `appwiz.cpl` | Programs and Features |
| `ncpa.cpl` | Network Connections |
| `sysdm.cpl` | System Properties (environment variables, restore points) |
| `powercfg.cpl` | Power Options |
| `mmsys.cpl` | Sound devices (classic) |
| `optionalfeatures` | Windows Features (WSL, Hyper-V, …) |
| `cleanmgr` | Disk Cleanup |
| `mdsched` | Windows Memory Diagnostic |
| `shell:startup` | Startup folder (current user) |
| `shell:appsfolder` | All installed apps |
| `%temp%` | Temp folder |

<a id="c4-4"></a>
### 4.4 Repair the OS: DISM, SFC, in-place repair
Escalation order — try the next step only if the previous one does not help. All commands in **Admin** Terminal.

| Step | Command | What it does | Time |
|---|---|---|---|
| 1 | `DISM /Online /Cleanup-Image /CheckHealth` | Reads the corruption flag of the component store (WinSxS), no scan | seconds |
| 2 | `DISM /Online /Cleanup-Image /ScanHealth` | Full scan of the component store, no repair | 5–15 min |
| 3 | `DISM /Online /Cleanup-Image /RestoreHealth` | Repairs the component store, downloading files from Windows Update | 10–30 min |
| 4 | `sfc /scannow` | Repairs protected system files from the (healthy) component store | 10–20 min |
| 5 | In-place repair: `ms-settings:recovery` → **Fix problems using Windows Update** → *Reinstall now* | Reinstalls the current Windows version, **keeps apps, settings and files** | ~1 h |

Order matters: **DISM first, then SFC** — SFC copies files from the component store, so the store must be healthy.

| Variant | Command |
|---|---|
| SFC check only, no repair | `sfc /verifyonly` |
| Check / repair a single file | `sfc /scanfile=C:\Windows\System32\<file>.dll` |
| DISM offline source (mounted ISO, no internet) | `DISM /Online /Cleanup-Image /RestoreHealth /Source:wim:D:\sources\install.wim:6 /LimitAccess` |
| Image index for the source | `DISM /Get-WimInfo /WimFile:D:\sources\install.wim` |
| Component store size / cleanup | `DISM /Online /Cleanup-Image /AnalyzeComponentStore` · `DISM /Online /Cleanup-Image /StartComponentCleanup` |
| SFC details from the log | `findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log > "%userprofile%\Desktop\sfc.txt"` |
| Disk check (online, read-only) | `chkdsk C: /scan` |

Logs: DISM → `C:\Windows\Logs\DISM\dism.log` · SFC → `C:\Windows\Logs\CBS\CBS.log`.

Script: [Repair-WindowsImage.ps1](./scripts/Repair-WindowsImage.ps1) runs steps 1–4 and extracts the SFC log.

> Notes from experience: `DISM`/`sfc` output is **not** captured by `Start-Transcript` unless piped (`| Out-String`). After step 5, OneDrive and some apps removed by MicroWin come back ([5.3](#c5-3)).

---

<a id="c5"></a>
## 5. Troubleshooting

<a id="c5-1"></a>
### 5.1 Method: from crash to root cause
1. **Read the crash event** — Event Viewer → *Windows Logs → Application*, event **1000** (*Application Error*). The key fields are **Faulting module**, **Exception code** and **Fault offset**. The same module + offset on every crash = deterministic bug, not random corruption.
2. **Isolate** — reproduce on the smallest possible scope (one Settings page, one device, one service).
3. **Bisect** — switch off half of the suspects (e.g. disable a device) and test again.
4. **Repair the OS** — when every external cause is excluded, go through [4.4](#c4-4).

```powershell
# Last 5 application crashes with faulting module
Get-WinEvent -FilterHashtable @{LogName='Application'; Id=1000} -MaxEvents 5 | Format-List TimeCreated, Message
```

Common exception codes:

| Code | Meaning |
|---|---|
| `0xc0000005` | Access violation (invalid memory access) |
| `0xc0000409` | Stack buffer overrun / fail-fast: the app terminated itself after detecting an internal error |
| `0xe0434352` | Unhandled .NET exception |
| `0x80000003` | Breakpoint (debug assertion) |

<a id="c5-2"></a>
### 5.2 Case: Settings › Bluetooth crashes (SettingsHandlers_Devices.dll)
**Machine**: Beelink SER8 `[REDACTED]`, Windows 11 25H2 (MicroWin install) — 2026-11.

**Symptom**: Settings closes on open; `ms-settings:about` and `ms-settings:display` work, `ms-settings:bluetooth` crashes; `control printers` (Devices and Printers) crashes too.

**Evidence**: event 1000, module `SettingsHandlers_Devices.dll`, exception `0xc0000409`, offset always `0x80ef1`. Settings also crashed in background every 75 minutes.

| Step | Script | Result |
|---|---|---|
| 1. Crash triage | [Get-SettingsCrashDiagnostics.ps1](./scripts/Get-SettingsCrashDiagnostics.ps1) | Faulting module identified; no blocking policies |
| 2. Bluetooth stack | [Get-BluetoothSettingsDiagnostics.ps1](./scripts/Get-BluetoothSettingsDiagnostics.ps1) | Services and AppX OK; only suspect: one paired device in *Unknown* state |
| 3. Remove device nodes | [Remove-BluetoothDeviceNode.ps1](./scripts/Remove-BluetoothDeviceNode.ps1) | Still crashing; devices came back (pnputil does not unpair) |
| 4. Adapter bisect | [Test-BluetoothAdapterBisect.ps1](./scripts/Test-BluetoothAdapterBisect.ps1) | Crash also with the adapter **disabled** → not driver/radio |
| 5. API unpair | [Remove-BluetoothPairing.ps1](./scripts/Remove-BluetoothPairing.ps1) | All `1168` (not found): registry entries were leftovers |
| 6. In-place repair | [4.4](#c4-4), step 5 | **Fixed** |

**Conclusion**: damaged/inconsistent system component of the device stack (plausibly side-effect of the debloated image). In-place repair fixed it without losing apps or data.

<a id="c5-3"></a>
### 5.3 Case: OneDrive back after an in-place repair
The in-place repair reinstalls OneDrive. WinUtil may not offer its removal.

1. **Check Known Folder Move** first: if Desktop/Documents/Pictures point inside `OneDrive`, move them back before uninstalling.
2. Uninstall: `winget uninstall -e --id Microsoft.OneDrive` (or *Installed apps* → Microsoft OneDrive → Uninstall).
3. Block it via policy: `HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive` → `DisableFileSyncNGSC = 1` (DWORD).
4. Hide it from the Explorer sidebar; reboot; delete `%USERPROFILE%\OneDrive` if empty.

Script: [Remove-OneDrive.ps1](./scripts/Remove-OneDrive.ps1) (all steps, stops if folders are redirected). Undo: `DisableFileSyncNGSC = 0` + `winget install -e --id Microsoft.OneDrive`.

---

<a id="c6"></a>
## 6. Machines running Windows 11
Windows-specific state of each machine. Hardware specs stay in the machine datasheets ([Machine Fleet](../../machine_fleet.md)).

<a id="c6-1"></a>
### 6.1 Beelink SER8 (`[REDACTED]`)
Hardware: [Beelink SER8 datasheet](../../fleet/ser_8/beelink_ser_8.md) · multiboot with Bazzite ([Operating Systems](../../operating_systems.md)).

#### 6.1.1 Installation

| Item | Value |
|---|---|
| Edition / build | Windows 11 Pro 25H2 (x64), build 26200 (UBR 9457 on 2026-09-29, 9711 on 2026-11-02) |
| Drive | NVMe #0 — Crucial P3 Plus 4 TB, serial [REDACTED] (`C:`, 88 % free on 2026-09-29) |
| Install date | 2025-10-03 (MicroWin image) · in-place repair 2026-11 ([5.2](#c5-2)) |
| DirectX / WDDM | DirectX 12 · WDDM 3.2 |
| WHEA errors | 0 (2026-09-29) |
| Hypervisor | Hyper-V active (virtual Ethernet adapter present) |
| WinUtil profile | [SER8_Win_11_Config.json](https://github.com/ChrisTitusTech/winutil) |
| Installed apps | [installed_apps.json](./installed_apps.json) · versions in [2. Applications](#c2) |

**WinUtil tweaks applied**: UTC time, Activity history off, Brave debloat, Consumer features off, Delivery Optimization off, End task on taskbar, Prevent device metadata from network, Restore point, Storage Sense off, Telemetry off, Delete temp files.

#### 6.1.2 Drivers and updates

| Component | Source | Installed / notes |
|---|---|---|
| BIOS | See the datasheet: [Firmware updates & support](../../fleet/ser_8/beelink_ser_8.md) | **Flash 15.16 before new AMD drivers** (see below) |
| AMD chipset | [AMD Drivers & Support](https://www.amd.com/en/support/download/drivers.html) ([3.2](#c3-2)) | 6.02.07.2300 (Beelink pack) |
| AMD graphics (Radeon 780M) | AMD Adrenalin ([3.2](#c3-2)) | Driver 32.0.12019.1028 (2024-10-11) — Adrenalin not installed |
| Ethernet (Realtek RTL8125) | Windows Update or Realtek | 11.15.0715.2023 |
| Wi-Fi / Bluetooth (Intel AX200) | [Intel Driver & Support Assistant](https://www.intel.com/content/www/us/en/support/detect.html) ([3.3](#c3-3)) | Bluetooth 22.230.0.2 — DSA not installed |
| Audio (Realtek ALC897) | Windows Update or Beelink pack | Realtek Audio Control 1.50.323.0 |
| Apple USB SuperDrive | Boot Camp ([3.6](#c3-6)) | Apple ODD 3.1.0.0 |

> **Known issue (Beelink notice, 2026-06-04):** on SER8 8745HS/8845HS, a Windows update or the latest AMD drivers can cause crashes, stutter or random restarts because they conflict with the preinstalled chipset driver. Fix: BIOS **V035.P8C0M0C15.16**; no reinstall needed. After flashing, update Windows and the AMD drivers as usual.

Update order: BIOS → AMD chipset → AMD Adrenalin → Windows Update (LAN, Wi-Fi, BT) → NVMe firmware. Create a restore point before flashing the BIOS.

#### 6.1.3 Local driver archive (`fleet/ser_8/DRIVERS/`)
Official files from the [Beelink download center — SER8-8745](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) (pack 2024-10, older than current AMD/Intel releases: prefer vendor tools after the BIOS update).

| Component | Version | Local file | Size |
|---|---|---|---|
| AMD chipset | 6.02.07.2300 | [amd_chipset_software_6.02.07.2300.exe](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 66 MB |
| AMD graphics (Radeon 780M) | 24.09 (240925a) | [02_240925a-408327E-ACTE_FP7R2PHT_8745HS.zip](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 1.06 GB |
| AMD graphics (alt. package) | — | [SER8-8745H-Graphic-driver.7z](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 757 MB |
| Wi-Fi Intel AX200 | 22.230.0 | [WiFi-22.230.0-Driver64-Win10-Win11.exe](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 42 MB |
| Bluetooth Intel AX200 | 22.230.0 | [BT-22.230.0-64UWD-Win10-Win11.exe](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 50 MB |
| Ethernet Realtek RTL8125BG | 11.015 | [Install_PCIE_Win11_11015_07152023_08212023.exe](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 4.6 MB |
| Audio Realtek ALC897 | 6.0.9513 (2023-05-09) | [ALC897_9513_UAD_2023_0509_0202.zip](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 32 MB |
| Realtek Audio Console (UWP) | 1.41.290.0 | [RtkUWP_1.41.290.0_x64_bundle_ReleaseSign.appxupload_Windows10_PreinstallKit.zip](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) | 11 MB |
| AMD IPU (Ryzen AI NPU) | — | [AMDIPU.zip](https://dr.bee-link.cn/?dir=uploads%2FSER%2FSER8-8745) — not needed: the 8745HS has no NPU | 91 MB |

BIOS files are archived with the hardware: [Beelink SER8 datasheet — Local firmware archive](../../fleet/ser_8/beelink_ser_8.md).

---

<a id="c7"></a>
## 7. Scripts reference

All scripts are in [Scripts](./scripts/index.md) and have built-in help: `Get-Help .\scripts\<name>.ps1 -Full`.

First run on a new machine (scripts downloaded from another PC may be blocked):

```powershell
# Allow local scripts for the current user, then unblock the folder
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
Get-ChildItem .\scripts\*.ps1 | Unblock-File
```

| Script | Admin | Changes system | Purpose |
|---|---|---|---|
| [Get-SettingsCrashDiagnostics.ps1](./scripts/Get-SettingsCrashDiagnostics.ps1) | ✅ | No | Crash events, Settings policies, AppX state, services, DISM/SFC scan → transcript |
| [Get-BluetoothSettingsDiagnostics.ps1](./scripts/Get-BluetoothSettingsDiagnostics.ps1) | ✅ | No | Bluetooth/device services, paired devices, problem devices, scheduled tasks |
| [Test-BluetoothAdapterBisect.ps1](./scripts/Test-BluetoothAdapterBisect.ps1) | ✅ | Temporarily | Stored pairings, adapter driver; disables the adapter for ~15 s to test Settings |
| [Remove-BluetoothDeviceNode.ps1](./scripts/Remove-BluetoothDeviceNode.ps1) | ✅ | Yes | Lists Bluetooth devices or removes device nodes with `pnputil` (does not unpair) |
| [Remove-BluetoothPairing.ps1](./scripts/Remove-BluetoothPairing.ps1) | ✅ | Yes | Registry backup, then unpairs via `BluetoothRemoveDevice`, testing Settings after each |
| [Repair-WindowsImage.ps1](./scripts/Repair-WindowsImage.ps1) | ✅ | Yes | DISM CheckHealth → ScanHealth → RestoreHealth (optional offline source) → SFC |
| [Remove-OneDrive.ps1](./scripts/Remove-OneDrive.ps1) | ✅ | Yes | Known Folder Move check, uninstall, block via policy, hide from Explorer |
| [Test-WUDriverPolicy.ps1](./scripts/Test-WUDriverPolicy.ps1) | Only with `-Set` | Only with `-Set` | Shows / sets whether Windows Update installs drivers |
| [Install-DriverTools.ps1](./scripts/Install-DriverTools.ps1) | No | Yes | Detects Intel/AMD hardware: installs Intel DSA and/or opens the AMD Auto-Detect download page |
| [Export-WingetApps.ps1](./scripts/Export-WingetApps.ps1) | No | No | Snapshot of installed apps: `installed_apps.json` (restore input) + `installed_apps.txt` (readable) |
| [Restore-WingetApps.ps1](./scripts/Restore-WingetApps.ps1) | No | Yes | One-shot reinstall from JSON (`winget import`) or Id list, then applies the `-Pin` version pins |

{% endraw %}
