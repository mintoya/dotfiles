import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import "workspaces"

PanelWindow {
    // Component.onCompleted: {
    //     if (this.WlrLayershell)
    //         this.WlrLayershell.layer = WlrLayer.Bottom;
    // }

    id: panel

    property int lW: Style.leftWidth
    property int rW: Style.rightWidth
    property int tW: Style.topWidth
    property int bW: Style.bottomWidth
    property int cR: Style.cornerRadius
    property string bgColor: Style.backgroundColor

    color: "transparent"

    Shape {
        id: tlShape

        anchors {
            top: panel.top
            left: panel.left
        }

        ShapePath {
            strokeWidth: 2
            // strokeColor: "#bfc1d9"
            strokeColor: "transparent"
            fillColor: panel.bgColor
            startX: 0
            startY: 0

            PathLine {
                x: 0
                y: height
            }

            PathLine {
                y: height
                x: width
            }

            PathLine {
                x: width
                y: 0
            }

            PathLine {
                x: 0
                y: 0
            }

            PathLine {
                x: panel.lW + panel.cR
                y: panel.tW
            }

            PathLine {
                x: width - panel.rW - panel.cR
                y: panel.tW
            }

            PathArc {
                x: width - panel.rW
                y: panel.tW + panel.cR
                radiusX: panel.cR
                radiusY: panel.cR
            }

            PathLine {
                x: width - panel.rW
                y: height - panel.bW - panel.cR
            }

            PathArc {
                x: width - panel.rW - panel.cR
                y: height - panel.bW
                radiusX: panel.cR
                radiusY: panel.cR
            }

            PathLine {
                x: panel.lW + panel.cR
                y: height - panel.bW
            }

            PathArc {
                x: panel.lW
                y: height - panel.bW - panel.cR
                radiusX: panel.cR
                radiusY: panel.cR
            }

            PathLine {
                x: panel.lW
                y: panel.tW + panel.cR
            }

            PathArc {
                x: panel.lW + panel.cR
                y: panel.tW
                radiusX: panel.cR
                radiusY: panel.cR
            }

        }

    }

    Shape {
        id: border

        antialiasing: true

        anchors {
            top: panel.top
            left: panel.left
        }

        ShapePath {
            strokeWidth: Style.borderWidth
            strokeColor: Style.borderColor
            fillColor: "transparent"
            startX: panel.lW + panel.cR
            startY: panel.tW

            PathLine {
                x: width - panel.rW - panel.cR
                y: panel.tW
            }

            PathArc {
                x: width - panel.rW
                y: panel.tW + panel.cR
                radiusX: panel.cR
                radiusY: panel.cR
            }

            PathLine {
                x: width - panel.rW
                y: height - panel.bW - panel.cR
            }

            PathArc {
                x: width - panel.rW - panel.cR
                y: height - panel.bW
                radiusX: panel.cR
                radiusY: panel.cR
            }

            PathLine {
                x: panel.lW + panel.cR
                y: height - panel.bW
            }

            PathArc {
                x: panel.lW
                y: height - panel.bW - panel.cR
                radiusX: panel.cR
                radiusY: panel.cR
            }

            PathLine {
                x: panel.lW
                y: panel.tW + panel.cR
            }

            PathArc {
                x: panel.lW + panel.cR
                y: panel.tW
                radiusX: panel.cR
                radiusY: panel.cR
            }

        }

    }

    PanelWindow {
        id: rightSide

        implicitWidth: panel.rW
        color: "transparent"

        WorkSpaces {
            anchors {
                top: parent.top
                topMargin: panel.tW
                horizontalCenter: parent.horizontalCenter
            }

        }

        CurrentWindow {
            anchors {
                centerIn: parent
            }

        }

        Controls {
        }

        anchors {
            right: true
            top: true
            bottom: true
        }

    }

    PanelWindow {
        implicitHeight: panel.tW
        color: "transparent"

        anchors {
            left: true
            top: true
            right: true
        }

    }

    PanelWindow {
        implicitHeight: panel.bW
        color: "transparent"

        anchors {
            left: true
            bottom: true
            right: true
        }

    }

    PanelWindow {
        implicitWidth: panel.lW
        color: "transparent"

        anchors {
            left: true
            bottom: true
            top: true
        }

    }

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    mask: Region {
        item: rightSide
    }

    Behavior on rW {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }

    }

}
