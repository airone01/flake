import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    property int thickness: 10

    Overlay {
        thickness: 5
        roundness: 12
        frameColor: "#18181b"
        borderColor: "#3f3f46"
        leftThickness: 50
    }

    // Top
    PanelWindow {
        anchors { top: true; left: true; right: true }

        height: thickness
        WlrLayershell.exclusiveZone: thickness
        WlrLayershell.layer: WlrLayer.Top

        color: "transparent"
    }

    // Bottom
    PanelWindow {
        anchors { bottom: true; left: true; right: true }

        height: thickness
        WlrLayershell.exclusiveZone: thickness
        WlrLayershell.layer: WlrLayer.Top

        color: "transparent"
    }

    // Left
    PanelWindow {
        anchors { left: true; top: true; bottom: true }

        // width: 50
        WlrLayershell.exclusiveZone: 55
        WlrLayershell.layer: WlrLayer.Top

        color: "transparent"
    }
    // Right
    PanelWindow {
        anchors { right: true; top: true; bottom: true }
        width: thickness
        WlrLayershell.exclusiveZone: thickness
        WlrLayershell.layer: WlrLayer.Top
        color: "transparent"
    }
}
