import QtQuick
import Quickshell
import Quickshell.Services.UPower // <--- The Magic Import

Rectangle {
    width: 40; height: 40
    color: "transparent"
    radius: 10

    // 1. Get the Display Device (Main Battery)
    property var battery: UPower.displayDevice

    // 2. Change color based on state (Charging vs Discharging)
    property color iconColor: battery.state === UPowerDeviceState.Charging
                              ? "#00FF00" // Green when charging
                              : "#FFFFFF" // White when normal

    Text {
        anchors.centerIn: parent
        color: iconColor
        font.bold: true

        // 3. Bind to the percentage
        text: Math.round(battery.percentage * 100) + "%"
    }

    // Optional: Add a MouseArea to click for details
    TapHandler {
        onTapped: console.log("Battery State: " + battery.state)
    }
}
