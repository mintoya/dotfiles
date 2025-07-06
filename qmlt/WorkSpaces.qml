import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import "workspaces"
import "workspaces/workspaceButton"

Rectangle {
    id: root

    property string buttonColors: "#46464f"
    property int buttonWidths: 0
    property int buttonHeiths: 0
    property int buttonRadii: 10
    property int active: 1
    property int tbMargins: 15

    Component.onCompleted: {
        root.buttonWidths = 20;
        root.buttonHeiths = 20;
    }
    implicitHeight: rowsContainer.implicitHeight + tbMargins
    color: "#1f1f25"
    width: parent.width * 0.65
    radius: width / 2

    Item {
        id: rowsContainerContainer

        WorkCanvas {
            anchors.horizontalCenter: parent.horizontalCenter
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            fill: parent
        }

        Column {
            id: rowsContainer

            topPadding: tbMargins
            spacing: 25
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                id: repeater1

                model: 5

                WorkSpaceButton {
                    color: index === root.active ? "#c5bfd8" : root.buttonColors
                    actualWidth: root.buttonWidths
                    actualHeight: root.buttonHeiths
                    radius: root.buttonRadii

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            console.log("hello from ", index);
                            root.active = index;
                        }
                    }

                }

            }

        }

    }

    Behavior on active {
        NumberAnimation {
            duration: 50
        }

    }

}
