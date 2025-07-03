import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

Rectangle {
    id: root

    property int actualWidth
    property int actualHeight

    width: actualWidth
    height: actualHeight

    anchors {
        horizontalCenter: parent.horizontalCenter
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }

}
