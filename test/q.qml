import QtQuick
import QtQuick.Shapes
import Quickshell

PanelWindow {
    id: panel

    property string bgColor: "red"

    color: "transparent"
    Component.onCompleted: {
        if (this.WlrLayershell)
            this.WlrLayershell.layer = WlrLayer.Bottom;

    }

    PanelWindow {
        id: topBar

        color: "transparent"
        implicitHeight: 40

        anchors {
            left: true
            top: true
            right: true
        }

    }

    PanelWindow {
        id: leftBar

        color: "transparent"
        implicitWidth: 10

        anchors {
            top: true
            left: true
            bottom: true
        }

    }

    PanelWindow {
        id: rightBar

        color: panel.bgColor
        implicitWidth: 10

        anchors {
            top: true
            right: true
            bottom: true
        }

    }

    PanelWindow {
        id: bottomBar

        color: panel.bgColor
        implicitHeight: 10

        anchors {
            right: true
            left: true
            bottom: true
        }

    }

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Shape {
        id: tlShape

        width: -30
        height: -30

        ShapePath {
            strokeWidth: 1
            strokeColor: "transparent"
            fillColor: panel.bgColor
            startX: leftBar.width
            startY: topBar.height

            PathLine {
                x: leftBar.width
                y: tlShape.height + topBar.height
            }

            PathArc {
                x: tlShape.width + leftBar.width
                y: topBar.height
                radiusX: tlShape.width
                radiusY: tlShape.height
                direction: PathArc.Clockwise
            }

        }

    }

    mask: Region {
        item: tlShape
    }

}
