import QtQuick 2.0
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
pragma Singleton
pragma Singleton

Singleton {
    id: root

    property string title

    Process {
        id: dateProc

        command: ["nu", "-c 'hyprctl activewindow -j|from json|get title'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.title = (this.text);
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
