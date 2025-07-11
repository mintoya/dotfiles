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
    property int workspaceId

    Process {
        id: dateProc

        command: ["nu", "-c 'hyprctl activeworkspace -j'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                let state = JSON.parse(this.text);
                root.title = state.lastwindowtitle;
                root.workspaceId = state.id;
                if (root.title == "")
                    root.title = "desktop";

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
