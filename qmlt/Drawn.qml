import QtQuick
import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import "workspaces"
import "vbbar"

PanelWindow {
    id: panel

    function getDate() {
        return ;
    }

    color: "transparent"

    Shape {
        id: tlShape

        anchors.fill: parent
        antialiasing: true

        ShapePath {
            strokeWidth: 2
            // strokeColor: "#bfc1d9"
            strokeColor: "transparent"
            fillColor: Style.bgColor
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

        function windowTitle() {
            var maxLen = 50;
            var valid = true;
            var se = " ...";
            var title = ActiveWindow.workspaceData.lastwindowtitle;
            if (!title) {
                title = "";
                valid = false;
            }
            if (title.length > maxLen) {
                title = title.substring(0, maxLen - se.length);
                title += se;
            }
            var a = {
            };
            a.title = title;
            a.valid = valid;
            return a;
        }

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
            color: Style.secondaryColor
            text: rightSide.windowTitle().title
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
            rotation: (rightSide.windowTitle().valid) ? 90 : 0

            font {
                italic: true
                pixelSize: (Style.rightWidth - 15<20)?(Style.rightWidth-15):(20)
            }

        }



            TimeRect {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: trayish.top
                    bottomMargin: 20
                }
            }

            Controls {
                id: trayish
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom:parent.bottom
                    bottomMargin: 10
                }

            }

        

        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }

    }

    VBbar {
        id: volumebrightness

        anchors {
            left: parent.left
            bottom: parent.bottom
            bottomMargin: Style.cornerRadius * 2
        }

    }

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    mask: Region {
        Region {
            x: rightSide.x
            y: rightSide.y
            width: rightSide.width
            height: rightSide.height
        }

        Region {
            x: volumebrightness.x
            y: volumebrightness.y
            width: volumebrightness.width
            height: volumebrightness.height
        }

    }

}
