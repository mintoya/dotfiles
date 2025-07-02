import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

Rectangle {
    id: root

    property string buttonColors: "#46464f"
    property int buttonWidths: 10
    property int buttonHeiths: 10
    property int buttonRadii: 10
    property int active: 0
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

    Column {
        id: rowsContainer

        spacing: 30
        topPadding: tbMargins

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        Rectangle {
            color: root.buttonColors
            width: root.buttonWidths
            height: root.buttonHeiths
            radius: root.buttonRadii
        }

        Rectangle {
            color: root.buttonColors
            width: root.buttonWidths
            height: root.buttonHeiths * 2
            radius: root.buttonRadii
        }

        Rectangle {
            color: root.buttonColors
            width: root.buttonWidths
            height: root.buttonHeiths
            radius: root.buttonRadii
        }

        Rectangle {
            color: root.buttonColors
            width: root.buttonWidths
            height: root.buttonHeiths
            radius: root.buttonRadii
        }

        Rectangle {
            color: root.buttonColors
            width: root.buttonWidths
            height: root.buttonHeiths
            radius: root.buttonRadii
        }

    }

}
