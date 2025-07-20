import QtQuick 2.15

Rectangle {
    id: ball

    width: parent.width
    height: 30
    radius: 15
    color: "#c5bfd8"
    anchors.horizontalCenter: parent.horizontalCenter
    transformOrigin: Item.Center
    onYChanged: {
        transformid.yScale = 1.2;
        transformid.xScale = 0.8;
        resetScaleTimer.start(); // wait 300ms then reset scale
    }

    Timer {
        id: resetScaleTimer

        interval: 100 // milliseconds to wait before scaling back
        repeat: false
        onTriggered: {
            transformid.yScale = 1;
            transformid.xScale = 1;
        }
    }

    transform: Scale {
        id: transformid

        origin.x: ball.width / 2
        origin.y: ball.height / 2

        Behavior on xScale {
            NumberAnimation {
                duration: 40
            }

        }

        Behavior on yScale {
            NumberAnimation {
                duration: 40
            }

        }

    }

    Behavior on y {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutCubic
        }

    }

}
