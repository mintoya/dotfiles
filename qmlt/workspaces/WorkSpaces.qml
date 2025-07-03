import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

Rectangle {
    id: root

    property string buttonColors: "#46464f"
    property int buttonWidths: 15
    property int buttonHeiths: 15
    property int buttonRadii: 10
    property int active: 1
    property int tbMargins: 20

    color: "#1f1f25"
    width: parent.width * 0.75
    radius: width / 2
    implicitHeight: rowsContainer.implicitHeight + tbMargins

    anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
        topMargin: 10
    }

    Item {
        id: rowsContainerContainer

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        Column {
            id: rowsContainer

            spacing: 15
            topPadding: tbMargins

            WorkCanvas {
            }

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
            }

            WorkSpaceButton {
                color: root.buttonColors
                actualWidth: root.buttonWidths
                actualHeight: root.buttonHeiths
                radius: root.buttonRadii
            }

            WorkSpaceButton {
                color: root.buttonColors
                actualWidth: root.buttonWidths
                actualHeight: root.buttonHeiths
                radius: root.buttonRadii
            }

            WorkSpaceButton {
                color: root.buttonColors
                actualWidth: root.buttonWidths
                actualHeight: root.buttonHeiths
                radius: root.buttonRadii
            }

        }

    }

}
