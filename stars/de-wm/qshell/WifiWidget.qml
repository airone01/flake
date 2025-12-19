import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    // Give it a size so it's visible
    width: 160
    height: 40
    color: "transparent"

    property string wifiName: "Scanning..."

    Process {
        id: wifiProc
        command: ["nmcli", "-t", "-f", "active,ssid", "dev", "wifi"]
        running: false // Start via timer

        stdout.onRead: (data) => {
            if (!data) return
            const lines = data.split("\n")
            for (let i = 0; i < lines.length; i++) {
                if (lines[i].startsWith("yes:")) {
                    wifiName = lines[i].substring(4)
                    return
                }
            }
            // Only update to Disconnected if we didn't find a "yes"
            if (wifiName === "Scanning...") wifiName = "Disconnected"
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!wifiProc.running) wifiProc.running = true
        }
    }

    Text {
        anchors.centerIn: parent
        // Reference the property by the root item's ID or relative path
        text: parent.wifiName
        color: "white"
        font.bold: true
    }
}
