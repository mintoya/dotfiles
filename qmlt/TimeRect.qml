import QtQuick
import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

Rectangle{
  id: root 
  implicitHeight: hours.implicitHeight*( (Style.secondsEnabled)?(3):(2) )+colon.implicitHeight*((Style.secondsEnabled)?(2):(1))
  // height:200
  property int textsize: parent.width - 20
  Column{
    anchors.horizontalCenter:parent.horizontalCenter
    Text{
      id:hours
      anchors.horizontalCenter:parent.horizontalCenter
      text:text.Qt.formatTime(new Date(), "hh")
      color: Style.secondaryColor
      font{
        pixelSize: root.textsize
      }
    }
    Text{
      id: colon
      anchors.horizontalCenter:parent.horizontalCenter
      text:":"
      color: Style.inactiveColor
      font{
        pixelSize: root.textsize
      }
    }
    Text{
      id:minutes
      anchors.horizontalCenter:parent.horizontalCenter
      text:text.Qt.formatTime(new Date(), "mm")
      color: Style.secondaryColor
      font{
        pixelSize: root.textsize
      }
    }
    Text{
      anchors.horizontalCenter:parent.horizontalCenter
      text: Style.secondsEnabled?":":""
      color: Style.inactiveColor
      font{
        pixelSize: root.textsize
      }
    }
    Text{
      id:seconds
      anchors.horizontalCenter:parent.horizontalCenter
      color: Style.secondaryColor
      font{
        pixelSize: root.textsize
      }
    }
  }
    Timer {
        interval: 1000   // update every second
        running: true
        repeat: true
        onTriggered: {
          var time  = new Date()
          hours.text = Qt.formatTime(time, "hh")
          minutes.text = Qt.formatTime(time, "mm")
          if(Style.secondsEnabled){
            seconds.text = Qt.formatTime(time, "ss")
          }
        }
    }
}
