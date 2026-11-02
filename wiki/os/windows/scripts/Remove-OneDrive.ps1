<#
.SYNOPSIS
    Safely uninstalls OneDrive and blocks it from coming back.

.DESCRIPTION
    1. Safety check: shows where Desktop, Documents and Pictures point. If any of them is inside
       OneDrive (Known Folder Move), the script stops: move the folders back first, otherwise
       your files stay under %USERPROFILE%\OneDrive and paths change.
    2. Stops OneDrive and uninstalls it with winget (fallback: OneDriveSetup.exe /uninstall).
    3. Sets the policy DisableFileSyncNGSC = 1 (HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive),
       so updates cannot re-enable it.
    4. Hides the OneDrive entry from the Explorer sidebar.

    Undo: set DisableFileSyncNGSC to 0 and reinstall with: winget install -e --id Microsoft.OneDrive

.PARAMETER Force
    Skip the Known Folder Move safety check.

.EXAMPLE
    .\Remove-OneDrive.ps1

.NOTES
    Typical need: after an in-place repair / Windows Update reinstall, OneDrive comes back.
    After a reboot, delete %USERPROFILE%\OneDrive if it is empty.
#>
#Requires -RunAsAdministrator
param(
    [switch]$Force
)

# 1. Known Folder Move check
$folders = [ordered]@{
    Desktop   = [Environment]::GetFolderPath('Desktop')
    Documents = [Environment]::GetFolderPath('MyDocuments')
    Pictures  = [Environment]::GetFolderPath('MyPictures')
}
$folders.GetEnumerator() | ForEach-Object { "{0,-10} {1}" -f $_.Key, $_.Value }

if (-not $Force -and ($folders.Values -match 'OneDrive')) {
    Write-Warning 'One or more folders point inside OneDrive. Move them back first, or rerun with -Force.'
    return
}

# 2. Stop and uninstall
Get-Process OneDrive -ErrorAction SilentlyContinue | Stop-Process -Force
winget uninstall -e --id Microsoft.OneDrive --accept-source-agreements
if ($LASTEXITCODE -ne 0) {
    # Fallback: per-user or system setup binary
    $setup = @(
        "$env:LOCALAPPDATA\Microsoft\OneDrive\*\OneDriveSetup.exe",
        "$env:SystemRoot\System32\OneDriveSetup.exe",
        "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
    ) | ForEach-Object { Get-Item $_ -ErrorAction SilentlyContinue } | Select-Object -First 1
    if ($setup) { & $setup.FullName /uninstall } else { Write-Warning 'OneDriveSetup.exe not found.' }
}

# 3. Block OneDrive via policy
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive' -Force | Out-Null
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive' -Name DisableFileSyncNGSC -Value 1 -Type DWord

# 4. Hide OneDrive from the Explorer navigation pane (current user)
reg add 'HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f | Out-Null

'OneDrive removed and blocked. Reboot, then delete the OneDrive folder if empty.'
