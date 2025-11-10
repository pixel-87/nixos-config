import QtQuick
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

Item {
  id: memRoot
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: memText.implicitWidth
  Layout.preferredHeight: memText.implicitHeight
  
  property string used: "0.0G"

  Process {
    id: memoryProcess
    command: ["sh", "-c", "free -m | awk 'NR==2{printf \"%.1fG\", $3/1024}'"]
    stdout: StdioCollector {
      onStreamFinished: memRoot.used = text
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: memoryProcess.running = true
  }

  Text { 
    id: memText
    text: memRoot.used
    color: Settings.colors.foreground
    font.pointSize: 10
    font.family: "monospace"
  }
}
