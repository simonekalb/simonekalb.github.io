<#
.SYNOPSIS
    Installs the vendor driver-update tools (Intel and/or AMD) that match this machine.

.DESCRIPTION
    - Intel: Intel Driver & Support Assistant (DSA) via winget. Keeps Intel graphics, Wi-Fi, Bluetooth,
      Ethernet and chipset drivers updated.
    - AMD: the AMD Auto-Detect and Install Tool is not on winget, so the script opens the official AMD
      download page. The tool installs Chipset drivers + AMD Software: Adrenalin Edition.

    Without -Vendor the vendors are detected (read-only) from the CPU manufacturer and the present PnP
    devices: PCI vendor 8086 / USB vendor 8087 = Intel, PCI vendor 1002 = AMD graphics.

    After installation (manual steps):
      - Adrenalin: Full Install + Factory Reset, then Settings > System > Software & Driver Updates:
        Check for updates = automatic, branch = Recommended.
      - DSA: click the blue Intel tray icon > Download all > Install all.

.PARAMETER Vendor
    Install the tools for these vendors only, skipping detection: Intel, AMD or both.

.EXAMPLE
    .\Install-DriverTools.ps1

.EXAMPLE
    .\Install-DriverTools.ps1 -Vendor Intel

.NOTES
    Before installing new chipset drivers, check the machine vendor's BIOS/firmware release notes:
    some mini PCs need a BIOS update first.
#>
param(
    [ValidateSet('Intel', 'AMD')]
    [string[]]$Vendor
)

if (-not $Vendor) {
    $cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1).Manufacturer
    $ids = (Get-PnpDevice -PresentOnly -ErrorAction SilentlyContinue).InstanceId -join "`n"
    $Vendor = @(
        if ($cpu -eq 'GenuineIntel' -or $ids -match 'VEN_8086|VID_8087') { 'Intel' }
        if ($cpu -eq 'AuthenticAMD' -or $ids -match 'VEN_1002') { 'AMD' }
    )
    "Detected vendors: $(if ($Vendor) { $Vendor -join ', ' } else { 'none' })"
    if (-not $Vendor) {
        Write-Warning 'No Intel or AMD hardware detected: nothing to install. Use -Vendor to force.'
        return
    }
}

if ('Intel' -in $Vendor) {
    winget install -e --id Intel.IntelDriverAndSupportAssistant --accept-package-agreements --accept-source-agreements
}

if ('AMD' -in $Vendor) {
    # Official download page of the Auto-Detect and Install Tool
    Start-Process 'https://www.amd.com/en/support/download/drivers.html'
}
