import QtQuick
import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

Scope {
    id: root

    Drawn {
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
    }

    Exclusions {
    }

}
