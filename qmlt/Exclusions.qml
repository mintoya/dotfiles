import QtQuick 2.15
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

Scope {
    PanelWindow {
        id: leftExclusion

        implicitWidth: Style.leftWidth
        implicitHeight: Screen.height
        color: "transparent"
        exclusiveZone: Style.leftWidth
        anchors.left: true
        Component.onCompleted: {
            if (this.WlrLayershell)
                this.WlrLayershell.layer = WlrLayer.Bottom;

        }
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
    }

    PanelWindow {
        id: rightExclusion

        implicitWidth: Style.rightWidth
        implicitHeight: Screen.height
        color: "transparent"
        anchors.right: true
        exclusiveZone: Style.rightWidth
        Component.onCompleted: {
            if (this.WlrLayershell)
                this.WlrLayershell.layer = WlrLayer.Bottom;

        }
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
    }

    PanelWindow {
        id: topExclusion

        implicitWidth: Screen.width
        implicitHeight: Style.topWidth
        color: "transparent"
        anchors.top: true
        exclusiveZone: Style.topWidth
        Component.onCompleted: {
            if (this.WlrLayershell)
                this.WlrLayershell.layer = WlrLayer.Bottom;

        }
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
    }

    PanelWindow {
        id: bottomExclusion

        implicitWidth: Screen.width
        implicitHeight: Style.bottomWidth
        color: "transparent"
        anchors.bottom: true
        exclusiveZone: Style.bottomWidth
        Component.onCompleted: {
            if (this.WlrLayershell)
                this.WlrLayershell.layer = WlrLayer.Bottom;

        }
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
    }

}
