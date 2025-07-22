import QtQuick
import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import "workspaces"

PanelWindow {
    id: panel

    color: "transparent"

    Shape {
        id: tlShape

        anchors.fill: parent
        antialiasing: true

        ShapePath {
            strokeWidth: 2
            // strokeColor: "#bfc1d9"
            strokeColor: "transparent"
            fillColor: Style.backgroundColor
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
                x: Style.leftWidth + Style.cornerRadius
                y: Style.topWidth
            }

            PathLine {
                x: width - Style.rightWidth - Style.cornerRadius
                y: Style.topWidth
            }

            PathArc {
                x: width - Style.rightWidth
                y: Style.topWidth + Style.cornerRadius
                radiusX: Style.cornerRadius
                radiusY: Style.cornerRadius
            }

            PathLine {
                x: width - Style.rightWidth
                y: height - Style.bottomWidth - Style.cornerRadius
            }

            PathArc {
                x: width - Style.rightWidth - Style.cornerRadius
                y: height - Style.bottomWidth
                radiusX: Style.cornerRadius
                radiusY: Style.cornerRadius
            }

            PathLine {
                x: Style.leftWidth + Style.cornerRadius
                y: height - Style.bottomWidth
            }

            PathArc {
                x: Style.leftWidth
                y: height - Style.bottomWidth - Style.cornerRadius
                radiusX: Style.cornerRadius
                radiusY: Style.cornerRadius
            }

            PathLine {
                x: Style.leftWidth
                y: Style.topWidth + Style.cornerRadius
            }

            PathArc {
                x: Style.leftWidth + Style.cornerRadius
                y: Style.topWidth
                radiusX: Style.cornerRadius
                radiusY: Style.cornerRadius
            }

        }

    }

    Shape {
        id: border

        antialiasing: true
        anchors.fill: parent

        ShapePath {
            strokeWidth: Style.borderWidth
            strokeColor: Style.borderColor
            fillColor: "transparent"
            startX: Style.leftWidth + Style.cornerRadius
            startY: Style.topWidth

            PathLine {
                x: width - Style.rightWidth - Style.cornerRadius
                y: Style.topWidth
            }

            PathArc {
                x: width - Style.rightWidth
                y: Style.topWidth + Style.cornerRadius
                radiusX: Style.cornerRadius
                radiusY: Style.cornerRadius
            }

            PathLine {
                x: width - Style.rightWidth
                y: height - Style.bottomWidth - Style.cornerRadius
            }

            PathArc {
                x: width - Style.rightWidth - Style.cornerRadius
                y: height - Style.bottomWidth
                radiusX: Style.cornerRadius
                radiusY: Style.cornerRadius
            }

            PathLine {
                x: Style.leftWidth + Style.cornerRadius
                y: height - Style.bottomWidth
            }

            PathArc {
                x: Style.leftWidth
                y: height - Style.bottomWidth - Style.cornerRadius
                radiusX: Style.cornerRadius
                radiusY: Style.cornerRadius
            }

            PathLine {
                x: Style.leftWidth
                y: Style.topWidth + Style.cornerRadius
            }

            PathArc {
                x: Style.leftWidth + Style.cornerRadius
                y: Style.topWidth
                radiusX: Style.cornerRadius
                radiusY: Style.cornerRadius
            }

        }

    }

    Rectangle {
        id: rightSide

        width: Style.rightWidth
        color: "transparent"
        height: panel.height

        WorkSpaces {
            anchors {
                top: parent.top
                topMargin: Style.topWidth
                horizontalCenter: parent.horizontalCenter
            }

        }

        Text {
            id: title

            anchors.centerIn: parent
            color: "#46464f"
            text: ActiveWindow.title
            rotation: 90
            anchors.topMargin: 0

            font {
                pixelSize: 18
            }

        }

        Controls {
        }

        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }

    }

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    mask: Region {
    }

}
