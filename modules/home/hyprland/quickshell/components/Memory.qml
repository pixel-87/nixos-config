import QtQuick
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

RowLayout {
  id: memory
  Layout.alignment: Qt.AlignCenter
  property string used: "0G"

  Process {
    id: memoryProcess
    command: ["sh", "-c", "free -m | awk 'NR==2{printf \"%.1fG\", $3/1024}'"]
    stdout: StdioCollector {
      onStreamFinished: memory.used = text
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: memoryProcess.running = true
  }

  IconImage { source: Quickshell.iconPath("memory-symbolic"); width: 20; height: 20 }
  Text { text: memory.used; color: Settings.colors.foreground; font.pointSize: 12 } 
}
