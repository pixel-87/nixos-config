import QtQuick
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

Item {
  id: batRoot
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: batText.implicitWidth
  Layout.preferredHeight: batText.implicitHeight
  
  property string percent: "100%"
  property string status: ""

  Process {
    id: batteryProcess
    command: ["sh", "-c", "upower -i $(upower -e | grep 'BAT') | grep -E 'percentage|state'"]
    stdout: StdioCollector {
      onStreamFinished: {
        var lines = text.split('\n');
        var percentage = 100;
        var state = "fully-charged";
        
        lines.forEach(line => {
          if (line.includes("percentage")) {
            percentage = parseInt(line.split(':')[1].trim().replace('%', ''));
          }
          if (line.includes("state")) {
            state = line.split(':')[1].trim();
          }
        });

        batRoot.percent = percentage + "%";
        
        if (state === "charging") {
          batRoot.status = "+";
        } else if (state === "fully-charged") {
          batRoot.status = "=";
        } else {
          batRoot.status = "";
        }
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: batteryProcess.running = true
  }

  Text { 
    id: batText
    text: batRoot.status + batRoot.percent
    color: Settings.colors.foreground
    font.pointSize: 10
    font.family: "monospace"
  }
}
