---
title: "Windows 11 25H2 — Clean install"
---
{% raw %}

Based on the video: [Chris Titus Tech — YouTube](https://www.youtube.com/watch?v=0PA1wgdMeeI).
Written in own words, not a transcript. Back to the handbook: [Windows handbook — 1. Installation](./Windows.md#c1)

## 1. Preparation
- Back up data (e.g. with Duplicati) and license keys.
- Download the official 25H2 ISO: [Download Windows 11 — Microsoft](https://www.microsoft.com/software-download/windows11)
- Snapshot the installed apps for the restore in step 5, to a location that survives the reinstall (default is `%TEMP%`): [Export-WingetApps.ps1](./scripts/Export-WingetApps.ps1) `-OutDir <folder>`
- Verify integrity and compare with the hash published by Microsoft:
  ```powershell
  # Compute SHA256 hash of the ISO
  Get-FileHash .\Win11_25H2.iso -Algorithm SHA256
  ```

## 2. Debloated ISO with MicroWin
1. Run [WinUtil](https://github.com/ChrisTitusTech/winutil) from an admin PowerShell:
   ```powershell
   # Launch Chris Titus Tech's Windows Utility
   irm christitus.com/win | iex
   ```
2. **MicroWin** tab → **Select your own ISO** → pick the downloaded ISO, choose the edition (e.g. Pro).
3. Check **Import drivers from current machine**.
4. Check **Include VirtIO drivers** (needed only for VMs, e.g. Proxmox/KVM).
5. User name: **[REDACTED]** — leave the password **blank** (set it later).
6. Generate the reduced ISO.

## 3. Bootable USB stick
- Create the USB (min. 8 GB) with [Rufus](https://rufus.ie):
  ```powershell
  # Install Rufus
  winget install -e --id Rufus.Rufus
  ```

## 4. Installation
1. Boot from USB (BIOS/UEFI boot menu), choose **Custom install**.
2. Delete the partitions on the system disk and install to unallocated space.
3. On first boot, set the password for user **[REDACTED]**.

## 5. Post-install
- Run Windows Update until complete, then install manufacturer drivers: [Windows handbook — 3. Drivers](./Windows.md#c3).
- WinUtil → **Tweaks**: "Standard" preset; avoid aggressive tweaks (e.g. removing Edge).
- WinUtil → **Import** the machine profile (SER8: [SER8_Win_11_Config.json](https://github.com/ChrisTitusTech/winutil)).
- Reinstall all apps in one go: [Restore-WingetApps.ps1](./scripts/Restore-WingetApps.ps1) `-File <folder>\installed_apps.json` (see [Windows handbook — 4.1.3](./Windows.md#c4-1)), or the winget commands in [Windows handbook — 2. Applications](./Windows.md#c2).
- Remove OneDrive if present: [Remove-OneDrive.ps1](./scripts/Remove-OneDrive.ps1).
- Create a restore point once the system is configured.

{% endraw %}
