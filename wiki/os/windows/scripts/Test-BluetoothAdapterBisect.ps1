<#
.SYNOPSIS
    Bisects a Settings > Bluetooth crash: adapter/driver problem or stored device data problem?

.DESCRIPTION
    1. Reports whether previously removed devices came back, and the classic pairings stored in
       HKLM\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters\Devices (MAC + name).
    2. Reports the Bluetooth adapter and its driver version/date.
    3. Shows the latest SystemSettings crash event (module, exception code, offset).
    4. TEST: disables the Bluetooth adapter, opens ms-settings:bluetooth, waits 10 s and checks whether
       SystemSettings.exe is still running. Then closes Settings and re-enables the adapter.

    Result:
      - Settings alive with adapter OFF  -> problem is in the adapter / driver.
      - Settings crashes with adapter OFF -> problem is in stored device data or the Settings handler.

.PARAMETER AdapterInstanceId
    PnP instance ID (wildcards allowed) of the Bluetooth adapter, e.g. 'USB\VID_8087&PID_0029*'.
    Default: auto-detected, i.e. the only present Bluetooth device on the USB or PCI bus. If none or
    more than one is found, the script stops before changing anything and lists the candidates.

.PARAMETER OutFile
    Transcript path. Default: %TEMP%\Test-BluetoothAdapterBisect_<yyyyMMdd-HHmmss>.log

.EXAMPLE
    .\Test-BluetoothAdapterBisect.ps1

.EXAMPLE
    .\Test-BluetoothAdapterBisect.ps1 -AdapterInstanceId 'USB\VID_8087&PID_0026*'

.NOTES
    Bluetooth keyboards and mice stop working for about 15 seconds during the test.
#>
#Requires -RunAsAdministrator
param(
    [string]$AdapterInstanceId,
    [string]$OutFile = (Join-Path ([IO.Path]::GetTempPath()) ('Test-BluetoothAdapterBisect_{0:yyyyMMdd-HHmmss}.log' -f (Get-Date)))
)

# Resolve the adapter first: a wrong or missing adapter stops the script before anything is recorded or changed
if ($AdapterInstanceId) {
    $bt = Get-PnpDevice -InstanceId $AdapterInstanceId -ErrorAction Stop | Select-Object -First 1
} else {
    # The radio is enumerated on the USB or PCI bus; paired devices live under BTHENUM / BTHLE
    $candidates = @(Get-PnpDevice -Class Bluetooth -PresentOnly -ErrorAction SilentlyContinue |
        Where-Object InstanceId -match '^(USB|PCI)\\')
    if ($candidates.Count -ne 1) {
        $found = if ($candidates) { ($candidates | ForEach-Object { "  $($_.InstanceId)  ($($_.FriendlyName))" }) -join "`n" } else { '  none' }
        throw "Cannot pick the Bluetooth adapter automatically ($($candidates.Count) found). Pass -AdapterInstanceId:`n$found"
    }
    $bt = $candidates[0]
}

Start-Transcript -Path $OutFile -Force

"=== Bluetooth devices currently known ==="
Get-PnpDevice -Class Bluetooth | Where-Object InstanceId -match '^(BTHLE|BTHENUM)\\DEV_' |
    Format-Table Status, FriendlyName, InstanceId -AutoSize

"=== Classic BT pairings stored in the registry ==="
Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters\Devices' -ErrorAction SilentlyContinue |
    ForEach-Object {
        $n = (Get-ItemProperty $_.PSPath).Name
        # Device name is stored as a null-terminated UTF-8 byte array
        "{0}  {1}" -f $_.PSChildName, $(if ($n) { [Text.Encoding]::UTF8.GetString($n).Trim([char]0) })
    }

"=== Bluetooth adapter + driver ==="
$bt | Format-List Status, FriendlyName, InstanceId
Get-PnpDeviceProperty -InstanceId $bt.InstanceId DEVPKEY_Device_DriverVersion, DEVPKEY_Device_DriverDate |
    Format-Table KeyName, Data -AutoSize

"=== Latest SystemSettings crash ==="
Get-WinEvent -FilterHashtable @{ LogName = 'Application'; Id = 1000 } -MaxEvents 50 -ErrorAction SilentlyContinue |
    Where-Object Message -match 'SystemSettings' | Select-Object -First 1 | Format-List TimeCreated, Message

"=== TEST: adapter OFF, open Bluetooth page ==="
Disable-PnpDevice -InstanceId $bt.InstanceId -Confirm:$false
try {
    Start-Sleep 3
    Start-Process 'ms-settings:bluetooth'
    Start-Sleep 10
    "SystemSettings running after 10s (adapter OFF): " + [bool](Get-Process SystemSettings -ErrorAction SilentlyContinue)
}
finally {
    # Always restore the adapter, even if the test fails
    Get-Process SystemSettings -ErrorAction SilentlyContinue | Stop-Process -Force
    Enable-PnpDevice -InstanceId $bt.InstanceId -Confirm:$false
    "Adapter re-enabled."
}

Stop-Transcript
