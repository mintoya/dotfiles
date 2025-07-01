import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

PanelWindow {
    id: panel

    property int lW: 10
    property int rW: 50
    property int tW: 5
    property int bW: 5
    property int cR: 30
    property string bgColor: "#121318"

    color: "transparent"
    Component.onCompleted: {
        if (this.WlrLayershell)
            this.WlrLayershell.layer = WlrLayer.Bottom;

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
        implicitWidth: panel.rW
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                panel.rW = 80;
            }
            onExited: {
                panel.rW = 40;
            }
        }

        Button {
            id: myButton

            width: 30
            text: "Click Me"
            // anchors.verticalCenter: parent.verticalCenter
            // anchors.left: parent.left
            // anchors.leftMargin: 10
            anchors.centerIn: parent
            onClicked: {
                panel.cR = (panel.cR + 25) % 200 + 25;
            }
        }

        anchors {
            right: true
            top: true
            bottom: true
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

    Shape {
        id: tlShape

        width: panel.cR
        height: panel.cR

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
                radiusX: tlShape.width
                radiusY: tlShape.height
            }

            PathLine {
                x: width - panel.rW
                y: height - panel.bW - panel.cR
            }

            PathArc {
                x: width - panel.rW - panel.cR
                y: height - panel.bW
                radiusX: tlShape.width
                radiusY: tlShape.height
            }

            PathLine {
                x: panel.lW + panel.cR
                y: height - panel.bW
            }

            PathArc {
                x: panel.lW
                y: height - panel.bW - panel.cR
                radiusX: tlShape.width
                radiusY: tlShape.height
            }

            PathLine {
                x: panel.lW
                y: panel.tW + panel.cR
            }

            PathArc {
                x: panel.lW + panel.cR
                y: panel.tW
                radiusX: tlShape.width
                radiusY: tlShape.height
            }

        }

    }

    Behavior on cR {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }

    }

    Behavior on rW {
        NumberAnimation {
            duration: 20
            easing.type: Easing.InOutQuad
        }

    }

    mask: Region {
        item: tlShape
    }

}
