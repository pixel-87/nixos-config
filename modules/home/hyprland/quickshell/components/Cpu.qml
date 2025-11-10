import QtQuick
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

Item {
  id: cpuRoot
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: cpuText.implicitWidth
  Layout.preferredHeight: cpuText.implicitHeight
  
  property string percent: "0%"

  Process {
    id: cpuProcess
    command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'"]
    stdout: StdioCollector {
      onStreamFinished: cpuRoot.percent = parseFloat(text).toFixed(0) + "%"
    }
  }
  
  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: cpuProcess.running = true
  }

  Text { 
    id: cpuText
    text: cpuRoot.percent
    color: Settings.colors.foreground
    font.pointSize: 10
    font.family: "monospace"
  }
}
