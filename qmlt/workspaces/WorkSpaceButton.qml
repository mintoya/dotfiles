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


    Behavior on height {
        NumberAnimation {
            duration: 100
        }

    }

}
