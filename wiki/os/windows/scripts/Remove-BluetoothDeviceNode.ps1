<#
.SYNOPSIS
    Removes Bluetooth device nodes from Device Manager with pnputil (without the Settings app).

.DESCRIPTION
    Useful when Settings > Bluetooth and Control Panel > Devices and Printers both crash.
    Without parameters it lists the Bluetooth devices (BTHENUM = classic, BTHLE = Low Energy) with
    their instance IDs. With -InstanceId it removes the given nodes (and their child GATT services).

    IMPORTANT: this removes the device node only. It does NOT unpair the device: the pairing stays in
    BTHPORT and the device usually comes back after a reboot. To unpair use Remove-BluetoothPairing.ps1.

.PARAMETER InstanceId
    One or more PnP instance IDs, as printed by the list mode, e.g. 'BTHLE\DEV_AABBCCDDEEFF\8&1A2B3C4D&0&AABBCCDDEEFF'.

.EXAMPLE
    .\Remove-BluetoothDeviceNode.ps1
    # Lists Bluetooth devices and their instance IDs

.EXAMPLE
    .\Remove-BluetoothDeviceNode.ps1 -InstanceId 'BTHLE\DEV_AABBCCDDEEFF\8&1A2B3C4D&0&AABBCCDDEEFF'

.NOTES
    Removing a Bluetooth keyboard/mouse disconnects it: keep a USB keyboard/mouse at hand.
#>
#Requires -RunAsAdministrator
param(
    [string[]]$InstanceId
)

if (-not $InstanceId) {
    # List mode: only real devices, not their GATT sub-services
    Get-PnpDevice -Class Bluetooth | Where-Object InstanceId -match '^(BTHLE|BTHENUM)\\DEV_' |
        Format-Table Status, FriendlyName, InstanceId -AutoSize
    return
}

foreach ($id in $InstanceId) {
    "Removing $id"
    pnputil /remove-device "$id" /subtree
    if ($LASTEXITCODE -ne 0) {
        # Older pnputil builds do not support /subtree
        pnputil /remove-device "$id"
    }
}
