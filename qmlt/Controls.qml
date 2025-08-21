import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell.Io

Column {
    id: root
    property var batteryData:[]
    property var wifiData:[]
    property var bluetoothData:[]
    Process{
      id : batteryProc
      command: [ "sh","-c","upower -i /org/freedesktop/UPower/devices/battery_BAT0|jc --upower"]
      running:false
        stdout: StdioCollector {
            onStreamFinished: {
              root.batteryData = JSON.parse( this.text )[0]
            }
        }
    }
    Process{
      id : wifiProc
      command: [ "sh","-c","nmcli device|jc --nmcli"]
      running:false
        stdout: StdioCollector {
            onStreamFinished: {
              root.wifiData = JSON.parse( this.text ).find(wc => wc.type==="wifi")
            }
        }
    }
    Process{
      id : bluetoothProc
      command: [ "sh","-c","jc bluetoothctl show"]
      running:false
        stdout: StdioCollector {
            onStreamFinished: {
              root.bluetoothData = JSON.parse( this.text )[0]
            }
        }
    }
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: { batteryProc.running = true, bluetoothProc.running = true,wifiProc.running=true }
    }

    width: parent.width * 0.75
    height: 100
    spacing: 30

    anchors {
        bottom: parent.bottom
        bottomMargin: 15
        horizontalCenter: parent.horizontalCenter
    }

    function batteryIcon() {
        var batteryLevel = batteryData.detail.percentage
        if (batteryLevel > 90)  return "󰁹"
        if (batteryLevel > 80)  return "󰂂" 
        if (batteryLevel > 70)  return "󰂁" 
        if (batteryLevel > 60)  return "󰂀" 
        if (batteryLevel > 50)  return "󰁿" 
        if (batteryLevel > 40)  return "󰁾" 
        if (batteryLevel > 30)  return "󰁽" 
        if (batteryLevel > 20)  return "󰁼" 
        if (batteryLevel > 10)  return "󰁻" 
        return "󰂎"; 
    }

    Repeater {

        model: [
          { 
            icon : function(){return ""},
            color : function(){return root.wifiData.state !== "connected"?(Style.inactiveColor):(Style.fgColor)}
          },
          { 
            icon : function(){return ""},
            color : function(){return root.bluetoothData.powered === "yes"?(Style.fgColor):(Style.inactiveColor)},
          },
          { 
            icon : function(){return root.batteryIcon()},
            color : function(){return Style.fgColor}
          },
        ]

        delegate: Button {
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                color: "transparent"
                width: parent.width
                height: parent.height

                Text {
                    color: modelData.color()
                    text: modelData.icon()
                    font.pixelSize: root.width * 0.65
                    anchors.centerIn: parent
                }
            }
        }
    }
}

