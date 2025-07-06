import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import "workspaces"
import "workspaces/workspaceButton"

Rectangle {
    id: root

    property string buttonColors: "#46464f"
    property int buttonWidths: 20
    property int buttonHeiths: 20
    property int buttonRadii: 10
    property int active: 1
    property int tbMargins: 15

    implicitHeight: rowsContainer.implicitHeight + tbMargins
    color: "#1f1f25"
    width: parent.width * 0.65
    radius: width / 2

    Item {
        id: rowsContainerContainer

        anchors {
            horizontalCenter: parent.horizontalCenter
        }

        WorkCanvas {
        }

        Column {
            id: rowsContainer

            topPadding: 10
            spacing: 10

            anchors {
                horizontalCenter: parent.horizontalCenter
            }

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

}
