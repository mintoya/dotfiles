import QtQuick 2.0
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    property string title
    property int workspaceId
    property var workspaces:[]
    property var workspaceData:[]

    Process {
        id: workspaceProc
        running: false
    }
    function setWorkspace(id) {
        workspaceProc.command = ["hyprctl", "dispatch", "workspace", id.toString()];
        workspaceProc.running = true;
    }

    Process {
        id: activeWorkspaceProc

        command: ["hyprctl","activeworkspace","-j"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                let state = JSON.parse(this.text);
                root.workspaceData = state
                // root.title = state.lastwindowtitle;
                // root.workspaceId = state.id;
                // if (root.title == "")
                //     root.title = "desktop";

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
              for (let i = 0; i < state.length; i++) {
                  let ws = state[i];
                  console.log("Workspace ID:", ws.id, "Name/Title:", ws.name, "Active:", ws.id === root.workspaceId);
              }
            }
        }

    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
          activeWorkspaceProc.running = true
          // ,workspacesProc.running=true 
        }
    }

}
