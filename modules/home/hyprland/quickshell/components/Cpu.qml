import QtQuick
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

RowLayout {
  id: cpu
  Layout.alignment: Qt.AlignCenter
  property string percent: "0"

  Process {
    id: cpuProcess
    command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'"]
    stdout: StdioCollector {
      onStreamFinished: cpu.percent = parseFloat(text).toFixed(0) + "%"
    }
  }
  
  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: cpuProcess.running = true
  }

  IconImage { source: Quickshell.iconPath("cpu-symbolic"); width: 20; height: 20 }
  Text { text: cpu.percent; color: Settings.colors.foreground; font.pointSize: 12 } 
}
