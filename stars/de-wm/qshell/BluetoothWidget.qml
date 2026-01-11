import QtQuick
import Quickshell
import Quickshell.Bluetooth // <--- The Magic Import

Rectangle {
    width: 40; height: 40
    color: "transparent"

    // 1. Access the main adapter (your PC's bluetooth card)
    property var adapter: Bluetooth.mainAdapter

    Text {
        anchors.centerIn: parent
        color: adapter && adapter.powered ? "#00AAFF" : "#555555"

        // Simple Icon logic (using text for now)
        text: "BT"
    }

    TapHandler {
        // Toggle Bluetooth on click!
        onTapped: {
            if (adapter) adapter.powered = !adapter.powered
        }
    }
}
