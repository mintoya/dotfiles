import QtQuick 2.0
import QtQuick.Shapes

Rectangle {
    // anchors.top: parent.top
    // anchors.topMargin: 100
    radius: 10
    width: 30
    color: "red"

    Behavior on y {
        NumberAnimation {
            duration: 50
            easing: Easing.InQuad
        }

    }

}
