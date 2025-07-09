import QtQuick 2.0
import QtQuick.Shapes

Item {
    Text {
        // Behavior on anchors.topMargin {
        //     NumberAnimation {
        //         duration: 3000
        //     }
        // }

        id: title

        color: "#46464f"
        text: ActiveWindow.title
        rotation: 90
        anchors.centerIn: parent
        anchors.topMargin: 0

        font {
            pixelSize: 18
        }

    }

}
