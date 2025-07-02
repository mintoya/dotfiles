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
    property int ny: 0

    function sigCall(newYPosition) {
        root.ny = newYPosition + rowsContainer.y + root.tbMargins;
        print(root.ny);
    }

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

        Rectangle {
            id: activeCircle

            width: buttonWidths + 6
            height: buttonHeiths + 6
            radius: 5
            color: "#00ff00"
            anchors.horizontalCenter: parent.horizontalCenter
            y: root.ny - 33
            z: -1 // Make sure it appears behind the buttons
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        Column {
            id: rowsContainer

            spacing: 15
            topPadding: tbMargins

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
            }

            WorkSpaceButton {
                color: root.buttonColors
                actualWidth: root.buttonWidths
                actualHeight: root.buttonHeiths
                radius: root.buttonRadii
                onChangeY: root.sigCall(newYPosition)
            }

            WorkSpaceButton {
                color: root.buttonColors
                actualWidth: root.buttonWidths
                actualHeight: root.buttonHeiths
                radius: root.buttonRadii
                onChangeY: root.sigCall(newYPosition)
            }

            WorkSpaceButton {
                color: root.buttonColors
                actualWidth: root.buttonWidths
                actualHeight: root.buttonHeiths
                radius: root.buttonRadii
                onChangeY: root.sigCall(newYPosition)
            }

        }

    }

    Behavior on ny {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }

    }

}
