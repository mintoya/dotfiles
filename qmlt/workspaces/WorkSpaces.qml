import "../"
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell

Rectangle {
    // Component.onCompleted: {
    //     root.buttonWidths = 20;
    //     root.buttonHeiths = 20;
    // }
    // might keep padding from vreaking

    id: root

    property int buttonRadii: 99
    property int active: ActiveWindow.workspaceData.id !== undefined 
                      ? (ActiveWindow.workspaceData.id - 1)
                      : 5   // default to 0

    property int tbMargins: 15

    implicitHeight: rowsContainer.implicitHeight + tbMargins
    color: "transparent"
    // color: "#1f1f25"
    width: parent.width * 0.65
    radius: width / 2

    Item {
        id: rowsContainerContainer

        WorkCanvas {
            id: wcan
            height: repeater1.itemAt(active % 5).height + 20
            y: repeater1.itemAt(active % 5).y - 10
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.fgColor
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            fill: parent
        }

        Column {
            id: rowsContainer

            topPadding: tbMargins
            spacing: 25
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                id: repeater1
                model: 5

                WorkSpaceButton {
                  color: 
                  ActiveWindow.workspaces.some(ws => ws.id===( (active/5<1)? index+1:index+6 ))
                    ?Style.fgColor 
                    :Style.inactiveColor

                  radius: root.buttonRadii

                  MouseArea {
                      anchors.fill: parent
                      hoverEnabled:true
                      // onEntered:{ parent.height*=2; }
                      onPressed: { ActiveWindow.setWorkspace(index + 1); }
                  }

                }

            }

        }

    }

}
