pragma Singleton
import QtQuick

QtObject {
    // property string fgColor: "#c5bfd8"
    // property string bgColor: "#131318"
    // property string inactiveColor: "#46464f"
    // property string secondaryColor:   "#e3e2e9"
    property string fgColor: Colors.primary
    property string bgColor: Colors.surface_dim
    property string inactiveColor: Colors.surface_bright
    property string secondaryColor: Colors.surface_tint
    property int rightWidth: 30



    property int leftWidth: 10
    property int topWidth: 10
    property int bottomWidth: 10
    property int cornerRadius: 35
    property string borderColor: "transparent" //doesnt work
    property int borderWidth: 2
    property int workspaceButtonSize: 10
    property bool secondsEnabled: true
}
