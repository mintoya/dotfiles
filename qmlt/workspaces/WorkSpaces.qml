import "../"
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

Rectangle {
    // Component.onCompleted: {
    //     root.buttonWidths = 20;
    //     root.buttonHeiths = 20;
    // }
    // might keep padding from vreaking

    id: root

    property string buttonColors: "#46464f"
    property string altButtonCOlors: "#c5bfd8"
    property int buttonRadii: 99
    property int active: (ActiveWindow.workspaceId - 1) % 5
    property int tbMargins: 15

    implicitHeight: rowsContainer.implicitHeight + tbMargins
    color: "transparent"
    // color: "#1f1f25"
    width: parent.width * 0.65
    radius: width / 2

    Item {
        id: rowsContainerContainer

        WorkCanvas {
            id: wcan

            height: repeater1.itemAt(active).height + 20
            y: repeater1.itemAt(active).y - 10
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
                    color: index === root.active ? root.altButtonCOlors : root.buttonColors
                    // color: "transparent"
                    radius: root.buttonRadii

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            ActiveWindow.setWorkspace(index + 1);
                        }
                    }

                }

            }

        }

    }

}
