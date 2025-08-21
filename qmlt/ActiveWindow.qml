import QtQuick 2.0
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    property var workspaces:[]
    property var workspaceData:[]

    Process {
        id: workerProc
        running: false
    }
    function runProc(cmd){
      workerProc.command = cmd;
      workerProc.running = true;
    }
    function setWorkspace(id) {
      runProc(["hyprctl", "dispatch", "workspace", id.toString()]);
    }

    Process {
        id: activeWorkspaceProc

        command: ["hyprctl","activeworkspace","-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                let state = JSON.parse(this.text);
                root.workspaceData = state
            }
        }

    }

    Process {
        id: workspacesProc

        command: ["hyprctl","workspaces","-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
              let state = JSON.parse(this.text);
              root.workspaces = state;
            }
        }

    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: { activeWorkspaceProc.running = true ,workspacesProc.running=true }
    }

}
