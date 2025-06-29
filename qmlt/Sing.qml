// Time.qml

// with this line our type becomes a singleton
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// your singletons should always have Singleton as the type
Singleton {
  id: root
  property string time

  Process {
    id: dateProc
    command: ["nu","-c","hyprctl activewindow -j |from json|get title"]
    running: true

    stdout: StdioCollector {
      onStreamFinished:{
        let raw = this.text.trim()
        raw = raw || "Desktop"
        root.time = raw
      }
    }
  }


  Timer {
    interval: 100
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
}
