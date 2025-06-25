pragma Singleton

import "root:/config"
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower

Singleton {
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice.percentage

    property bool isLow: percentage <= BatteryConfig.low / 100
    property bool isCritical: percentage <= BatteryConfig.critical / 100
    property bool isSuspending: percentage <= BatteryConfig.suspend / 100

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging

    onIsLowAndNotChargingChanged: {
        if (available && isLowAndNotCharging) Hyprland.dispatch(`exec notify-send "Low battery" "Consider plugging in your device" -u critical -a "Shell"`)
    }

    onIsCriticalAndNotChargingChanged: {
        if (available && isCriticalAndNotCharging) Hyprland.dispatch(`exec notify-send "Critically low battery" "🙏 I beg for pleas charg\nAutomatic suspend triggers at ${BatteryConfig.suspend}%" -u critical -a "Shell"`)
    }
}
