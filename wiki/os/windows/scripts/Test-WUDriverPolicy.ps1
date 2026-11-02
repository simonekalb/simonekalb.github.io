<#
.SYNOPSIS
    Shows whether Windows Update is allowed to install drivers.

.DESCRIPTION
    Reads the policy ExcludeWUDriversInQualityUpdate under
    HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate:
      - 1           -> drivers excluded from Windows Update (e.g. WinUtil "Security" update preset)
      - 0 / missing -> drivers delivered by Windows Update (Optional updates > Driver updates)

    Read-only. Use -Set to change it (requires admin).

.PARAMETER Set
    'Exclude' writes 1, 'Allow' removes the value.

.EXAMPLE
    .\Test-WUDriverPolicy.ps1
    .\Test-WUDriverPolicy.ps1 -Set Exclude
#>
param(
    [ValidateSet('Exclude', 'Allow')]
    [string]$Set
)

$key  = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
$name = 'ExcludeWUDriversInQualityUpdate'

if ($Set) {
    # Changing the policy needs elevation
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
            [Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'Run as Administrator to change the policy.'
    }
    if ($Set -eq 'Exclude') {
        New-Item -Path $key -Force | Out-Null
        Set-ItemProperty -Path $key -Name $name -Value 1 -Type DWord
    } else {
        Remove-ItemProperty -Path $key -Name $name -ErrorAction SilentlyContinue
    }
}

$value = (Get-ItemProperty -Path $key -Name $name -ErrorAction SilentlyContinue).$name
if ($value -eq 1) {
    "$name = 1 -> Windows Update does NOT install drivers."
} else {
    "$name = $(if ($null -eq $value) { 'not set' } else { $value }) -> Windows Update can install drivers."
}
