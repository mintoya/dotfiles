import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Shapes

Column {
    id: root
    width: parent.width * 0.75
    height: 100
    spacing: 30

    anchors {
        bottom: parent.bottom
        bottomMargin: 15
        horizontalCenter: parent.horizontalCenter
    }
     property int batteryLevel: 100

    function batteryIcon() {
        if (batteryLevel > 80)  return "󰁹"; // full
        if (batteryLevel > 50)  return "󰁾"; // half
        if (batteryLevel > 20)  return "󰁼"; // low
        return "󰂎"; // empty
    }

    Repeater {

        model: [
          { icon : function(){return ""},},
          { icon : function(){return ""},},
          { icon : function(){return root.batteryIcon()},},
        ]

        delegate: Button {
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                color: "transparent"
                width: parent.width
                height: parent.height

                Text {
                    color: Style.fgColor
                    text: modelData.icon()
                    font.pixelSize: root.width * 0.65
                    anchors.centerIn: parent
                }
            }
        }
    }
}

