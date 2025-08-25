import QtQuick
import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

Rectangle {
    id: root

    property int cornerRadius: Style.cornerRadius
    property int customRadius: root.cornerRadius
    property int animationDuration: 100
    property int maxWidth: Style.rightWidth * 1.5

    width: Style.leftWidth
    color: "transparent"
    implicitHeight: container.implicitHeight + 40
    // height: 400
    radius: root.customRadius
    states: [
        State {
            name: "hovered"
            when: hoverHandler.hovered

            PropertyChanges {
                target: root
                width: root.maxWidth
                customRadius: root.cornerRadius
            }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation {
                properties: "height"
                duration: root.animationDuration
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                properties: "width"
                duration: root.animationDuration
                easing.type: Easing.OutQuad
            }
        }
    ]

    Shape {
        id: cornersShape

        ShapePath {
            strokeWidth: 2
            strokeColor: Style.borderColor
            fillColor: Style.bgColor
            startX: Style.leftWidth
            startY: -1 * root.customRadius

            PathArc {
                x: (2 * root.customRadius < root.width) ? root.customRadius : root.width - root.customRadius
                y: 0
                direction: PathArc.Counterclockwise
                radiusX: (2 * root.customRadius < root.width) ? root.customRadius : root.width - root.customRadius
                radiusY: root.customRadius
            }

            PathLine {
                x: root.width - root.customRadius
            }

            PathArc {
                x: root.width
                y: root.customRadius
                direction: PathArc.Clockwise
                radiusX: root.customRadius
                radiusY: root.customRadius
            }

            PathLine {
                x: root.width
                y: root.height - root.customRadius
            }

            PathArc {
                x: root.width - root.customRadius
                y: root.height
                direction: PathArc.Clockwise
                radiusX: root.customRadius
                radiusY: root.customRadius
            }

            PathLine {
                x: (2 * root.customRadius < root.width) ? root.customRadius : root.width - root.customRadius
                y: root.height
            }

            PathArc {
                x: Style.leftWidth
                y: root.height + root.customRadius
                direction: PathArc.Counterclockwise
                radiusX: root.customRadius
                radiusY: root.customRadius
            }
        }
    }

    Column {
        id: container

        property int innerWidth: root.maxWidth - 20

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: root.right
        anchors.rightMargin: root.maxWidth / 2 - container.innerWidth / 2
        spacing: 20

    function launch(cmd) {
      console.log(cmd);
        Quickshell.execDetached(["sh", "-c", cmd]);
    }
        Repeater {
            model: [
                {
                    "icon": "⏻",
                    "onpress": function(){container.launch(`sh -c 'shutdown now'`);}
                },
                {
                    "icon": "",
                    "onpress": function(){container.launch(`sh -c 'shutdown -r now'`);}
                },
                {
                    "icon": "",
                    "onpress": function(){ container.launch(`sh -c 'loginctl terminate-user "$(whoami)"'`);}
                }
            ]

            delegate: Rectangle {
                id: base


                width: container.innerWidth
                height: 50
                color: Style.fgColor
                radius: root.cornerRadius
                MouseArea{
                  onPressed:{
                    modelData.onpress()
                  }
                  anchors.fill:parent
                }
                Text {
                  anchors.centerIn:parent
                  id: icon
                  text: modelData.icon
                  font.pixelSize: 19
                }

            }
        }
    }
    HoverHandler {
        id: hoverHandler

    }
}
