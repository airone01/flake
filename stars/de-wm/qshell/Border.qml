import QtQuick
import Quickshell

PanelWindow {
    id: borderWindow

    // These properties will be set when you use the component
    property int thickness: 20
    property color barColor: "#1e1e2e" // Example hex color

    // Standard PanelWindow settings
    layer: WlrLayer.Top
    exclusionMode: ExclusionMode.Normal // Reserves space so windows don't cover it

    // The background of the panel
    Rectangle {
        anchors.fill: parent
        color: borderWindow.barColor
    }
}
