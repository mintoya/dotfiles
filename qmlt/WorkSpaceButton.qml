import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

Rectangle {
    id: root

    property int actualWidth
    property int actualHeight

    signal changeY(int newYPosition)

    width: actualWidth
    height: actualHeight

    anchors {
        horizontalCenter: parent.horizontalCenter
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            console.log(root.x, root.y);
            changeY(root.mapToItem(null, 0, 0).y);
        }
    }

}
