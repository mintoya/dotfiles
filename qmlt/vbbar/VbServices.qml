
import QtQuick 2.0
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root
    function launch(cmd) {
        Quickshell.execDetached(["sh", "-c", cmd]);
    }


    property real volume: 0
    property int brightness: 0

    property int maxBrightness: 100

    Process {
        command: ["sh","-c","brightnessctl max"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
              root.maxBrightness = parseInt(this.text);
            }
        }

    }


    function getVolume(){
      return root.volume*100;
    }
    function setVolume(percentInt){
      console.log(percentInt);
      root.launch( "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + percentInt/100);
    }

    function getBrightness(){
      return root.brightness/root.maxBrightness*100;
    }
    function setBrightness(percentInt){
      console.log(percentInt);
      root.launch("brightnessctl set " + percentInt/100*maxBrightness);
    }


    Process {
        id: volumeProcess

        command: ["sh","-c","wpctl get-volume @DEFAULT_AUDIO_SINK@ "]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
              // expected output looks something kike :
              // Volume: 0.50
              root.volume = parseFloat(this.text.substring(8));
            }
        }

    }
    Process {
        id: brightnessProcess

        command: ["sh","-c","brightnessctl get"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
              // expected output looks something kike :
              // 100
              root.brightness = parseInt(this.text);
            }
        }

    }


    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: { brightnessProcess.running = true ,volumeProcess.running=true }
    }

}
