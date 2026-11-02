<#
.SYNOPSIS
    Unpairs Bluetooth devices through the Windows API (BluetoothRemoveDevice), one at a time,
    and tests Settings > Bluetooth after each removal.

.DESCRIPTION
    1. Exports a backup of HKLM\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters to
       <transcript name>_BTHPORT-backup.reg next to the transcript (restore with: reg import <file>).
    2. For each MAC address: calls BluetoothRemoveDevice, opens ms-settings:bluetooth and checks
       whether SystemSettings.exe is still alive after 8 s. Stops at the first device whose removal
       fixes the crash (unless -NoTest is used).

    Return codes: 0 = unpaired, 1168 = not found (the stack does not consider the device paired;
    a registry entry may still exist as a leftover).

.PARAMETER MacAddress
    MAC addresses, with or without ':' / '-' separators, e.g. 'aabbccddeeff'. Default: list read from
    BTHPORT\Parameters\Devices (classic pairings).

.PARAMETER NoTest
    Unpair only, without opening Settings after each removal.

.PARAMETER OutFile
    Transcript path. Default: %TEMP%\Remove-BluetoothPairing_<yyyyMMdd-HHmmss>.log

.EXAMPLE
    .\Remove-BluetoothPairing.ps1

.EXAMPLE
    .\Remove-BluetoothPairing.ps1 -MacAddress 'aabbccddeeff', '[REDACTED]' -NoTest

.NOTES
    BluetoothRemoveDevice works reliably for classic devices; for Bluetooth LE devices it may return 1168.
    Bluetooth keyboards/mice get unpaired: keep a USB keyboard/mouse at hand.
#>
#Requires -RunAsAdministrator
param(
    [string[]]$MacAddress,
    [switch]$NoTest,
    [string]$OutFile = (Join-Path ([IO.Path]::GetTempPath()) ('Remove-BluetoothPairing_{0:yyyyMMdd-HHmmss}.log' -f (Get-Date)))
)

Start-Transcript -Path $OutFile -Force

# Backup of the Bluetooth stack parameters, named after the transcript
$fullOut = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutFile)
$backup = Join-Path ([IO.Path]::GetDirectoryName($fullOut)) ([IO.Path]::GetFileNameWithoutExtension($fullOut) + '_BTHPORT-backup.reg')
reg export 'HKLM\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters' $backup /y | Out-Null
"Registry backup: $backup"

if (-not $MacAddress) {
    $MacAddress = Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters\Devices' -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty PSChildName
}

Add-Type -Namespace BT -Name Api -MemberDefinition @'
[DllImport("BluetoothAPIs.dll", SetLastError = true)]
public static extern uint BluetoothRemoveDevice(ref ulong pAddress);
'@

foreach ($m in $MacAddress) {
    $hex = $m -replace '[:-]', ''
    # Never call the API with a stale or partial address: skip anything that is not 48-bit hex
    if ($hex -notmatch '^[0-9A-Fa-f]{12}$') {
        Write-Warning "Skipping invalid MAC address: $m"
        continue
    }
    $addr = [Convert]::ToUInt64($hex, 16)
    $rc = [BT.Api]::BluetoothRemoveDevice([ref]$addr)
    "Unpair $m -> rc=$rc (0 = OK, 1168 = not found)"

    if ($NoTest) { continue }

    Start-Sleep 3
    Start-Process 'ms-settings:bluetooth'
    Start-Sleep 8
    $alive = [bool](Get-Process SystemSettings -ErrorAction SilentlyContinue)
    "  Settings alive after removing ${m}: $alive"
    if ($alive) { "  >>> FIXED by removing $m"; break }
}

Stop-Transcript
