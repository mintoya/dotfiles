import QtQuick 2.0
import QtQuick.Shapes

Rectangle {
    id: root

    property string buttonColors: "#46464f"

    color: "#1f1f25"
    width: parent.width * 0.75
    radius: width / 2
    height: 100

    anchors {
        bottom: parent.bottom
        bottomMargin: 15
        horizontalCenter: parent.horizontalCenter
    }

}
