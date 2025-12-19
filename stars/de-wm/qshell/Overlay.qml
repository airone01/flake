import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: overlay
    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    // --- CONFIGURATION ---
    property int leftThickness: 200
    property int thickness: 30
    property int roundness: 20
    property color frameColor: "#000000"
    property color borderColor: "#FF0000"

    // --- INPUT MASK ---
    mask: Region {
        Region {
            x: 0
            y: 0
            width: overlay.leftThickness
            height: overlay.height
        }
    }

    // --- VISUALS ---
    Shape {
        anchors.fill: parent
        layer.enabled: true; layer.samples: 4

        ShapePath {
            strokeWidth: 0; fillColor: overlay.frameColor
            fillRule: ShapePath.OddEvenFill

            // outer box (monitor)
            PathRectangle { x: 0; y: 0; width: overlay.width; height: overlay.height }

            // inner box (hole)
            PathRectangle {
                x: overlay.leftThickness
                y: overlay.thickness
                width: overlay.width - overlay.leftThickness - overlay.thickness
                height: overlay.height - (overlay.thickness * 2)
                radius: overlay.roundness
            }
        }
    }

    // outline
    Rectangle {
        x: overlay.leftThickness
        y: overlay.thickness
        width: overlay.width - overlay.leftThickness - overlay.thickness
        height: overlay.height - (overlay.thickness * 2)

        radius: overlay.roundness
        color: "transparent"
        border.width: 1
        border.color: overlay.borderColor
        antialiasing: true
    }

    // --- YOUR CONTENT ---
    Column {
        x: 0
        y: 0
        width: overlay.leftThickness
        height: overlay.height
        spacing: 20 // Space between widgets

        // Pushing content down a bit
        topPadding: 50

        // 1. Battery
        BatteryWidget {
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // 2. Bluetooth
        BluetoothWidget {
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // 3. Wifi
        // WifiWidget {
        //     anchors.horizontalCenter: parent.horizontalCenter
        // }
    }
}
