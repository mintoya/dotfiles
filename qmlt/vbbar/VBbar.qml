import QtQuick
import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

import "../"

Rectangle {
    id: root

    property int cornerRadius: 25
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

        Repeater {
            model: [{
                "icon": "",
                "type": "volume",
                "set": function(val) {
                    VbServices.setVolume(val);
                },
                "get": function() {
                    // return 50;
                    return VbServices.getVolume();
                }
            }, {
                "icon": "󰃞",
                "type": "brightness",
                "set": function(val) {
                  console.log(val);
                    VbServices.setBrightness(val);
                },
                "get": function() {
                    return VbServices.getBrightness();
                }
            }]

            delegate: Rectangle {
                id: base

                property var selfModel: modelData
                property int percent: modelData.get()

                width: container.innerWidth
                height: 200
                color: Style.inactiveColor
                radius: base.width / 2

                MouseArea {
                    id: ma

                    function range(max, min, val) {
                        return (val < min) ? (min) : ((val > max) ? (max) : (val));
                    }

                    anchors.fill: parent
                    onPositionChanged: {
                        if (pressed) {
                            var val = ma.range(100, 0, 100 - ma.mouseY);
                            base.percent = val;
                        }
                    }
                    onReleased: {
                        var val = ma.range(100, 0, 100 - ma.mouseY);
                        modelData.set(val);
                        base.percent = val;
                    }
                }

                Rectangle {
                    id: inner

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -1
                    color: Style.fgColor
                    width: parent.width
                    radius: parent.radius
                    height: (parent.percent / 100) * (parent.height - 2 * inner.radius) + 2 * inner.radius + 2

                    Text {
                        anchors.centerIn: parent
                        text: modelData.icon
                        // anchors.horizontalCenter: parent.horizontalCenter
                        color: Style.bgColor
                        font.pixelSize: inner.width - 10
                    }

                }

            }

        }

    }

    HoverHandler {
        id: hoverHandler

        onHoveredChanged: {
            if (hovered) {
                for (let i = 0; i < container.children.length; i++) {
                    let item = container.children[i];
                    item.percent = item.selfModel.get();
                }
            }
        }
    }

}
