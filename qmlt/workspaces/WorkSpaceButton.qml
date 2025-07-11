import "../"
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

Rectangle {
    id: root

    property int actualWidth: Style.workspaceButtonSize
    property int actualHeight: Style.workspaceButtonSize
    required property int index

    width: actualWidth
    height: actualHeight

    anchors {
        horizontalCenter: parent.horizontalCenter
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            root.height = root.actualHeight * 2;
            root.width = root.actualWidth * 1.2;
        }
        onExited: {
            root.height = root.actualHeight;
            root.width = root.actualWidth;
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 100
        }

    }

}
