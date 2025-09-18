import QtQuick 2.0
import QtQml 2.0
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell.Io
import Quickshell

import QtQuick

Column {
    id: root
    property var batteryData: []
    property var wifiData: []
    property var bluetoothData: []

    function launch(cmd): void {
        console.log(cmd);
        Quickshell.execDetached(["sh", "-c", cmd]);
        console.log("done");
    }
    Process {
        id: batteryProc
        command: ["sh", "-c", "upower -i /org/freedesktop/UPower/devices/battery_BAT0|jc --upower"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.batteryData = JSON.parse(this.text)[0];
            }
        }
    }
    Process {
        id: wifiProc
        command: ["sh", "-c", "nmcli device|jc --nmcli"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var data = JSON.parse(this.text).find(wc => wc.type === "wifi");
                if (!data) {
                    root.wifiData = false;
                } else {
                    root.wifiData = data;
                }
            }
        }
    }
    Process {
        id: bluetoothProc
        command: ["sh", "-c", "jc bluetoothctl show"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.bluetoothData = JSON.parse(this.text)[0];
            }
        }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            batteryProc.running = true, bluetoothProc.running = true, wifiProc.running = true;
        }
    }

    width: parent.width * 0.75
    spacing: 20

    function batteryIcon() {
        var batteryLevel = batteryData.detail.percentage;
        var icon = "";
        if (batteryLevel > 90) {
            icon = "󰁹";
        } else if (batteryLevel > 80) {
            icon = "󰂂";
        } else if (batteryLevel > 70) {
            icon = "󰂁";
        } else if (batteryLevel > 60) {
            icon = "󰂀";
        } else if (batteryLevel > 50) {
            icon = "󰁿";
        } else if (batteryLevel > 40) {
            icon = "󰁾";
        } else if (batteryLevel > 30) {
            icon = "󰁽";
        } else if (batteryLevel > 20) {
            icon = "󰁼";
        } else if (batteryLevel > 10) {
            icon = "󰁻";
        } else {
            icon = "󰂎";
        }
        if (batteryData.detail.state === "charging") {
            icon += " 󱐋";
        }
        return icon;
    }

    Repeater {

        model: [
            {
                icon: function () {
                    return "";
                },
                color: function () {
                    return root.wifiData.state !== "connected" ? (Style.inactiveColor) : (Style.fgColor);
                },
                pressed: function () {
                    launch("hyprctl dispatch exec '[float] better-control'");
                },
            },
            {
                icon: function () {
                    return "";
                },
                color: function () {
                    return root.bluetoothData.powered === "yes" ? (Style.fgColor) : (Style.inactiveColor);
                },
                pressed: function () {
                    launch("hyprctl dispatch exec '[float] better-control'");
                }
            },
            {
                icon: function () {
                    return root.batteryIcon();
                },
                color: function () {
                    return Style.fgColor;
                },
                pressed: function () {},
                hoveredIcon: function () {
                    return root.batteryData.detail.percentage;
                }
            },
        ]

        delegate: Button {
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: modelData.pressed()
            width: root.width
            height: root.width * .65
            background: Rectangle {
                color: "transparent"
                width: parent.width
                height: parent.height

                Text {
                    id: textIcon
                    color: modelData.color()
                    text: hHandler.hovered ? (modelData.hoveredIcon? (modelData.hoveredIcon()):(modelData.icon())):(modelData.icon())
                    font.pixelSize: root.width * 0.65
                    anchors.centerIn: parent
                }
                HoverHandler {
                    id: hHandler
                }
            }
        }
    }
}
