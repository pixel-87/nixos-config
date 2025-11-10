import QtQuick
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

RowLayout {
  id: battery
  Layout.alignment: Qt.AlignCenter
  property string percent: "100%"
  property string icon: "battery-level-100-symbolic"

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

        battery.percent = percentage + "%";
        
        if (state === "charging" || state === "fully-charged") {
          battery.icon = "battery-level-100-charged-symbolic";
        } else if (percentage > 90) {
          battery.icon = "battery-level-100-symbolic";
        } else if (percentage > 60) {
          battery.icon = "battery-level-60-symbolic";
        } else if (percentage > 30) {
          battery.icon = "battery-level-30-symbolic";
        } else {
          battery.icon = "battery-level-10-symbolic";
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

  IconImage { source: Quickshell.iconPath(battery.icon); width: 20; height: 20 }
  Text { text: battery.percent; color: Settings.colors.foreground; font.pointSize: 12 } 
}
