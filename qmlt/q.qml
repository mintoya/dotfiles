import Quickshell
import Quickshell.Io
import QtQuick

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: 40

  Text {
    text: Sing.time
    anchors {
      centerIn : parent
    }
  }
}
